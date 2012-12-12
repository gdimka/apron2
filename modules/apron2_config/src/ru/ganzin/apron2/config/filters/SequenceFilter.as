package ru.ganzin.apron2.config.filters
{
	public class SequenceFilter extends SimpleFilter
	{
		public function SequenceFilter()
		{
		}
		
		override public function canApply(data:XML):Boolean
		{
			if (data.name() == "sequence") return true;
			else return false;
		}
		
		override protected function processFilter():*
		{
			var parent:XML = data.parent() as XML;
			return null;
		}
		
	}
}