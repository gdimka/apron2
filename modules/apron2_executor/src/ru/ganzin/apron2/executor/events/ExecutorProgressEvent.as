package ru.ganzin.apron2.executor.events
{
	import flash.events.Event;

	public class ExecutorProgressEvent extends Event
	{
		public static const EXECUTOR_PROGRESS:String = "executorProgress";
		
		private var _totalTasks:uint;
		private var _completedTasks:uint;
		private var _faultedTasks:uint;
		
		public function ExecutorProgressEvent(type:String, totalTasks:uint, completedTasks:uint, faultedTasks:uint, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			_totalTasks = totalTasks;
			_completedTasks = completedTasks;
			_faultedTasks = faultedTasks;
		}
		
		public function get totalTasks():uint
		{
			return _totalTasks;
		}
		
		public function get completedTasks():uint
		{
			return _completedTasks;
		}

		public function get faultedTasks():uint
		{
			return _faultedTasks;
		}

	}
}