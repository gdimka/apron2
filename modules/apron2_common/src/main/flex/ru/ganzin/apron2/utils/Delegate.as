package ru.ganzin.apron2.utils
{
	public class Delegate
	{
		private static var count:int = 0;
		
		//-------------------------------------------------
		//	Static Medhods
		//-------------------------------------------------
		
		public static function create(... rest):Function
		{
			var func:Function;
			var target:Object;
			var args:Array;
			var merge:Boolean;
			
			if (rest[0] is Function)
			{
				target = null;
				func = rest[0];
				args = rest[1];
				merge = rest[2];
			}
			else
			{
				target = rest[0];
				func = rest[1];
				args = rest[2];
				merge = rest[3];
			}
			
			var f:Object = function():*
			{
				var target:Object = arguments.callee.target;
				var func:Function = arguments.callee.func;
				var innerMerge:Boolean = arguments.callee.merge;
				
				var innerArgs:Array;
				
				if (innerMerge)
				{
					innerArgs = arguments;
					for (var i:int=0;i<arguments.callee.args.length;i++) innerArgs.push(arguments.callee.args[i]);
				}
				else if (arguments.callee.args != null) innerArgs = arguments.callee.args;
				else innerArgs = arguments;
				
				return func.apply(target, innerArgs);
			};
			
			f.id = ++count;
			f.type = "Delegate";
			f.target = target;
			f.func = func;
			f.args =  args;
			f.merge = merge;
			
			return f as Function;
		}

		public static function createCallBack(func:Function):Function
		{
			return create(func, []);
		}

		public static function getArguments(f:Function):Array
		{
			if (isDelegate(f)) return f["args"];
			return null;
		}
		
		public static function getFunction(f:Function):Function
		{
			if (isDelegate(f)) return getFunction(f["func"]);
			return f;
		}
		
		public static function equals(functionA:*,functionB:*):Boolean
		{
			if (isDelegate(functionA) && isDelegate(functionB))
			{
				var bFunctionsEquals:Boolean = equals(functionA.func,functionB.func);
				var bTargetEquals:Boolean = functionA.target == functionB.target;
				var argsA:Array = functionA.args;
				var argsB:Array = functionB.args;
				var bArgsEquals:Boolean = (argsA == argsB) || (argsA && argsB && argsA.length == 0 && argsB.length == 0);
				
				if (bFunctionsEquals && bTargetEquals && bArgsEquals) return true;
				else if (bFunctionsEquals && bTargetEquals && !bArgsEquals)
				{
					var argsCompareLength:Boolean = argsA && argsB && argsA.length == argsB.length;
					
					if (!argsCompareLength) return false;
					
					var l:uint = argsA.length;
					for(var i:int = 0; i < l; i++)
						if (argsB[i] != argsA[i]) return false;
					
					return true;
				}
				
				return false;
			}
			else if (!isDelegate(functionA)&&!isDelegate(functionB)) return (functionA == functionB);
			return false;
		}
		
		private static function compareArray(value:*, id:int, diffArray:Array):Boolean
		{
			if (value == diffArray[id]) return true; else return false;
		}
		
		public static function isDelegate(func:*):Boolean
		{
			return func is Function && func.hasOwnProperty("type");
		}
		
		//-------------------------------------------------
		//	Variables
		//-------------------------------------------------
				
		private var func:Function;
		private var target:Object;
		private var args:Array;
		private var _mergeArguments:Boolean;
		
		//-------------------------------------------------
		//	Constructor
		//-------------------------------------------------
		
		public function Delegate(func:Function, target:Object = null, mergeArguments:Boolean = true)
		{
			this.func = func;
			this.target = target;
			this.mergeArguments = mergeArguments;
		}
		
		//-------------------------------------------------
		//	Properties
		//-------------------------------------------------
		
		public function get arguments():Array
		{
			return args;
		}

		public function set mergeArguments(value:Boolean):void
		{
			_mergeArguments = value;
		}
		public function get mergeArguments():Boolean
		{
			return _mergeArguments;
		}
		
		//-------------------------------------------------
		//	Medhods
		//-------------------------------------------------
		
		public function addArguments(...rest):void
		{
			this.args = ArrayUtils.merge(this.args,rest);
		}
		
		public function make():Function
		{
			return create(target,func,args,_mergeArguments);
		}
	}
}
