package ru.ganzin.apron2.mvn.puremvc.fabrication.fabricator
{
	import org.puremvc.as3.multicore.utilities.fabrication.components.fabricator.FlexApplicationFabricator;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.FabricationNotification;

	import ru.ganzin.apron2.mvn.puremvc.fabrication.SimpleFlexApplication;

	public class SimpleFlexApplicationFabricator extends FlexApplicationFabricator
	{
		public function SimpleFlexApplicationFabricator(_fabrication:SimpleFlexApplication)
		{
			super(_fabrication);
		}
		
		private function get application():SimpleFlexApplication
		{
			return fabrication as SimpleFlexApplication;
		}
		
		override protected function startApplication():void
		{
//			var appRunCommand:Class = application.getApplicationRunCommmand();
			facade.registerCommand(FabricationNotification.BOOTSTRAP, application.getModulesStartupCommand());
//			if (appRunCommand) facade.registerCommand(FabricationNotification.BOOTSTRAP, appRunCommand);
			super.startApplication();
		}
	}
}