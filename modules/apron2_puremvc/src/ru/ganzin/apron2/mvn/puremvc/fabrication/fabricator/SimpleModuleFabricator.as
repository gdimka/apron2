package ru.ganzin.apron2.mvn.puremvc.fabrication.fabricator
{
	import flash.events.Event;

	import org.puremvc.as3.multicore.utilities.fabrication.components.fabricator.ApplicationFabricator;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFabrication;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.startup.ModuleStartupCommand;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.FabricationNotification;

	import ru.ganzin.apron2.mvn.puremvc.fabrication.SimpleModule;

	/**
	 * SimpleModuleFabrication is the concrete fabricator for Flash applications.
	 */
	public class SimpleModuleFabricator extends ApplicationFabricator
	{
		/**
		 * @see org.puremvc.as3.multicore.utilities.fabrication.components.fabricator.ApplicationFabrication
		 */
		public function SimpleModuleFabricator(fabrication:SimpleModule)
		{
			super(fabrication);
		}
		
		public function get parent():IFabrication
		{
			return module.parentApplication as IFabrication;
		}
		
		/**
		 * Returns the fabrication as a FlexModule
		 */
		public function get module():SimpleModule
		{
			return fabrication as SimpleModule;
		}

		/**
		 * Provides the ready event name for SimpleModule, i.e.:- initialize
		 */
		override protected function get readyEventName():String
		{
			return Event.INIT;
		}

		/**
		 * Registers the ApplicationStartupCommand to configure fabrication for
		 * a flex application environment. If a router is not present this is
		 * a shell application else it is a module application.
		 */
		override protected function initializeEnvironment():void
		{
			if (router == null && parent != null)
			{
				module.router = parent.router;
			}

			if (defaultRoute == null && parent != null)
			{
				module.defaultRoute = parent.defaultRoute;
			}

			if (moduleGroup == null && parent != null)
			{
				module.moduleGroup = parent.moduleGroup;
			}

			if (router == null)
			{
				throw new Error("Router was not set on the module.");
			}

			facade.registerCommand(FabricationNotification.STARTUP, ModuleStartupCommand);
		}

	}
}

