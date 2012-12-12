package ru.ganzin.apron2.mvn.puremvc.fabrication.pattern.command
{
	public class SimpleControllerCommand extends SimpleCommand
	{
		override public function initializeNotifier(key:String):void
		{
			super.initializeNotifier(key);
			init();
		}
		
		//-------------------------------------------------
		//	Medhods
		//-------------------------------------------------
		
		protected function init():void
		{
			
		}
		
		protected function registerNotification(note:String):void
		{
			registerCommand(note,getClass());
		}
	}
}