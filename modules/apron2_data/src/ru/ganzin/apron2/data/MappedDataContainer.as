package ru.ganzin.apron2.data
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	import org.as3commons.reflect.Type;

	import ru.ganzin.apron2.events.PropertyChangeEvent;
	import ru.ganzin.apron2.events.PropertyChangeEventKind;
	import ru.ganzin.apron2.interfaces.IPropertyChangeNotifier;
	import ru.ganzin.apron2.utils.StringUtil;

	public class MappedDataContainer extends DataContainer
	{
		public static const OLD_DATA_KEY:String = "$$_old_data";

		private var mapKeys:Dictionary;

		public function MappedDataContainer()
		{
			super();
		}

		private var _disableChildrenUpdateEvent:Boolean = true;

		public function get disableChildrenUpdateEvent():Boolean
		{
			return _disableChildrenUpdateEvent;
		}

		public function set disableChildrenUpdateEvent(value:Boolean):void
		{
			_disableChildrenUpdateEvent = value;
		}

		//-------------------------------------------------
		//	Methods
		//-------------------------------------------------

		public function mapKey(keyName:String, value:*):void
		{
			if (!mapKeys) mapKeys = new Dictionary();
			mapKeys[keyName] = new MapInfo(value);
		}

		public function hasMappedKey(keyName:String):Boolean
		{
			return mapKeys[keyName];
		}

		public function $put(key:*, value:*):void
		{
			super.put(key, value);
			addChangeHandler(value);
		}

		override public function put(key:*, value:*):void
		{
			if (!mapKeys)
			{
				super.put(key, value);
				addChangeHandler(value);
				return;
			}

			var info:MapInfo = mapKeys[key];
			var dc:IDataContainer;
			if (info)
			{
				if (info.clazz)
				{
				}
				if (info.isDataContainer)
				{
					if (value != null && Type.forInstance(value).name != info.className)
					{
						dc = new info.clazz();
						dc.setData(value);
						value = dc;
					}
				}
				else if (info.isVector && (value is Array || value is info.clazz))
				{
					var vector:*;
					if (value is info.clazz) vector = value.concat();
					else
					{
						vector = new info.clazz();
						for each (var o:* in value)
						{
							if (info.vectorSubClassPrimive)
							{
								vector.push(new info.vectorSubClass(o));
							}
							else
							{
								dc = new info.vectorSubClass();
								dc.setData(o);
								vector.push(dc);
							}
						}
					}

					value = vector;
				}
				else if (info.isPrimitiveType)
				{
					switch (info.className)
					{
						case "int": value = int(value);	break;
						case "uint": value = uint(value); break;
						case "Number": value = StringUtil.toNumber(value); break;
						case "Boolean": value = StringUtil.toBoolean(value); break;
						case "String": value = value.toString();  break;
						case "undefined":
						case "null": value = null;  break;
					}
				}
				else if (info.converter)
				{
					value = info.converter.convert(value);
				}
			}

			super.put(key, value);
			addChangeHandler(value);
		}

		public function putQuiet(key:*, value:*):void
		{
			var prevDispatchPropertyChangeEvent:Boolean = dispatchPropertyChangeEvent;
			dispatchPropertyChangeEvent = false;
			var prevDisableChildrenUpdateEvent:Boolean = disableChildrenUpdateEvent;
			disableChildrenUpdateEvent = false;

			put(key, value);

			dispatchPropertyChangeEvent = prevDispatchPropertyChangeEvent;
			disableChildrenUpdateEvent = prevDisableChildrenUpdateEvent;
		}

		override public function setData(data:*):void
		{
			if (!mapKeys)
			{
				super.setData(data);
				return;
			}

			dispatchPropertyChangeEvent = false;

			for (var key:String in data)
				put(key, data[key]);

			put(OLD_DATA_KEY, data);

			dispatchPropertyChangeEvent = true;
			dispatchUpdatePropertiesEvent();
		}

		override public function getData():*
		{
			var retData:Dictionary = new Dictionary();
			var data:* = super.getData();
			delete data[OLD_DATA_KEY];

			var value:*;
			for (var key:String in data)
			{
				value = data[key];
				if (value is IDataContainer) retData[key] = IDataContainer(value).getData();
				else if (isVector(value)) retData[key] = vector2Array(value);
				else retData[key] = value;
			}

			return retData;
		}

		private function addChangeHandler(value:*):void
		{
			if (value is IPropertyChangeNotifier)
				IPropertyChangeNotifier(value).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, childChangedHandler, false, 0, true);
		}

		private function childChangedHandler(e:PropertyChangeEvent):void
		{
			if (!disableChildrenUpdateEvent && hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE))
			{
			    var event:PropertyChangeEvent = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
			    event.kind = PropertyChangeEventKind.UPDATE;
			    event.source = this;

				dispatchEvent(event);
			}
		}

		static private function isVector(vector:*):Boolean
		{
			if (!vector) return false;
			return getQualifiedClassName(vector).indexOf("__AS3__.vec::Vector") == 0;
		}

		static private function vector2Array(vector:*):Array
		{
			var arr:Array = [];
			for each (var value:* in vector) arr.push(value);
			return arr;
		}
	}
}

import org.as3commons.lang.ClassUtils;
import org.as3commons.logging.api.ILogger;
import org.as3commons.logging.api.getLogger;
import org.as3commons.reflect.Type;

import ru.ganzin.apron2.data.IDataContainer;
import ru.ganzin.apron2.data.IDataConverter;
import ru.ganzin.apron2.utils.ObjectUtil;
import ru.ganzin.apron2.utils.StringUtil;

class MapInfo
{
	public const logger:ILogger = getLogger("ru.ganzin.apron2.data.MappedDataContainer.MapInfo");
	public const idcClassFullName:String = ClassUtils.getFullyQualifiedName(IDataContainer, true);

	public var clazz:Class;
	public var converter:IDataConverter;
	public var isDataContainer:Boolean;
	public var isPrimitiveType:Boolean;
	public var isVector:Boolean;
	public var vectorSubClass:Class;
	public var vectorSubClassPrimive:Boolean;
	public var className:String;

	public function MapInfo(value:*)
	{
		try
		{
			if (value is Class)
			{
				clazz = value;

				const type:Type = Type.forClass(clazz);
				isDataContainer = type.interfaces.indexOf(idcClassFullName) != -1;
				isPrimitiveType = ObjectUtil.isPrimitiveType(clazz);

				className = type.name;

				if (className.indexOf("Vector.<") == 0)
				{
					isVector = true;

					var subClassName:String = String(className.split("<")[1]).split(">")[0];
					const subType:Type = Type.forName(subClassName);
					vectorSubClass = subType.clazz;
					vectorSubClassPrimive = ObjectUtil.isPrimitiveType(vectorSubClass);

					if (subType.interfaces.indexOf(idcClassFullName) == -1 && !vectorSubClassPrimive)
						throw new Error(StringUtil.substitute("Класс {0} должен наследоваться от IDataContainer или быть примитивным", subClassName));
				}
				else if (!isDataContainer && !isPrimitiveType)
				{
					throw new Error(StringUtil.substitute("Класс {0} должен наследоваться от IDataContainer либо быть примитивным", className));
				}
			}
			else if (value is IDataConverter) converter = value;
		}
		catch(e:Error)
		{
			logger.error(e.message);
			logger.error(e.getStackTrace());
		}
	}
}
