package ru.ganzin.apron2.mvn.puremvc.fabrication.pattern.command.startup
{
	import org.puremvc.as3.multicore.interfaces.INotification;

	import ru.ganzin.apron2.mvn.puremvc.fabrication.IHasModules;
	import ru.ganzin.apron2.mvn.puremvc.fabrication.pattern.command.SimpleCommand;

	public class ModulesStartupCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var app:IHasModules = fabrication as IHasModules;
			if (app) app.initModules();
		}
	}
}