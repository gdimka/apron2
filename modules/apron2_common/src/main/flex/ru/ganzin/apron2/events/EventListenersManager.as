package ru.ganzin.apron2.events
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	import ru.ganzin.apron2.collections.HashMap;

	public class EventListenersManager implements IRemovableEventDispatcher
	{
		private var map:HashMap;

		private var target:IEventDispatcher;
		
		private var superAddEventListener:Function;
		private var superRemoveEventListener:Function;

		public function EventListenersManager(target:IEventDispatcher, superAddEventListener:Function = null, superRemoveEventListener:Function = null)
		{
			this.target = target;

			if (superAddEventListener == null) superAddEventListener = target.addEventListener;
			if (superRemoveEventListener == null) superRemoveEventListener = target.removeEventListener;

			this.superAddEventListener = superAddEventListener;
			this.superRemoveEventListener = superRemoveEventListener;
		}

		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			if (!target) return;

			superAddEventListener(type, listener, useCapture, priority, useWeakReference);

			if (!map) map = new HashMap(false);
			var list:Array;
			if (!map.containsValue(type)) map.put(type, list = []);
			else list = map.getValue(type);

			for (var i:uint=list.length; --i>=0;)
				if ((list[i] as EventInfo).equals(listener,useCapture)) return;

			list.push(new EventInfo(listener,useCapture));
		}

		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			if (!target) return;

			superRemoveEventListener(type, listener, useCapture);

			if (!map) map = new HashMap(false);
			
			var list:Array = map.getValue(type);
			if (!list) return;

			var eventInfo:EventInfo;
			for (var i:uint=list.length; --i>=0;)
			{
				eventInfo = list[i];
				if (eventInfo.equals(listener, useCapture)) list.splice(i,1);
			}
		}

		public function removeAllEventListeners():void
		{
			if (!target) return;

			if (!map) map = new HashMap(false);
			for each (var type:String in map.getKeys()) removeEventsForType(type);
		}

		public function removeEventsForType(type:String):void
		{
			if (!target) return;

			if (!map) map = new HashMap(false);
			var list:Array = map.getValue(type);
			if (!list) return;

			var eventInfo:EventInfo;
			for (var i:uint=list.length; --i>=0;)
			{
				eventInfo = list[i];
				superRemoveEventListener(type, eventInfo.listener, eventInfo.useCapture);
			}

			map.remove(type);
		}

		/**
		 * Removes all events that report to the specified listener.
		 *
		 * @param listener The listener function that processes the event.
		 */
		public function removeEventsForListener(listener:Function):void
		{
			if (!target) return;

			if (!map) map = new HashMap(false);
			for each (var type:String in map.getKeys())
			{
				var list:Array = map.getValue(type);
				if (!list) continue;

				var eventInfo:EventInfo;
				for (var i:uint=list.length; --i>=0;)
				{
					eventInfo = list[i];
					if (eventInfo.listener == listener)
					{
						superRemoveEventListener(type, eventInfo.listener, eventInfo.useCapture);
						list.splice(i,1);
					}
				}
			}
		}

		/**
		 * Disposes the EventListenersManager.
		 */
		public function dispose():void
		{
			if (!target) return;

			removeAllEventListeners();

			map.clear();

			target = null;
			map = null;
			superAddEventListener = null;
			superRemoveEventListener = null;
		}

		/**
		 * @exclude
		 */
		public function dispatchEvent(event:Event):Boolean
		{
			if (!target) return false;
			return target.dispatchEvent(event);
		}

		/**
		 * @exclude
		 */
		public function hasEventListener(type:String):Boolean
		{
			if (!target) return false;
			return target.hasEventListener(type);
		}

		/**
		 * @exclude
		 */
		public function willTrigger(type:String):Boolean
		{
			if (!target) return false;
			return target.willTrigger(type);
		}
	}
}

class EventInfo
{
//	protected var _listenerWeakRef:WeakRef;
	protected var _listener:Function;
	protected var _useCapture:Boolean;

	public function EventInfo(listener:Function, useCapture:Boolean)
	{
//		this._listenerWeakRef = new WeakRef(listener);
		this._listener = listener;
		this._useCapture = useCapture;
	}

	public function get listener():Function
	{
//		return _listenerWeakRef;
		return _listener;
	}

	public function get useCapture():Boolean
	{
		return _useCapture;
	}

	public function equals(listener:Function, useCapture:Boolean):Boolean
	{
		return this.listener !== null && this.listener == listener && this.useCapture == useCapture;
	}
}
