package ru.ganzin.apron2.mvn.puremvc.fabrication.pattern.command
{
	import mx.core.Application;
	import mx.core.UIComponent;

	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.utilities.fabrication.events.MediatorRegistrarEvent;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FlexMediator;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.resolver.ComponentResolver;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.resolver.ComponentRouteMapper;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.resolver.Expression;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.resolver.MediatorRegistrar;

	public class SimpleCommand extends SimpleFabricationCommand
	{
		/**
		 * Singleton key name for the component resolver within this facade.
		 */
		static public var routeMapperKey:String = FlexMediator.routeMapperKey;
		
		static private var registrars:Array = new Array();
		
		/**
		 * Reference to the component route mapper for this facade.
		 */
		protected var routeMapper:ComponentRouteMapper;

		public function routeNotificationTo(noteName:Object, to:Object = null, noteBody:Object = null, noteType:String = null):void
		{
			if (to is String && (to as String).indexOf("/") == -1) to = String(to) + "/*";
			routeNotification(noteName, noteBody, noteType, to);
		}

		/**
		 * Creates the base link of the component resolver chain. Additional
		 * link can be added to this to indicate the path to your viewComponent.
		 */
		public function resolve(baseComponent:Object):ComponentResolver
		{
			if (!routeMapper) initializeRouteMapper();
			
			if (baseComponent is UIComponent)
			{
				return new ComponentResolver(baseComponent as UIComponent, fabFacade, routeMapper);
			}
			else
			{
				throw new Error("Incorrect baseComponent, " + baseComponent + ", resolve needs a valid baseComponent.");
			}
		}

		//-------------------------------------------------
		//	Overrided Medhods
		//-------------------------------------------------

		/**
		 * Creates the singleton route mapper for the current facade.
		 * @private
		 */
		protected function initializeRouteMapper():void
		{
			if (!fabFacade.hasInstance(routeMapperKey))
			{
				routeMapper = fabFacade.saveInstance(routeMapperKey, new ComponentRouteMapper())as ComponentRouteMapper;
			}
			else
			{
				routeMapper = fabFacade.findInstance(routeMapperKey)as ComponentRouteMapper;
			}
		}
		
		override public function registerMediator(mediator:IMediator):IMediator
		{
			if (mediator is FlexMediator) return registerFlexMediator(mediator as FlexMediator);
			else return super.registerMediator(mediator);
		}

		public function registerFlexMediator(mediator:FlexMediator):IMediator
		{
			var registrar:MediatorRegistrar = new MediatorRegistrar(fabFacade);
			var mediatorComponent:Object = mediator.getViewComponent();
			var expression:Expression = mediatorComponent as Expression;
			var resolver:ComponentResolver;

			if (!expression)
			{
				if (mediatorComponent is Application || mediatorComponent["parent"] == null) return super.registerMediator(mediator);
				else
				{
					var uiParent:Object = mediatorComponent["parent"];
					var uiName:String = mediatorComponent["name"];
					expression = resolve(uiParent).resolve(uiName);
				}
			}
			
			registrar.addEventListener(MediatorRegistrarEvent.REGISTRATION_COMPLETED, registrationCompletedListener);
			registrar.addEventListener(MediatorRegistrarEvent.REGISTRATION_CANCELED, registrationCanceledListener);
			
			registrars.push(registrar);
			
			resolver = expression.root;
			registrar.register(mediator, resolver);	
			
			return mediator;
		}
		
//		private function registerUIComponentMediator(mediator:IMediator):IMediator
//		{
//			function creationCompleteHandler(event:FlexEvent, facade:IFacade, mediator:IMediator, delegate:Function):void
//			{
//				(event.target as IEventDispatcher).removeEventListener(event.type,delegate);
//				facade.registerMediator(mediator);
//			}
//			
//			var mediatorComponent:UIComponent = mediator.getViewComponent() as UIComponent;
//			if (mediatorComponent.initialized) facade.registerMediator(mediator);
//			else
//			{
//				var delegate:Delegate = new Delegate(creationCompleteHandler);
//				delegate.addArguments(fabFacade,mediator,delegate);
//				(mediatorComponent as IEventDispatcher).addEventListener(FlexEvent.CREATION_COMPLETE, delegate.make(), false, 0, true);
//			}
//			
//			return mediator;			
//		}

		/**
		 * Hook method to listen for a specific mediator registration. Subclasses
		 * can use this method to react to mediator registration as needed.
		 */
		private static function registrationCompletedListener(event:MediatorRegistrarEvent):void
		{
			var registrar:MediatorRegistrar = event.target as MediatorRegistrar;
			trace("AutoRegistration completed for mediator " + event.mediator.getMediatorName());
			trace("\tviewComponent = " + event.mediator.getViewComponent());
		}

		/**
		 * Hook method to listen for a specific mediator registration cancellation.
		 * Subclasses can use this method to react to mediator cancellation as needed.
		 */
		private static function registrationCanceledListener(event:MediatorRegistrarEvent):void
		{
			var registrar:MediatorRegistrar = event.target as MediatorRegistrar;
			trace("AutoRegistration removed for mediator " + event.mediator.getMediatorName());
		}
	}
}