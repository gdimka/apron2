package ru.ganzin.apron2.mvn.puremvc.startup.controller
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;

	import ru.ganzin.apron2.mvn.puremvc.startup.model.StartupManagerProxy;
	import ru.ganzin.apron2.mvn.puremvc.startup.observer.RegisterStartupEntityNotification;

	/**
	 *	Комманда-регистратор подгружаемых элементов в StartupManager. Выполняется сообщением
	 *  RegisterStartupEntityNotification.NOTE_REGISTER_STARTUP_ENTITY
	 *  
	 * @author Димка
	 * 
	 */
	public class RegisterStartupEntityCommand extends SimpleFabricationCommand
	{
		override public function execute( notification:INotification ):void
		{
			var n:RegisterStartupEntityNotification = notification as RegisterStartupEntityNotification;
			var smProxy:StartupManagerProxy = fabFacade.retrieveProxy(StartupManagerProxy.NAME) as StartupManagerProxy;
			smProxy.addStartupEntity(n.proxy, n.loadedNotificationName, n.failedNotificationName);
		}
	}
}
