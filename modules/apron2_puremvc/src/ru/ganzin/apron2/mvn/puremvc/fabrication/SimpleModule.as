package ru.ganzin.apron2.mvn.puremvc.fabrication
{
	import flash.events.Event;

	import ru.ganzin.apron2.mvn.puremvc.fabrication.fabricator.SimpleModuleFabricator;

	public class SimpleModule extends AbstractFabrication implements IModule
	{
		private var _parentApplication:IHasModules;
		
		/**
		 * Creates the FlexModule and initializes its fabricator.
		 */
		public function SimpleModule(name:String)
		{
			_parentApplication = parentApplication;
			super(name);
		}

		public function set parentApplication(value:IHasModules):void
		{
			_parentApplication = value;
		}
		public function get parentApplication():IHasModules
		{
			return _parentApplication;
		}

		public function init():void
		{
			dispatchEvent(new Event(Event.INIT));
		}

		/**
		 * Instantiates the FlexModule environment specific fabricator.
		 */
		override public function initializeFabricator():void
		{
			_fabricator = new SimpleModuleFabricator(this);
		}

	}
}


