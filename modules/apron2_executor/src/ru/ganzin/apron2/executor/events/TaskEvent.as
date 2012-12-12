package ru.ganzin.apron2.executor.events
{
	import flash.events.Event;

	import ru.ganzin.apron2.executor.TaskResult;
	import ru.ganzin.apron2.executor.tasks.ITask;

	public class TaskEvent extends Event
	{
		public static const TASK_COMPLETE:String = "taskComplete";
		public static const TASK_ERROR:String = "taskError";
		
		private var _result:uint;
		private var _error:Error;
		
		public function TaskEvent(type:String, result:uint = TaskResult.COMPLETE, error:Error = null)
		{
			super(type);
			_result = result;
			_error = error;
		}
		
		public function get task():ITask { return target as ITask; }
		public function get result():uint { return _result; }
		public function get error():Error { return _error; }
	}
}