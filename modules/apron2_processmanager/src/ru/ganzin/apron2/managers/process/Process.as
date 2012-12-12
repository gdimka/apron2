package ru.ganzin.apron2.managers.process
{
	import flash.events.Event;
	import flash.utils.Dictionary;

	import ru.ganzin.apron2.SimpleClass;
	import ru.ganzin.apron2.apron_internal;
	import ru.ganzin.apron2.collections.HashMapProxy;
	import ru.ganzin.apron2.utils.Delegate;

	public class Process extends SimpleClass
	{
		private static var processByFunctionMap:Dictionary = new Dictionary();

		public static var USE_TRY_CATCH:Boolean = true;

		public static function getProcessByFunction(func:Function):Process
		{
			return processByFunctionMap[Delegate.getFunction(func)];
		}
		
		use namespace apron_internal;
		
		apron_internal var id:int = -1;
		apron_internal var func:Function;
		apron_internal var priority:int;
		apron_internal var skipFrames:uint;
		apron_internal var eventName:String;
		
		private var f:Function;
		protected var currentSkipFrames:int;
		protected var variablesMap:HashMapProxy = new HashMapProxy();
		
		public function Process(func:Function, priority:int = -1, skipFrames:uint = 0, eventName:String = null)
		{
			this.func = func;
			this.priority = priority;
			this.skipFrames = skipFrames;
			this.currentSkipFrames = skipFrames;
			if (!eventName) eventName = Event.ENTER_FRAME;
			this.eventName = eventName;
		}
		
		public function getFunction():Function
		{
			return func;
		}
		
		public function getVariablesMap():HashMapProxy
		{
			return variablesMap;
		}
		
		public function run():uint
		{
			if (currentSkipFrames <= 0)
			{
				if (!f) f = Delegate.getFunction(func);
				
				processByFunctionMap[f] = this;

				if (USE_TRY_CATCH)
				{
					try
					{
						var ret:uint = uint(func.apply(null,[]));
					}
					catch(e:Error)
					{
						throw e;
					}
					finally
					{
						delete processByFunctionMap[f];
					}
				}
				else
				{
					var ret:uint = uint(func.apply(null,[]));
					delete processByFunctionMap[f];
				}

				return ret;
			}
			else currentSkipFrames--;
			return 0;
		}
		
		public function equals(process:Process):Boolean
		{
			if (!process) return false;
			if (process == this) return true;
			if (process.id == id && Delegate.equals(process.func,func)
				&& process.skipFrames == skipFrames && process.eventName == eventName) return true;
			return false;
		}
	}
}
