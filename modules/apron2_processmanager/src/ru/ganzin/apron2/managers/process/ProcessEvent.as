package ru.ganzin.apron2.managers.process
{
	import flash.events.Event;

	public class ProcessEvent extends Event
	{
		public static const REMOVED:String = "processRemoved";
		public static const ADDED:String = "processAdded";
		
		private var _process:Process;
		
		public function ProcessEvent(type:String, process:Process, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			_process = process;
		}
		
		public function get process():Process
		{
			return _process;
		}

	}
}