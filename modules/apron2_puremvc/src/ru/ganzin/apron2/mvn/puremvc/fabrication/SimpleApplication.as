package ru.ganzin.apron2.mvn.puremvc.fabrication
{
	import flash.events.Event;

	import ru.ganzin.apron2.mvn.puremvc.fabrication.fabricator.SimpleApplicationFabricator;
	import ru.ganzin.apron2.mvn.puremvc.fabrication.pattern.command.startup.ModulesStartupCommand;

	public class SimpleApplication extends AbstractFabrication implements IHasModules
	{
		private var modules:Array = new Array();
		
		//-------------------------------------------------
		//	Constructor
		//-------------------------------------------------
		
		public function SimpleApplication(name:String)
		{
			super(name);
		}
		
		//-------------------------------------------------
		//	Medhods
		//-------------------------------------------------
		
		public function run():void
		{
			dispatchEvent(new Event(Event.INIT));
		}
		
		public function addModule(module:IModule):void
		{
			modules.push(module);
		}
		
		public function initModules():void
		{
			for each (var module:IModule in modules)
			{
				module.parentApplication = this;
				module.init();
			}
		}
		
		public function getApplicationRunCommmand():Class
		{
			return null;
		}
		
		public function getModulesStartupCommand():Class
		{
			return ModulesStartupCommand;
		}
		
		//-------------------------------------------------
		//	Overrided Medhods
		//-------------------------------------------------
		
		override public function initializeFabricator():void
		{
			_fabricator = new SimpleApplicationFabricator(this);
		}
	}
}