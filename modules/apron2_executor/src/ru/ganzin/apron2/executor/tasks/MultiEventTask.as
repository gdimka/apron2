package ru.ganzin.apron2.executor.tasks
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	import ru.ganzin.apron2.executor.TaskResult;
	import ru.ganzin.apron2.executor.events.TaskEvent;

	public class MultiEventTask extends EventDispatcher implements ITask
	{
		private var func:Function;
		private var events:Array = new Array();
		private var current:int = 0;
		
		public function MultiEventTask(func:Function)
		{
			this.func = func;
		}
		
		public function addEvent(target:IEventDispatcher, event:String = Event.COMPLETE):void
		{
			events.push([target,event]);
		}
		
		public function invoke():void
		{
			var target:IEventDispatcher;
			var event:String;
			for each(var e:Array in events)
			{
				target = e[0];
				event = e[1];
				target.addEventListener(event,onCaptureEvent);
			}
			
			if (func != null) func();
		}
		
		private function onCaptureEvent(event:Event):void
		{
			event.target.removeEventListener(event.type,onCaptureEvent);
			
			if (++current == events.length)
			{
				if (event is TaskEvent) dispatchEvent(new TaskEvent(TaskEvent.TASK_COMPLETE, (event as TaskEvent).result));
				else dispatchEvent(new TaskEvent(TaskEvent.TASK_COMPLETE, TaskResult.COMPLETE));
			}
		}
	}	
}
