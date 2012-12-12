
package ru.ganzin.apron2.executor
{
	import ru.ganzin.apron2.executor.events.ExecutorEvent;
	import ru.ganzin.apron2.executor.events.TaskEvent;
	import ru.ganzin.apron2.executor.tasks.ITask;

	public class SequenceExecutor extends AbstractExecutor
	{
		private var inverse:Boolean;
		private var currentTaskId:uint = 0;
		
		public function SequenceExecutor(inverse:Boolean = false)
		{
			this.inverse = inverse;
		}
		
		override public function run():void
		{
			super.run();
			
			if (inverse) tasks = tasks.reverse();
			if (tasks.length == 0) completeExecute();
			else runCurrentTask();
		}
		
		override public function rerun() : void
		{
			if (tasks[currentTaskId]) removeAllListeners(tasks[currentTaskId]);
			currentTaskId = 0;
			super.rerun();
		}
		
		override public function reset():void
		{
			if (tasks[currentTaskId]) removeAllListeners(tasks[currentTaskId]);
			currentTaskId = 0;
			super.reset();
		}
		
		private function runCurrentTask():void
		{
			runTask(tasks[currentTaskId]);
		}
		
		override protected function taskCompleteHandler(event:TaskEvent):void
		{
			super.taskCompleteHandler(event);
			
			var task:ITask = event.target as ITask;
			dispatchEvent(new ExecutorEvent(ExecutorEvent.TASK_COMPLETE, task, event.result));
			
			switch(event.result)
			{
				case TaskResult.REPEAT:	break;
				case TaskResult.SKIP_NEXT:
					++currentTaskId;
					
				case TaskResult.COMPLETE:
					removeAllListeners(task);
					if (++currentTaskId >= tasks.length)
					{
						completeExecute();
						return;
					}
				break;	
				
				case TaskResult.BREAK:
					removeAllListeners(task);
					breakExecute(task);
					return;
				break;
			}
			
			runCurrentTask();
		}
		
		override protected function taskErrorHandler(event:TaskEvent):void
		{
			super.taskErrorHandler(event);
			
			removeAllListeners(event.target as ITask);
			
			var canError:Boolean = true;
			if (hasEventListener(ExecutorEvent.TASK_ERROR))
				canError = dispatchEvent(new ExecutorEvent(ExecutorEvent.TASK_ERROR, event.task, event.result, event.error));
				
			if (canError && hasEventListener(ExecutorEvent.EXECUTE_BREAK)) breakExecute(event.task, event.result, event.error);
			else
			{
				if (++currentTaskId >= tasks.length) completeExecute();
				else runCurrentTask();
			}
		}
	}
}
