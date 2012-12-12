package ru.ganzin.apron2.mvn.puremvc.instant.vo
{
	import ru.ganzin.apron2.data.DataContainer;

	public class ResultContainer extends DataContainer
	{
		public function ResultContainer()
		{
			super(false);
		}
		
		public function get result():*
		{
			return getValue("result");
		}
		public function set result(data:*):void
		{
			put("result",data);
		}
	}
}