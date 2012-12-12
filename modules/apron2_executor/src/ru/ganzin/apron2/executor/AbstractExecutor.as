package ru.ganzin.apron2.executor
{
	import flash.events.EventDispatcher;

	import ru.ganzin.apron2.executor.events.ExecutorEvent;
	import ru.ganzin.apron2.executor.events.ExecutorProgressEvent;
	import ru.ganzin.apron2.executor.events.TaskEvent;
	import ru.ganzin.apron2.executor.tasks.ITask;

	[Event(name="executeComplete", type="ru.ganzin.apron2.executor.events.ExecutorEvent")]
	[Event(name="executeBreak", type="ru.ganzin.apron2.executor.events.ExecutorEvent")]
	[Event(name="taskComplete", type="ru.ganzin.apron2.executor.events.ExecutorEvent")]
	[Event(name="taskError", type="ru.ganzin.apron2.executor.events.ExecutorEvent")]
	[Event(name="executorProgress", type="ru.ganzin.apron2.executor.events.ExecutorProgressEvent")]
	
	internal class AbstractExecutor extends EventDispatcher implements IExecutor
	{
		protected var tasks:Array = new Array();
		protected var completedTasksCount:uint = 0;
		protected var erroredTasksCount:uint = 0;
		
		private var _running:Boolean = false;
		
		//-------------------------------------------------
		//	Constructor
		//-------------------------------------------------
		
		function AbstractExecutor()
		{
		}
		
		//-------------------------------------------------
		//	Properties
		//-------------------------------------------------
		
		public function get running():Boolean
		{
			return _running;
		}
		
		public function get tasksCount():int
		{
			return tasks.length;
		}

		//-------------------------------------------------
		//	Medhods
		//-------------------------------------------------
		
		
		public function addTask(task:ITask):void
		{
			if (tasks == null) return;
			tasks.push(task);
		}
				
		public function run():void
		{
			_running = true;
		}
		
		public function rerun():void
		{
			run();
		}
		
		public function reset():void
		{
			_running = false;
			tasks = new Array();
			completedTasksCount = erroredTasksCount = 0;
		}
		
		protected function runTask(task:ITask):void
		{
			task.addEventListener(TaskEvent.TASK_COMPLETE, taskCompleteHandler);
			task.addEventListener(TaskEvent.TASK_ERROR, taskErrorHandler);
			task.invoke();
		}
		
		protected function taskCompleteHandler(event:TaskEvent):void
		{
			completedTasksCount++;
			progressDispatch();
		}

		protected function taskErrorHandler(event:TaskEvent):void
		{
			erroredTasksCount++;
			progressDispatch();
		}
		
		protected function removeAllListeners(task:ITask):void
		{
			task.removeEventListener(TaskEvent.TASK_COMPLETE, taskCompleteHandler);
			task.removeEventListener(TaskEvent.TASK_ERROR, taskErrorHandler);
		}
				
		protected function breakExecute(task:ITask, result:uint = uint.MIN_VALUE, error:Error = null):void
		{
			_running = false;
			dispatchEvent(new ExecutorEvent(ExecutorEvent.EXECUTE_BREAK, task, result, error));
		}
		
		protected function completeExecute():void
		{
			_running = false;
			progressDispatch();
			dispatchEvent(new ExecutorEvent(ExecutorEvent.EXECUTE_COMPLETE));
		}
		
		private function progressDispatch():void
		{
			dispatchEvent(new ExecutorProgressEvent(ExecutorProgressEvent.EXECUTOR_PROGRESS, tasks.length, completedTasksCount, erroredTasksCount));
		}
	}
}