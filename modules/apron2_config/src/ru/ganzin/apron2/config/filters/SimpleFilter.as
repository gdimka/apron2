package ru.ganzin.apron2.config.filters
{
	public class SimpleFilter extends AbstractFilter
	{
		public function SimpleFilter()
		{
		}
		
		//-------------------------------------------------
		//	Overrided Medhods
		//-------------------------------------------------
		override public function process(data:XML):void
		{
			logger.debug("Process");
			
			_data = data;
			complete(processFilter());
		}
	}
}