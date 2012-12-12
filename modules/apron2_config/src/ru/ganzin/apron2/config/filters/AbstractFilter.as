package ru.ganzin.apron2.config.filters
{
	import ru.ganzin.apron2.SimpleClass;
	import ru.ganzin.apron2.config.ConfigLoader;
	import ru.ganzin.apron2.config.filters.vo.FilterResultVO;

	public class AbstractFilter extends SimpleClass implements IFilter
	{
		public static const FILTER_DOES_NOT_PROCESSED:* = {type:"FILTER_DOES_NOT_PROCESSED"};
		public static const LISTENING_EVENT:* = {type:"LISTENING_EVENT"};
		
		protected var _loader:ConfigLoader;
		protected var _data:XML;
		
		public function AbstractFilter()
		{
			super();
		}
		
		//-------------------------------------------------
		//	Properties
		//-------------------------------------------------
		
		public function get data():XML
		{
			return _data;
		}

		public function get loader():ConfigLoader
		{
			return _loader;
		}
		public function set loader(value:ConfigLoader):void
		{
			_loader = value;
		}
		
		//-------------------------------------------------
		//	Medhods
		//-------------------------------------------------
		
		public function canApply(data:XML):Boolean
		{
			return false;
		}
		
		public function process(data:XML):void
		{
			_data = data;
			processFilter();
		}
		
		protected function processFilter():*
		{
		}
		
		protected function complete(result:* = null):void
		{
			dispatchEvent(new FilterEvent(FilterEvent.COMPLETE, new FilterResultVO(data,result)));
		}
	}
}