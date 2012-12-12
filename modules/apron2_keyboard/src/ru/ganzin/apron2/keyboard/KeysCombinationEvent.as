package ru.ganzin.apron2.keyboard
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;

	public class KeysCombinationEvent extends Event
	{
		public static const COMBINATION_PRESS:String = "combinationPress";
		public static const COMBINATION_DOWN:String = "combinationDown";
		public static const COMBINATION_RELEASE:String = "combinationRelease";
		
		private var _keyboardEvent:KeyboardEvent;
		
		public function KeysCombinationEvent(type:String, keyEvent:KeyboardEvent = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.keyboardEvent = keyboardEvent;
		}
		
		public function set keyboardEvent(value:KeyboardEvent):void
		{
			_keyboardEvent = value;
		}
		public function get keyboardEvent():KeyboardEvent
		{
			return _keyboardEvent;
		}

	}
}