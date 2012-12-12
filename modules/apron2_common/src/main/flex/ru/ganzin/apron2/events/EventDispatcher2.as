package ru.ganzin.apron2.events
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	import ru.ganzin.apron2.apron_internal;

	public class EventDispatcher2 extends EventDispatcher implements IRemovableEventDispatcher
	{
		private var manager:EventListenersManager;

		protected var disposed:Boolean = false;

		public function EventDispatcher2(target:IEventDispatcher = null)
		{
			super(target);

			if (target == null) target = this;

			if (target is EventDispatcher2)
			{
				manager = new EventListenersManager(target, (target as EventDispatcher2).apron_internal::addEventListener,
						(target as EventDispatcher2).apron_internal::removeEventListener);
			}
			else
			{
				manager = new EventListenersManager(target, target.addEventListener, target.removeEventListener);				
			}

		}

		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			if (disposed) return;

			manager.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			if (disposed) return;

			manager.removeEventListener(type, listener, useCapture);
		}

		public function removeAllEventListeners():void
		{
			if (disposed) return;

			manager.removeAllEventListeners();
		}

		public function removeEventsForListener(listener:Function):void
		{
			if (disposed) return;

			manager.removeEventsForListener(listener);
		}

		public function removeEventsForType(type:String):void
		{
			if (disposed) return;

			manager.removeEventsForType(type);
		}

		public function dispose():void
		{
			if (disposed) return;

			manager.dispose();
			manager = null;

			disposed = true;
		}

		apron_internal function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		apron_internal function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			super.removeEventListener(type, listener, useCapture);
		}
	}
}