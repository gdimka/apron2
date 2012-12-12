package ru.ganzin.apron2.config
{
	import flash.events.Event;

	public class ConfigEvent extends Event
	{
		public static const COMPLETE:String = "configComplete";
		public static const ERROR:String = "configError";

		public var error:Error;

		public function ConfigEvent(type:String, error:Error = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);

			this.error = error;
		}
	}
}
