package ru.ganzin.apron2.resources
{
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;

	import org.as3commons.collections.LinkedList;
	import org.as3commons.collections.LinkedMap;
	import org.as3commons.collections.framework.ILinkedList;
	import org.as3commons.collections.framework.ILinkedListIterator;
	import org.as3commons.collections.framework.IMap;
	import org.as3commons.collections.framework.IMapIterator;
	import org.as3commons.collections.framework.IOrderedMap;

	import ru.ganzin.apron2.utils.StringUtil;

	public class ResourceGroup implements IResourceGroup
	{
		private var _name:String;
		
		protected var groups:Dictionary = new Dictionary();
		protected var groupsNamesIdx:Dictionary = new Dictionary();
		protected var resourceMaps:Dictionary = new Dictionary();

		public function ResourceGroup(name:String)
		{
			this._name = name;
//			groups[Locale.ALL] = new LinkedList();
//			resourceMaps[Locale.ALL] = new LinkedMap();
		}
		
		public function get name():String
		{
			return _name;
		}

		public function getClass(resourceName:String, locale:String = Locale.ALL):Class
		{
			var value:* = getValue(resourceName, locale);
			if (value is Class) return value;
			else if (!(value is String)) throw new Error("Resource " + resourceName + " was not setted correctly"); 
			else if (ApplicationDomain.currentDomain.hasDefinition(value))
				return ApplicationDomain.currentDomain.getDefinition(value) as Class;
			return null;
		}

		public function getObject(resourceName:String, locale:String = Locale.ALL):Object
		{
			return getValue(resourceName, locale);        
		}

		public function getInt(resourceName:String, locale:String = Locale.ALL):int
		{
			var value:* = getValue(resourceName, locale);
			return int(value);
		}

		public function getUint(resourceName:String, locale:String = Locale.ALL):uint
		{
			var value:* = getValue(resourceName, locale);
			return uint(value);
		}

		public function getNumber(resourceName:String, locale:String = Locale.ALL):Number
		{
			var value:* = getValue(resourceName, locale);
			return Number(value);
		}

		public function getString(resourceName:String, parameters:Array = null, locale:String = Locale.ALL):String
		{
			var value:String = getValue(resourceName, locale);
			if (parameters) value = StringUtil.substitute(value, parameters);
			return value;
		}

		public function getStringArray(resourceName:String, locale:String = Locale.ALL):Array
		{
			var value:String = getValue(resourceName, locale);
			var array:Array = String(value).split(",");
			var n:int = array.length;
			for (var i:int = 0;i < n; i++)
			{
				array[i] = StringUtil.trim(array[i]);
			}
			return array;
		}

		public function getBoolean(resourceName:String, locale:String = Locale.ALL):Boolean
		{
			var value:* = getValue(resourceName, locale);
			return String(value).toLowerCase() == "true";
		}

		public function addResource(resourceName:String, value:Object, locale:String = Locale.ALL):*
		{
			var map:LinkedMap = resourceMaps[locale];
			if (!map) resourceMaps[locale] = map = new LinkedMap();
			if (map.hasKey(resourceName)) map.replaceFor(resourceName, value);
			else map.add(resourceName, value);
			
			return value;
		}
		
		public function hasResource(resourceName:String, locale:String = Locale.ALL):Boolean
		{
			return resourceMaps[locale] && resourceMaps[locale].hasKey(resourceName);
		}
		
		public function addResourceGroup(group:IResourceGroup = null, locale:String = Locale.ALL):void
		{
			var list:LinkedList = groups[locale];
			if (!list) groups[locale] = list = new LinkedList();

			if (!groupsNamesIdx[locale]) groupsNamesIdx[locale] = new Dictionary();
			groupsNamesIdx[locale][group.name] = uint(1);

			list.add(group);
		}

		public function hasResourceGroup(groupName:String, locale:String = Locale.ALL):Boolean
		{
			return groupsNamesIdx[locale] && groupsNamesIdx[locale][groupName];
		}
		
		public function getResourceGroup(groupName:String, locale:String = Locale.ALL):IResourceGroup
		{
			if (groupsNamesIdx[locale] && groupsNamesIdx[locale][groupName])
			{
				var list:ILinkedList = getGroupsListByLocale(locale);
				var itr:ILinkedListIterator = ILinkedListIterator(list.iterator());
				while(itr.hasNext() && itr.next())
					if(IResourceGroup(itr.current).name == groupName)
						return itr.current;
			}

			throw new Error("Group " + groupName + " was not found in resource bundle");
		}

		public function getResourceGroupsCount(locale:String = Locale.ALL):uint
		{
			if (groups[locale])	return getGroupsListByLocale(locale).size;
			return 0;
		}

		public function getResourceGroupsIterator(locale:String = Locale.ALL):ILinkedListIterator
		{
			return ILinkedListIterator(getGroupsListByLocale(locale).iterator());
		}

		public function getResourcesIterator(locale:String = Locale.ALL):IMapIterator
		{
			return IMapIterator(getResourcesMapByLocale(locale).iterator());
		}

		protected function getValue(resourceName:String, locale:String):*
		{
			var map:IMap = getResourcesMapByLocale(locale);

			if (map.hasKey(resourceName)) return map.itemFor(resourceName);
			else throw new Error("Resource " + resourceName + " was not found in resource bundle");
		}

		protected function getResourcesMapByLocale(locale:String):IOrderedMap
		{
			var value:LinkedMap = resourceMaps[locale];
			if (!value) throw new Error("Resources with locale " + locale + " was not found");
			return value;
		}

		protected function getGroupsListByLocale(locale:String):ILinkedList
		{
			var value:LinkedList = groups[locale];
			if (!value) throw new Error("Groups with locale " + locale + " was not found");
			return value;
		}
	}
}
