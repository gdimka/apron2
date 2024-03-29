package ru.ganzin.apron2.events
{
	import flash.events.Event;

	public class PropertyChangeEvent extends Event
	{
		public static const PROPERTY_CHANGE:String = "apronPropertyChange";

		public static function createUpdateEvent(source:Object, property:Object, oldValue:Object, newValue:Object):PropertyChangeEvent
		{
			var event:PropertyChangeEvent =
					new PropertyChangeEvent(PROPERTY_CHANGE);

			event.kind = PropertyChangeEventKind.UPDATE;
			event.oldValue = oldValue;
			event.newValue = newValue;
			event.source = source;
			event.property = property;

			return event;
		}

		public function PropertyChangeEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, kind:String = null, property:Object = null, oldValue:Object = null, newValue:Object = null, source:Object = null)
		{
			super(type, bubbles, cancelable);

			this.kind = kind;
			this.property = property;
			this.oldValue = oldValue;
			this.newValue = newValue;
			this.source = source;
		}

		public var kind:String;
		public var newValue:Object;
		public var oldValue:Object;
		public var property:Object;
		public var source:Object;

		override public function clone():Event
		{
			return new PropertyChangeEvent(type, bubbles, cancelable, kind,
					property, oldValue, newValue, source);
		}
	}
}
