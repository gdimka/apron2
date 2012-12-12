package ru.ganzin.apron2.managers.process.pool
{
	import flash.events.Event;

	import ru.ganzin.apron2.apron_internal;
	import ru.ganzin.apron2.managers.process.Process;
	import ru.ganzin.apron2.pools.IPoolable;

	public class PoolableProcess extends Process implements IPoolable
	{
		public function PoolableProcess(func:Function = null, priority:int = -1, skipFrames:uint = 0, eventName:String = null)
		{
			super(func, priority, skipFrames, eventName);
		}

		public function renew(func:Function, priority:int = -1, skipFrames:uint = 0, eventName:String = null):void
		{
			use namespace apron_internal;

			this.func = func;
			this.priority = priority;
			this.skipFrames = skipFrames;
			this.currentSkipFrames = skipFrames;
			if (!eventName) eventName = Event.ENTER_FRAME;
			this.eventName = eventName;
		}

		public function free():void
        {
			use namespace apron_internal;

			id = -1;
			priority = -1;
			skipFrames = currentSkipFrames = 0;
			eventName = Event.ENTER_FRAME;
			func = null;
			variablesMap.clear();
		}
	}
}