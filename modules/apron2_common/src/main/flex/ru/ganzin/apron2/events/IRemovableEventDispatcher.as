package ru.ganzin.apron2.events
{
	import flash.events.IEventDispatcher;

	/**
	 * IRemovableEventDispatcher Interface
	 * @author Sascha Balkau
	 */
	public interface IRemovableEventDispatcher extends IEventDispatcher
	{
		/**
		 * Removes all event listeners.
		 */
		function removeAllEventListeners():void;
		
		/**
		 * Removes all events that report to the specified listener.
		 *
		 * @param listener The listener function that processes the event.
		 */
		function removeEventsForListener(listener:Function):void;

		/**
		 * Removes all events of a specific type.
		 *
		 * @param type The type of event.
		 */
		function removeEventsForType(type:String):void;
	}
}