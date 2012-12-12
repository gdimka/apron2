package ru.ganzin.apron2.mvn.puremvc.fabrication.pattern.proxy
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.getQualifiedClassName;

	import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;

	/**
	 * Базовый класс для прокси элементов. Базируется на FabricationProxy.
	 *  
	 * @author Димка
	 * 
	 */	
	public class SimpleProxy extends FabricationProxy implements IEventDispatcher
	{
		protected var eventDispatcher:EventDispatcher;
		
		public function SimpleProxy(proxyName:String=null, data:Object=null)
		{
			super(proxyName, data);
		}
		
		/**
		 * Отправляет сообщение noteName модулю to.
		 *  
		 * @param noteName
		 * @param Object
		 * @param noteBody
		 * @param noteType
		 * 
		 */		
		
		public function routeNotificationTo(noteName:Object, to:Object = null, noteBody:Object = null, noteType:String = null):void
		{
			if (to is String && (to as String).indexOf("/") == -1)	to = String(to) + "/*";
			routeNotification(noteName, noteBody, noteType, to);
		}
	}
}