package ru.ganzin.apron2.keyboard
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;

	import ru.ganzin.apron2.SimpleClass;
	import ru.ganzin.apron2.collections.IMap;

	public class KeyboardManager extends SimpleClass
	{
		public static const ALT_KEY:int = 10001;

		private var combinations:Array = new Array();
		private var combinationsPressedMap:Dictionary = new Dictionary(true);

		private var keysState:Dictionary = new Dictionary();
		private var prevKeysState:Dictionary = new Dictionary();
		private var keysPressed:Dictionary = new Dictionary();
		private var keysReleased:Dictionary = new Dictionary();

		private var target:IEventDispatcher;

		private var _stage:Stage;

		public function KeyboardManager(target:IEventDispatcher)
		{
			this.target = target;

			target.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, false, 0, true);
			target.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler, false, 0, true);

			function addEventsToStage(stage:Stage):void
			{
				_stage = stage;
				stage.addEventListener(Event.MOUSE_LEAVE, stageMouseLeaveHandler, false, 0, true);
			}

			if (target is Stage) addEventsToStage(Stage(target));
			else if (target is DisplayObject)
			{
				var d:DisplayObject = (target as DisplayObject);
				if (d.stage) addEventsToStage(d.stage);
				else
				{
					d.addEventListener(Event.ADDED_TO_STAGE, function (e:Event):void
					{
						addEventsToStage(d.stage);
					}, false, 0, true);
				}
			}
		}

		override public function dispose():void
		{
			super.dispose();

			target.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			target.removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler);

			if (_stage) _stage.removeEventListener(Event.MOUSE_LEAVE, stageMouseLeaveHandler);

			combinations = null;
			combinationsPressedMap = null;
			_stage = null;
			target = null;
		}

		//-------------------------------------------------
		//	Medhods
		//-------------------------------------------------

		public function keyJustPressed(keyCode:int):Boolean
		{
			return keysPressed[keyCode];
		}

		public function keyJustReleased(keyCode:int):Boolean
		{
			return keysReleased[keyCode];
		}

		public function isKeyDown(keyCode:int):Boolean
		{
			return keysState[keyCode];
		}

		public function isAnyKeyDown():Boolean
		{
			for each(var b:Boolean in keysState)
				if (b) return true;
			return false;
		}

		public function combinationIsPressed(value:*):Boolean
		{
			var comb:KeysCombination;
			if (value is KeysCombination) comb = value;
			else comb = new KeysCombination(value);

			return comb.isEqualByCodesKeys(keysPressed);
		}

		public function combitationIsReleased(value:*):Boolean
		{
			var comb:KeysCombination;
			if (value is KeysCombination) comb = value;
			else comb = new KeysCombination(value);

			return comb.isEqualByCodesKeys(keysReleased);
		}

		public function combitationIsDown(value:*):Boolean
		{
			var comb:KeysCombination;
			if (value is KeysCombination) comb = value;
			else comb = new KeysCombination(value);

			return comb.isEqualByCodesKeys(keysState);
		}

		public function addKeysCombination(value:KeysCombination):void
		{
			combinations.push(value);
		}

		private function $combinationIsPressed(value:*):Boolean
		{
			var comb:KeysCombination;

			if (combinationsPressedMap[comb])
			{
				return true;
			}
			else if (value is KeysCombination)
			{
				comb = findEqualCombination((value as KeysCombination).codesKeys.getDictonary());
			}
			else if (value is Dictionary)
			{
				comb = findEqualCombination(value as Dictionary);
			}
			else if (value is IMap)
			{
				comb = findEqualCombination((value as IMap).getDictonary());
			}
			else if (value is String)
			{
				comb = findEqualCombination(new KeysCombination(value as String).codesKeys.getDictonary());
			}

			if (comb)
			{
				return combinationsPressedMap[comb] != null;
			}

			return false;
		}

		public function simulateKeyDown(keyCode:int):void
		{
			target.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 0, keyCode));
		}

		public function simulateKeyUp(keyCode:int):void
		{
			target.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, true, false, 0, keyCode));
		}

		private function processingKeys(event:KeyboardEvent = null):void
		{
			if (event)
			{
				if (event.altKey)
				{
					keysState[ALT_KEY] = true;
				}
				else
				{
					keysState[ALT_KEY] = false;
				}

				if (event.type == KeyboardEvent.KEY_DOWN)
				{
					keysState[event.keyCode] = true;
				}
				else
				{
					keysState[event.keyCode] = false;
				}
			}

			for (var code:* in keysState)
			{
				if (keysState[code] && !prevKeysState[code])
				{
					keysPressed[code] = true;
				}
				else
				{
					delete keysPressed[code];
				}

				if (!keysState[code] && prevKeysState[code])
				{
					keysReleased[code] = true;
				}
				else
				{
					delete keysReleased[code];
				}
			}

			prevKeysState = keysState;

			var comb:KeysCombination;

			var reservedSimpleCombinations:Array = [];

			if (!keysState[Keyboard.SHIFT] && !keysState[Keyboard.CONTROL] && !keysState[ALT_KEY])
				for (var code:* in keysState)
					if (keysState[code])
						for (var j:int = 0; j < combinations.length; j++)
						{
							comb = combinations[j] as KeysCombination;
							if (comb.isEqualByCodesKey(code))
							{
								reservedSimpleCombinations.push(comb);
								if (!$combinationIsPressed(comb))
								{
									pressCombination(comb, event);
								}
							}
						}

			for (var i:int = 0; i < combinations.length; i++)
			{
				comb = combinations[i] as KeysCombination;

				if (comb.isEqualByCodesKeys(keysState))
				{
					if (!$combinationIsPressed(comb))
					{
						pressCombination(comb, event);
					}
				}
				else if ($combinationIsPressed(comb) && reservedSimpleCombinations.indexOf(comb) == -1)
				{
					releaseCombination(comb, event);
				}
			}
		}

		private function findEqualCombination(keys:*):KeysCombination
		{
			var comb:KeysCombination;
			for (var i:int = 0; i < combinations.length; i++)
			{
				comb = combinations[i] as KeysCombination;
				if (comb.isEqualByCodesKeys(keys))
				{
					return comb;
				}
			}

			return null;
		}

		private function pressCombination(comb:KeysCombination, event:KeyboardEvent = null):void
		{
			combinationsPressedMap[comb] = true;
			comb.changeState(KeysCombination.PRESS_STATE, event);
			dispatchEvent(new KeyboardManagerEvent(KeyboardManagerEvent.COMBINATION_PRESS, comb, event));
		}

		private function releaseCombination(comb:KeysCombination, event:KeyboardEvent = null):void
		{
			delete combinationsPressedMap[comb];
			comb.changeState(KeysCombination.RELEASE_STATE, event);
			dispatchEvent(new KeyboardManagerEvent(KeyboardManagerEvent.COMBINATION_RELEASE, comb, event));
		}

		//-------------------------------------------------
		//	Events
		//-------------------------------------------------

		private function keyDownHandler(event:KeyboardEvent):void
		{
			processingKeys(event);
		}

		private function keyUpHandler(event:KeyboardEvent):void
		{
			processingKeys(event);
		}

		private function stageMouseLeaveHandler(e:Event):void
		{
			keysReleased = keysPressed;
			keysPressed = new Dictionary();
			keysState = new Dictionary();
			prevKeysState = new Dictionary();

			processingKeys();
		}
	}
}