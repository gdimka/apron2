
package ru.ganzin.apron2.executor
{
	import ru.ganzin.apron2.executor.events.ExecutorEvent;
	import ru.ganzin.apron2.executor.events.TaskEvent;
	import ru.ganzin.apron2.executor.tasks.ITask;

	public class ParallelExecutor extends AbstractExecutor
	{
		private var workingTasks:uint = 0;
		private var maxTaskAtOneTime:int = -1;
		private var executedTasks:int = 0;
		
		public function ParallelExecutor(maxTaskAtOneTime:int = -1)
		{
			this.maxTaskAtOneTime = maxTaskAtOneTime;
		}
				
		override public function run():void
		{
			super.run();
			
			executedTasks = 0;
			if (maxTaskAtOneTime == -1) maxTaskAtOneTime = tasks.length;
			
			if (tasks.length == 0) completeExecute();
			else runTasks();
		}

		override public function reset():void
		{
			executedTasks = 0;
			workingTasks = 0;
			super.reset();
		}
		
		private var runningNow:Boolean = false;
		
		private function runTasks():void
		{
			if (runningNow) return;
			
			runningNow = true;
			
			var startIndex:int = executedTasks;
			var endIndex:int = executedTasks + maxTaskAtOneTime;
			if (endIndex > tasks.length) endIndex = tasks.length;
			
			for (var i:int = startIndex; i < endIndex; i++)
			{
				workingTasks++;
				executedTasks++;
				
				runTask(tasks[i]);
			}
			
			runningNow = false;
			
			if (workingTasks == 0)
			{
				if (executedTasks == tasks.length) completeExecute();
				else runTasks();
			}
		}
		
		override protected function taskCompleteHandler(event:TaskEvent):void
		{
			super.taskCompleteHandler(event);

			var task:ITask = event.target as ITask;
			
			if (hasEventListener(ExecutorEvent.TASK_COMPLETE))
				dispatchEvent(new ExecutorEvent(ExecutorEvent.TASK_COMPLETE, task, event.result));

			switch(event.result)
			{
				case TaskResult.REPEAT:
					task.invoke();
				break;
				
				case TaskResult.COMPLETE:
							
					removeAllListeners(task);

					if (--workingTasks == 0 && !runningNow)
					{
						if (executedTasks == tasks.length) completeExecute();
						else runTasks();

						return;
					}
					
				break;
			}
		}
		
		override protected function taskErrorHandler(event:TaskEvent):void
		{
			super.taskErrorHandler(event);
			
			var canError:Boolean = true;
			if (hasEventListener(ExecutorEvent.TASK_ERROR))
				canError = dispatchEvent(new ExecutorEvent(ExecutorEvent.TASK_ERROR, event.task, event.result, event.error))
				
			if (canError && hasEventListener(ExecutorEvent.EXECUTE_BREAK)) breakExecute(event.task, event.result, event.error);
			else if (--workingTasks == 0) completeExecute();
		}
	}
}
