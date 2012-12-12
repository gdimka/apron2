package ru.ganzin.apron2.keyboard
{
	import flash.events.KeyboardEvent;

	public class KeyboardManagerEvent extends KeysCombinationEvent
	{
		public static const COMBINATION_DOWN:String = "combinationDown";
		public static const COMBINATION_PRESS:String = "combinationPress";
		public static const COMBINATION_RELEASE:String = "combinationRelease";
		
		private var _combination:KeysCombination;
		
		public function KeyboardManagerEvent(type:String, combination:KeysCombination, keyEvent:KeyboardEvent, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, keyEvent, bubbles, cancelable);
			
			this.combination = combination;
		}
		
		public function set combination(value:KeysCombination):void
		{
			_combination = value;
		}
		public function get combination():KeysCombination
		{
			return _combination;
		}

	}
}