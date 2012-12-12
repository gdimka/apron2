package ru.ganzin.apron2.executor.tasks
{
	import flash.events.IEventDispatcher;

	public interface ITask extends IEventDispatcher
	{
		function invoke():void;
	}	
}
