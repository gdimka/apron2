package ru.ganzin.apron2.executor.events
{
	import flash.events.Event;

	import ru.ganzin.apron2.executor.tasks.ITask;

	public class ExecutorEvent extends Event
	{
		public static const TASK_COMPLETE:String = "taskComplete";
		public static const TASK_ERROR:String = "tashError";
		public static const EXECUTE_BREAK:String = "executeBreak";
		public static const EXECUTE_COMPLETE:String = "executeComplete";
		
		private var _task:ITask;
		private var _result:int;
		private var _error:Error;
		
		public function ExecutorEvent(type:String, task:ITask = null, result:int = 0, error:Error = null)
		{
			super(type, true, true);
			_task = task;
			_result = result;
			_error = error;
		}
		
		public function get task():ITask
		{
			return _task;
		}
		
		public function get result():int
		{
			return _result;
		}
		
		public function get error():Error
		{
			return _error;
		}
	}	
}
