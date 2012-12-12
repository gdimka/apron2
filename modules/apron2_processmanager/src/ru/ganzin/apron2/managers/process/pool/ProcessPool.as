package ru.ganzin.apron2.managers.process.pool
{
	import ru.ganzin.apron2.managers.process.ProcessManagerEvent;
	import ru.ganzin.apron2.pools.IPoolEntryFactory;
	import ru.ganzin.apron2.pools.IPoolable;
	import ru.ganzin.apron2.pools.Pool;

	public class ProcessPool extends Pool
	{
		private var _freeOnComleted:Boolean;

		public function ProcessPool(factory:IPoolEntryFactory = null, freeOnComleted:Boolean = true, initCount:uint = 1, growSize:uint = 1)
		{
			super((factory)?factory:new ProcessPoolEntryFactory(), initCount, growSize);
			_freeOnComleted = freeOnComleted;
		}

		private function get freeOnComleted():Boolean
		{
			return _freeOnComleted;
		}

		override public function alloc():IPoolable
		{
			var process:PoolableProcess = super.alloc() as PoolableProcess;
			process.removeEventListener(ProcessManagerEvent.PROCESS_COMPLETED, completeHandler);
			process.addEventListener(ProcessManagerEvent.PROCESS_COMPLETED, completeHandler);
			return process;
		}

		override public function free(value:IPoolable):void
		{
			super.free(value);
			(value as PoolableProcess).removeEventListener(ProcessManagerEvent.PROCESS_COMPLETED, completeHandler);
		}

		private function completeHandler(event:ProcessManagerEvent):void
		{
			free(event.process as IPoolable);
		}
	}
}