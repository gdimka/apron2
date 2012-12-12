package ru.ganzin.apron2.keyboard
{
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	import ru.ganzin.apron2.SimpleClass;
	import ru.ganzin.apron2.collections.HashMap;
	import ru.ganzin.apron2.collections.IMap;
	import ru.ganzin.apron2.utils.Delegate;
	import ru.ganzin.apron2.utils.StringUtil;

	public class KeysCombination extends SimpleClass
	{
		public static const RELEASE_STATE:int = 0;
		public static const PRESS_STATE:int = 1;
		public static const DOWN_STATE:int = 2;

		private static const exchangeKeysMap:Object =
		{
			CTRL:Keyboard.CONTROL,
			ALT:10001,
			ESC:Keyboard.ESCAPE,
			PAGEUP:Keyboard.PAGE_UP,
			PAGEDOWN:Keyboard.PAGE_DOWN,
			TILDE:192
		};

		addKeys();

		static function addKeys()
		{
			exchangeKeysMap["~"] = exchangeKeysMap["`"] = 192;
			exchangeKeysMap["+"] = exchangeKeysMap["="] = 187;
			exchangeKeysMap["-"] = exchangeKeysMap["_"] = 189;
			exchangeKeysMap["\\"] = exchangeKeysMap["|"] = 220;
		}

		protected var state:int;

		protected var keysMap:Dictionary;

		private var useDownState:Boolean;
		private var downTimer:Timer;

		//-------------------------------------------------
		//	Constructor
		//-------------------------------------------------

		public function KeysCombination(combination:*, useDownState:Boolean = false, downRepeatDelay:int = 100)
		{
			if (combination is String) keysCombination = combination;
			else if (combination is Array)
			{
				for each (var code:* in combination)
					keysMap[getKeyCode(code.toString())] = true;
			}
			else if (combination is Dictionary)
			{
				for (var code:* in combination)
					keysMap[getKeyCode(code.toString())] = true;
			}

			this.useDownState = useDownState;

			if (useDownState)
			{
				downTimer = new Timer(downRepeatDelay);
				downTimer.addEventListener(TimerEvent.TIMER, Delegate.createCallBack(downProcessing), false, 0, true);
			}
		}

		public function isEqual(combination:KeysCombination):Boolean
		{
			return isEqualByCodesKeys(combination.keysMap);
		}

		public function isEqualByCodesKey(value:int):Boolean
		{
			var hasKeys:Boolean = false;
			for (var code:* in keysMap)
			{
				hasKeys = true;
				if (value != code) return false;
			}
			return hasKeys;
		}

		public function isEqualByCodesKeys(codes:*):Boolean
		{
			var hasKeys:Boolean = false;
			for (var code:* in keysMap)
			{
				hasKeys = true;
				if (!codes[code]) return false;
			}
			return hasKeys;
		}

		//-------------------------------------------------
		//	Properties
		//-------------------------------------------------
		private var _keysCombination:String;

		public function set keysCombination(value:String):void
		{
			_keysCombination = value;
			updateKeysCombination();
		}

		public function get keysCombination():String
		{
			return _keysCombination;
		}

		public function get codesKeys():IMap
		{
			var map:IMap = new HashMap();
			map.putAll(keysMap);
			return map;
		}

		// currentState

		private var _currentState:int;

		public function get currentState():int
		{
			return _currentState;
		}

		//-------------------------------------------------
		//	Medhods
		//-------------------------------------------------

		function changeState(state:int, event:KeyboardEvent = null):void
		{
			//			trace(keysCombination, "changeState", state)

			this.state = state;

			var type:String = (state == RELEASE_STATE) ? KeysCombinationEvent.COMBINATION_RELEASE : KeysCombinationEvent.COMBINATION_PRESS;
			dispatchEvent(new KeysCombinationEvent(type, event));

			if (useDownState)
			{
				if (this.state == PRESS_STATE)
				{
					downTimer.start();
					this.state = DOWN_STATE;
					downProcessing();
				}
				else if (this.state == RELEASE_STATE)
				{
					downTimer.stop();
					downTimer = new Timer(downTimer.delay);
					downTimer.addEventListener(TimerEvent.TIMER, Delegate.createCallBack(downProcessing), false, 0, true);
				}
			}
		}

		private function updateKeysCombination():void
		{
			var comb:String = keysCombination.toUpperCase();
			var letters:Array;
			if (comb == "+") letters = ["+"];
			else letters = StringUtil.toArray(comb, "+", true);

			var codesMap:Dictionary = new Dictionary();
			for each (var key:String in letters)
			{
				var code:Number = getKeyCode(key);
				if (!code)
				{
					logger.error("You enter wrong key '{0}' in keys combination '{1}'", [key, keysCombination]);
					return;
				}

				codesMap[code] = true;
			}

			keysMap = codesMap;
		}

		private function getKeyCode(key:String):Number
		{
			if (StringUtil.isNumber(key)) return StringUtil.toNumber(key);

			if (exchangeKeysMap[key]) return exchangeKeysMap[key];
			else if (Keyboard[key]) return Keyboard[key];
			else if (key.length == 1) return key.charCodeAt(0);

			return 0;
		}

		private function downProcessing():void
		{
			dispatchEvent(new KeysCombinationEvent(KeysCombinationEvent.COMBINATION_DOWN));
		}

	}
}