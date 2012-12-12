package ru.ganzin.apron2.mvn.puremvc.startup.pattern.proxy
{
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;
	import org.puremvc.as3.multicore.utilities.loadup.interfaces.ILoadupProxy;
	import org.puremvc.as3.multicore.utilities.loadup.model.LoadupResourceProxy;

	public class StartupEntityProxy extends FabricationProxy implements ILoadupProxy
	{
		public function StartupEntityProxy(proxyName:String=null, data:Object=null)
		{
			super(proxyName, data);
		}
		
		public function getStartupResourceProxyName():String
		{
			return getProxyName() + "/SR";
		}
		
		public function load():void
		{

		}
		
		protected function sendLoadupNotification( noteName:String, noteBody:Object):void 
		{
			var srProxy:LoadupResourceProxy = facade.retrieveProxy(getStartupResourceProxyName()) as LoadupResourceProxy;
			if ( !srProxy.isTimedOut() ) sendNotification(noteName, noteBody);
		}
	}
}