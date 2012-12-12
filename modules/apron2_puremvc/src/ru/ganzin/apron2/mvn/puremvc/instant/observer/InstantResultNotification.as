package ru.ganzin.apron2.mvn.puremvc.instant.observer
{
	import org.puremvc.as3.multicore.patterns.observer.Notification;

	import ru.ganzin.apron2.data.IDataContainer;
	import ru.ganzin.apron2.mvn.puremvc.instant.vo.ResultContainer;

	public class InstantResultNotification extends Notification
	{
		private var _resultContainer:IDataContainer;
		
		public function InstantResultNotification(name:String, resultContainer:IDataContainer = null, body:*=null, type:String=null)
		{
			super(name,body,type);
			
			if (!resultContainer) resultContainer = new ResultContainer();
			this._resultContainer = resultContainer;
		}
		
		public function get resultContainer():IDataContainer
		{
			return _resultContainer;
		}
	}
}