
package ru.ganzin.apron2.executor.tasks
{
	import flash.events.EventDispatcher;

	import ru.ganzin.apron2.executor.TaskResult;
	import ru.ganzin.apron2.executor.events.TaskEvent;

	public class SimpleTask extends EventDispatcher implements ITask
	{
		private var func:Function;
		
		public function SimpleTask(func:Function)
		{
			this.func = func;
		}
		
		public function invoke():void
		{
			var result:uint = uint(func());
			if (result == 0) result = TaskResult.COMPLETE;
			dispatchEvent(new TaskEvent(TaskEvent.TASK_COMPLETE, result));
		}
	}
}
