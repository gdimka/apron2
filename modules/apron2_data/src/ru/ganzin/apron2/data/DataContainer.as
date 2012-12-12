package ru.ganzin.apron2.data
{
	import flash.utils.Dictionary;

	import ru.ganzin.apron2.collections.HashMap;
	import ru.ganzin.apron2.collections.HashMapProxy;
	import ru.ganzin.apron2.collections.IMap;

	public class DataContainer extends HashMapProxy implements IDataContainer
	{
		public function DataContainer(useWeakReferences:Boolean = true)
		{
			super(map = new HashMap(useWeakReferences));
		}

		public function setData(value:*):void
		{
			putAll(value);
		}

		public function getData():*
		{
			var retMap:Dictionary = new Dictionary(HashMap(map).useWeakReferences);
			var dict:Dictionary = IMap(map).getDictonary();
			for (var key:String in dict) retMap[key] = dict[key];
			return retMap;
		}
		
		public function clone():IDataContainer
		{
			var dc:DataContainer = new DataContainer((map as HashMap).useWeakReferences);
			dc.setData(getData());
			return dc;
		}
	}
}