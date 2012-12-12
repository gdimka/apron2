package ru.ganzin.apron2.mvn.puremvc.startup.observer
{
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	import org.puremvc.as3.multicore.utilities.loadup.interfaces.ILoadupProxy;

	public class RegisterStartupEntityNotification extends Notification
	{
		public static const NOTE_REGISTER_STARTUP_ENTITY:String = "registerStartupEntity";
		
		public var proxy:ILoadupProxy;
		public var loadedNotificationName:String;
		public var failedNotificationName:String;
		
		public function RegisterStartupEntityNotification(name:String, proxy:ILoadupProxy, loadedNotificationName:String, failedNotificationName:String)
		{
			super(name);
			
			this.proxy = proxy;
			this.loadedNotificationName = loadedNotificationName;
			this.failedNotificationName = failedNotificationName;
		}
	}
}