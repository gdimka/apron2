package ru.ganzin.apron2.zip.utils.zip
{
	import flash.events.Event;

	public class ZipEvent extends Event
	{
		public static const UPDATED:String = "updated";

		public function ZipEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
