package ru.ganzin.apron2.executor.tasks
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	import ru.ganzin.apron2.executor.TaskResult;
	import ru.ganzin.apron2.executor.events.TaskEvent;

	public class EventTask extends EventDispatcher implements ITask
	{
		private var target:IEventDispatcher;
		private var func:Function;
		private var event:String;
		private var handlers:Array;
		
		public function EventTask(func:Function, target:IEventDispatcher, event:String = Event.COMPLETE, ...handlers)
		{
			this.target = target;
			this.func = func;
			this.event = event;
			this.handlers = handlers;
		}
		
		public function invoke():void
		{
			target.addEventListener(event,onCaptureEvent);
			
			if (handlers)
			{
				for each (var handler:Function in handlers)
					target.addEventListener(event,handler);
			}
			
			if (func != null) func();
		}
		
		private function onCaptureEvent(event:Event):void
		{
			target.removeEventListener(event.type,onCaptureEvent);
			
			if (event is TaskEvent) dispatchEvent(new TaskEvent(TaskEvent.TASK_COMPLETE, (event as TaskEvent).result));
			else dispatchEvent(new TaskEvent(TaskEvent.TASK_COMPLETE, TaskResult.COMPLETE));
		}
	}	
}
