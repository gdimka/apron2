package ru.ganzin.apron2.mvn.puremvc.fabrication
{
	import flash.utils.getDefinitionByName;

	import org.puremvc.as3.multicore.utilities.fabrication.components.fabricator.ApplicationFabricator;
	import org.puremvc.as3.multicore.utilities.fabrication.events.FabricatorEvent;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFabrication;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IModuleAddress;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouter;

	import ru.ganzin.apron2.SimpleClass;

	/**
	 * Dispatched when the flash application's fabrication is created.
	 *
	 * @eventType org.puremvc.as3.multicore.utilities.fabrication.events.FabricatorEvent.FABRICATION_CREATED
	 */
	[Event(name="fabricationCreated", type = "org.puremvc.as3.multicore.utilities.fabrication.events.FabricatorEvent")]

	/**
	 * Dispatched when the flash application's fabrication is removed.
	 *
	 * @eventType org.puremvc.as3.multicore.utilities.fabrication.events.FabricatorEvent.FABRICATION_REMOVED
	 */
	[Event(name="fabricationRemoved", type = "org.puremvc.as3.multicore.utilities.fabrication.events.FabricatorEvent")]

	internal class AbstractFabrication extends SimpleClass implements IFabrication
	{
		/**
		 * The flash environment specific fabricator
		 */
		protected var _fabricator:ApplicationFabricator;

		/**
		 * Default route address assigned to this FlashApplication
		 */
		protected var _defaultRouteAddress:IModuleAddress;

		/**
		 * Optional configuration object
		 */
		protected var _config:Object;

		private var _name:String;

		public function AbstractFabrication(name:String = null)
		{
			_name = name;
			initializeFabricator();
		}

		/**
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable#dispose()
		 */
		override public function dispose():void
		{
			super.dispose();
			
			_fabricator.dispose();
			_fabricator = null;
		}

		/**
		 * The flash environment specific fabricator
		 */
		public function get fabricator():ApplicationFabricator
		{
			return _fabricator;
		}

		/**
		 * The message address for the current application
		 */
		public function get moduleAddress():IModuleAddress
		{
			return _fabricator.moduleAddress;
		}

		/**
		 * The default route for the current application
		 */
		public function get defaultRoute():String
		{
			return _fabricator.defaultRoute;
		}

		/**
		 * @private
		 */
		public function set defaultRoute(defaultRoute:String):void
		{
			_fabricator.defaultRoute = defaultRoute;
		}

		/**
		 * The default route address to be assigned to the child module.
		 */
		public function get defaultRouteAddress():IModuleAddress
		{
			return _defaultRouteAddress;
		}
		public function set defaultRouteAddress(defaultRouteAddress:IModuleAddress):void
		{
			this._defaultRouteAddress = defaultRouteAddress;
			defaultRoute = defaultRouteAddress.getInputName();
		}

		/**
		 * The message router for the current application
		 */
		public function set router(router:IRouter):void
		{
			_fabricator.router = router;
		}
		public function get router():IRouter
		{
			return _fabricator.router;
		}

		/**
		 * The name of the current application module group for messaging.
		 *
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterAwareModule#moduleGroup
		 */
		public function get moduleGroup():String
		{
			return _fabricator.moduleGroup;
		}
		public function set moduleGroup(moduleGroup:String):void
		{
			_fabricator.moduleGroup = moduleGroup;
		}

		/**
		 * The configuration object of the current FlashApplication.
		 */
		public function get config():Object
		{
			return _config;
		}
		public function set config($config:Object):void
		{
			_config = $config;
		}

		/**
		 * Instantiates the flash environment specific fabricator.
		 */
		public function initializeFabricator():void
		{
		}

		/**
		 * Abstract method. Subclasses should provide their application
		 * specific startup command class.
		 */
		public function getStartupCommand():Class
		{
			return null;
		}

		/**
		 * Concrete implementation of getClassByName.
		 *
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFabrication#getClassByName
		 */
		public function getClassByName(classpath:String):Class
		{
			return getDefinitionByName(classpath)as Class;
		}

		/**
		 * For Flash applications the name is the id
		 */
		public function get id():String
		{
			return _name;
		}
		
		/**
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFabrication#notifyFabricationCreated
		 */
		public function notifyFabricationCreated():void
		{
			dispatchEvent(new FabricatorEvent(FabricatorEvent.FABRICATION_CREATED));
		}

		/**
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFabrication#notifyFabricationRemoved
		 */
		public function notifyFabricationRemoved():void
		{
			dispatchEvent(new FabricatorEvent(FabricatorEvent.FABRICATION_REMOVED));
		}
	}
}

