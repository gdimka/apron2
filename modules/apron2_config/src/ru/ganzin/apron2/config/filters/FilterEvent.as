package ru.ganzin.apron2.config.filters
{
	import flash.events.Event;

	import ru.ganzin.apron2.config.filters.vo.FilterResultVO;

	public class FilterEvent extends Event
	{
		public static const COMPLETE:String = "filterComplete";
		
		private var _result:FilterResultVO;
		
		public function FilterEvent(type:String, result:FilterResultVO = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_result = result;
		}
		
		//-------------------------------------------------
		//	Properties
		//-------------------------------------------------
		
		public function get result():FilterResultVO
		{
			return _result;
		}

	}
}