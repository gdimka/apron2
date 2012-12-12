package ru.ganzin.apron2.mvn.puremvc.startup.model
{
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;
	import org.puremvc.as3.multicore.utilities.loadup.Loadup;
	import org.puremvc.as3.multicore.utilities.loadup.controller.LoadupResourceFailedCommand;
	import org.puremvc.as3.multicore.utilities.loadup.controller.LoadupResourceLoadedCommand;
	import org.puremvc.as3.multicore.utilities.loadup.interfaces.ILoadupProxy;
	import org.puremvc.as3.multicore.utilities.loadup.model.LoadupMonitorProxy;
	import org.puremvc.as3.multicore.utilities.loadup.model.LoadupResourceProxy;

	import ru.ganzin.apron2.mvn.puremvc.startup.controller.RegisterStartupEntityCommand;
	import ru.ganzin.apron2.mvn.puremvc.startup.observer.RegisterStartupEntityNotification;
	import ru.ganzin.apron2.mvn.puremvc.startup.pattern.proxy.StartupEntityProxy;

	public class StartupManagerProxy extends FabricationProxy
	{
		public static const NAME:String = "StartupManagerProxy";
		
		public static const NOTE_STARTUP_LOADING_COMPLETE:String = NAME+"/loadingComplete";
		
		private var startupMonitor:LoadupMonitorProxy;
		
		public function StartupManagerProxy()
		{
			super(NAME);
		}
		
		override public function onRegister():void
		{
			startupMonitor = new LoadupMonitorProxy();
			facade.registerProxy(startupMonitor);
			
			// Регистрируем комманду регистрации подгружаемых элементов
        	facade.registerCommand( RegisterStartupEntityNotification.NOTE_REGISTER_STARTUP_ENTITY, RegisterStartupEntityCommand );
			
			// Вешаемся на все сообщения от StartupManager-а
			facade.registerCommand(Loadup.LOADING_PROGRESS, StartupManagerController);
			facade.registerCommand(Loadup.LOADING_COMPLETE, StartupManagerController);
			facade.registerCommand(Loadup.LOADING_FINISHED_INCOMPLETE, StartupManagerController);
			facade.registerCommand(Loadup.RETRYING_LOAD_RESOURCE, StartupManagerController);
			facade.registerCommand(Loadup.LOAD_RESOURCE_TIMED_OUT, StartupManagerController);
			facade.registerCommand(Loadup.CALL_OUT_OF_SYNC_IGNORED, StartupManagerController);
			facade.registerCommand(Loadup.WAITING_FOR_MORE_RESOURCES, StartupManagerController);
		}
		
		override public function onRemove():void
		{
			startupMonitor.cleanup();
			facade.removeProxy(LoadupMonitorProxy.NAME);
			
			facade.removeCommand(Loadup.LOADING_PROGRESS);
			facade.removeCommand(Loadup.LOADING_COMPLETE);
			facade.removeCommand(Loadup.LOADING_FINISHED_INCOMPLETE);
			facade.removeCommand(Loadup.RETRYING_LOAD_RESOURCE);
			facade.removeCommand(Loadup.LOAD_RESOURCE_TIMED_OUT);
			facade.removeCommand(Loadup.CALL_OUT_OF_SYNC_IGNORED);
			facade.removeCommand(Loadup.WAITING_FOR_MORE_RESOURCES);
		}
		
		public function addStartupEntity(proxy:ILoadupProxy, loadedNotificationName:String, failedNotificationName:String):void
		{
			facade.registerCommand(loadedNotificationName, LoadupResourceLoadedCommand);
			facade.registerCommand(failedNotificationName, LoadupResourceFailedCommand);
			
			var proxyName:String;
			if (proxy is StartupEntityProxy) proxyName = (proxy as StartupEntityProxy).getStartupResourceProxyName();
			else proxyName = proxy.getProxyName()+"/SR";
			
			var r:LoadupResourceProxy = new LoadupResourceProxy(proxyName, proxy);
			facade.registerProxy(r);
			startupMonitor.addResource(r);
		}
		
		public function loadResources():void
		{
			startupMonitor.loadResources();
		}
	}
}

import org.puremvc.as3.multicore.interfaces.INotification;
import org.puremvc.as3.multicore.utilities.loadup.Loadup;

import ru.ganzin.apron2.mvn.puremvc.fabrication.pattern.command.SimpleCommand;
import ru.ganzin.apron2.mvn.puremvc.startup.model.StartupManagerProxy;

/**
 * Обработчик комманд загрузчика ресурсов. При завершение загрузки всех элементов
 * рассылает в ядро и всем модулям комманду CoreConstants.NOTE_STARTUP_LOADING_COMPLETE.
 *  
 * @author Димка
 * 
 */
class StartupManagerController extends SimpleCommand
{
	override public function execute(notification:INotification):void
	{
		switch(notification.getName())
		{
			case Loadup.LOADING_COMPLETE:
				sendNotification(StartupManagerProxy.NOTE_STARTUP_LOADING_COMPLETE);
				routeNotification(StartupManagerProxy.NOTE_STARTUP_LOADING_COMPLETE);
			break;
		}
	}
}