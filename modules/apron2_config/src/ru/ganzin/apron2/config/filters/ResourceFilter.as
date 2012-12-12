package ru.ganzin.apron2.config.filters
{
	import com.adobe.utils.XMLUtil;
	import com.betabong.xml.e4x.E4X;

	import flash.utils.getDefinitionByName;

	import org.as3commons.collections.LinkedMap;
	import org.as3commons.collections.framework.IMap;
	import org.as3commons.collections.framework.IMapIterator;

	import ru.ganzin.apron2.resources.IResourceGroup;
	import ru.ganzin.apron2.resources.Locale;
	import ru.ganzin.apron2.resources.ResourceGroup;
	import ru.ganzin.apron2.utils.StringUtil;
	import ru.ganzin.apron2.utils.uid.UidUtil;

	public class ResourceFilter extends SimpleFilter
	{
		private static const xmlNS:Namespace = new Namespace("http://www.w3.org/XML/1998/namespace");
		private static const apronNS:Namespace = new Namespace("http://apron.googlecode.com/config-ns/");

		public static const SYSTEM_GROUP_NAME:String = "__system__";

		public static const NAME_FIELD_ATTRIBUTE:String = "name-field";
		public static const CLASS_ATTRIBUTE:String = "class";

		public static const DEFAULT_ATTRIBUTE_PREFIX:String = "default-";
		public static const XML_NODE_ATTRIBUTE:String = "xmlNode";

		public static const ROOT_NODE:String = "resources";

		public static var groupCount:uint = 0;

		private var uidMap:IResourceGroup = new ResourceGroup("uids");

		private var resourcesGroup:IResourceGroup;
		private var randomNodeName:Boolean;

		//-------------------------------------------------
		//	Constructor
		//-------------------------------------------------

		public function ResourceFilter(randomNodeName:Boolean = false):void
		{
			this.randomNodeName = randomNodeName;
		}

		//-------------------------------------------------
		//	Overrided Medhods
		//-------------------------------------------------

		override public function canApply(data:XML):Boolean
		{
			return data.name() == ROOT_NODE;
		}

		override protected function processFilter():*
		{
			resourcesGroup = сreateGroupResource(null, data, Locale.ALL);

			if (data.attributes().length() > 0)
			{
				var lang:String = data.@xmlNS::lang;
				if (lang == "") lang = Locale.ALL;

				for each (var attr:XML in data.attributes())
					resourcesGroup.addResource(String(attr.name()), attr.toString(), lang);
			}

			parseXmlData(data, resourcesGroup);

			resourcesGroup.addResourceGroup(uidMap);

			return resourcesGroup;
		}

		//-------------------------------------------------
		//	Medhods
		//-------------------------------------------------

		public function getResourceGroupsByE4X(e4x:String, ...rest):Array
		{
			if (rest.length > 0) e4x = StringUtil.substitute(e4x, rest);

			var ret:Array = new Array();
			var uid:String;

			for each (var node:XML in E4X.evaluate(XMLList(data), e4x))
			{
				uid = node.@uid;
				if (!StringUtil.isEmpty(uid))
				{
					var uidGroup:IResourceGroup = getResourceGroupByUID(uid);
					if (uidGroup) ret.push(uidGroup);
				}
			}

			return ret;
		}

		public function getFirstResourceGroupByE4X(e4x:String, ...rest):IResourceGroup
		{
			rest.unshift(e4x);
			return (getResourceGroupsByE4X.apply(this, rest))[0] as IResourceGroup;
		}

		//-------------------------------------------------
		//	Private Medhods
		//-------------------------------------------------

		private function getResourceGroupByUID(uid:String):IResourceGroup
		{
			try
			{
				return resourcesGroup.getResourceGroup("uids").getObject(uid) as IResourceGroup;
			}
			catch(e:Error)
			{
			}
			return null;
		}

		//-------------------------------------------------
		//	Parse Medhods
		//-------------------------------------------------

		private function parseXmlData(xml:XML, group:IResourceGroup):void
		{
			var newGroup:IResourceGroup;
			for each (var node:XML in xml.*)
			{
				var lang:String = node.@xmlNS::lang;
				if (lang == "") lang = Locale.ALL;
				if (node.nodeKind() != XMLUtil.ELEMENT) continue;
				if (node.children().length() == 1 && node.children()[0].nodeKind() == XMLUtil.TEXT)
				{
					group.addResource(String(node.name()), node.text().toString(), lang);
					continue;
				}

				newGroup = сreateGroupResource(group, node, lang);

				// Выбираем дефотные аттрибуты из родительской группы и добавляем их в новую группу

				var defAttrs:IMap = getDefaultAttributes(group);

				if (defAttrs.size > 0)
				{
					var iter:IMapIterator = IMapIterator(defAttrs.iterator());
					while (iter.hasNext())
					{
						iter.next();
						newGroup.addResource(iter.key, iter.current, lang);
					}
				}

				// Вставляем простые аттрибуты

				if (node.attributes().length() > 0)
				{
					for each (var attr:XML in node.attributes())
						newGroup.addResource(String(attr.name()), attr.toString(), lang);
				}

				// Парсим дальше, если есть вложения

				if (node.children().length() > 0) parseXmlData(node, newGroup);
			}
		}

		private function getDefaultAttributes(group:IResourceGroup):IMap
		{
			var map:LinkedMap = new LinkedMap();
			var iter:IMapIterator = group.getResourcesIterator();

			while (iter.hasNext())
			{
				iter.next();
				if (iter.key.indexOf(DEFAULT_ATTRIBUTE_PREFIX) == 0)
					map.add(iter.key.split(DEFAULT_ATTRIBUTE_PREFIX)[1], iter.current);
			}
			return map;
		}

		private function сreateGroupResource(group:IResourceGroup, node:XML, lang:String):IResourceGroup
		{
			var newGroup:IResourceGroup;
			var name:String = String(node.name());

			if (randomNodeName) name += "_" + UidUtil.getUID(node);

			if (group && group.hasResourceGroup(SYSTEM_GROUP_NAME))
			{
				var parentSystemGroup:IResourceGroup = group.getResourceGroup(SYSTEM_GROUP_NAME);

				if (parentSystemGroup.hasResource(NAME_FIELD_ATTRIBUTE))
				{
					var parentResourceNameField:String = parentSystemGroup.getString(NAME_FIELD_ATTRIBUTE);
					if (!StringUtil.isEmpty(parentResourceNameField)) name = node.attribute(parentResourceNameField);
				}
			}

			var groupClass:Class;
			var groupClassName:String = node.attribute(new QName(apronNS, CLASS_ATTRIBUTE));
			if (!StringUtil.isEmpty(groupClassName))
			{
				try
				{
					groupClass = getDefinitionByName(groupClassName) as Class;
					if (!(groupClass is IResourceGroup))
					{
						logger.error("Class '{0}' does not implement interface IResourceGroup.", [groupClassName]);
						groupClass = null;
					}
				}
				catch(e:Error)
				{
					logger.error("Class '{0}' not found.", [groupClassName]);
				}
			}

			var resourceNameField:String = node.attribute(new QName(apronNS, NAME_FIELD_ATTRIBUTE));

			if (groupClass) newGroup = new groupClass(name);
			else newGroup = new ResourceGroup(name);

			var uid:String = UidUtil.getUID(node);
			node.@uid = uid;
			uidMap.addResource(uid, newGroup);

			var systemGroup:ResourceGroup = new ResourceGroup(SYSTEM_GROUP_NAME);
			systemGroup.addResource(XML_NODE_ATTRIBUTE, node);
			if (!StringUtil.isEmpty(groupClassName)) systemGroup.addResource(CLASS_ATTRIBUTE, groupClassName);
			if (!StringUtil.isEmpty(resourceNameField)) systemGroup.addResource(NAME_FIELD_ATTRIBUTE, resourceNameField);

			newGroup.addResourceGroup(systemGroup);
			if (group) group.addResourceGroup(newGroup, lang);

			return newGroup;
		}

	}
}
