package ru.ganzin.apron2.managers.process
{
	import flash.events.Event;

	public class ProcessManagerEvent extends Event
	{
		public static const PROCESS_COMPLETED:String = "processCompleted";
		public static const PROCESS_HOLDED:String = "processHolded";
		
		private var _process:Process;
		
		public function ProcessManagerEvent(type:String, process:Process, bubbles:Boolean=false, cancelable:Boolean=false)
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