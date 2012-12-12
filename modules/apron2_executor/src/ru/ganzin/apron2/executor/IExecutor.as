package ru.ganzin.apron2.executor
{
	import ru.ganzin.apron2.executor.tasks.ITask;

	public interface IExecutor
	{
		function get tasksCount():int;
		function get running():Boolean;
		
		function addTask(task:ITask):void;
		function run():void;
	}
}