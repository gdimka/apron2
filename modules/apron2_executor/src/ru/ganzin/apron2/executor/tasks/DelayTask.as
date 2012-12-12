package ru.ganzin.apron2.executor.tasks
{
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import ru.ganzin.apron2.executor.TaskResult;
	import ru.ganzin.apron2.executor.events.TaskEvent;

	public class DelayTask extends EventDispatcher implements ITask
	{
		private var delay:Number = 0;
		
		public function DelayTask(delay:Number)
		{
			this.delay = delay;
		}
		
		public function invoke():void
		{
			var timer:Timer = new Timer(delay,1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,onTimeOut);
			timer.start();
		}
		
		private function onTimeOut(event:TimerEvent):void
		{		
			dispatchEvent(new TaskEvent(TaskEvent.TASK_COMPLETE, TaskResult.COMPLETE));
		}
	}
}
