package ru.ganzin.apron2.mvn.puremvc.fabrication.pattern.view
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.resources.IResourceBundle;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FlexMediator;

	import ru.ganzin.apron2.collections.IMap;
	import ru.ganzin.apron2.resources.LocalResourceBundle;
	import ru.ganzin.apron2.resources.Locale;
	import ru.ganzin.apron2.resources.ResourceMap;

	public class SimpleFlexMediator extends FlexMediator
	{
		public function SimpleFlexMediator(name:String = null, viewComponent:UIComponent = null)
		{
			super(name, viewComponent);
		}
		
		//-------------------------------------------------
		//	Properties
		//-------------------------------------------------
		
		public function get uiComponent():UIComponent
		{
			return viewComponent as UIComponent;
		}
		
	    //----------------------------------
	    //  resourceManager
	    //----------------------------------
	    
	    /**
	     *  @private
	     *  Storage for the resourceManager property.
	     */
	    private var _resourceManager:IResourceManager = ResourceManager.getInstance();
	    
	    /**
	     *  @private
	     *  This metadata suppresses a trace() in PropertyWatcher:
	     *  "warning: unable to bind to property 'resourceManager' ..."
	     */
	    [Bindable("unused")]
	    
	    /**
	     *  A reference to the object which manages
	     *  all of the application's localized resources.
	     *  This is a singleton instance which implements
	     *  the IResourceManager interface.
	     */
	    protected function get resourceManager():IResourceManager
	    {
	        return _resourceManager;
	    }
	    
	    private var _resourceMap:IMap;
	    
	    public function get resourceMap():IMap
	    {
	    	if (!_resourceMap || !ResourceMap(_resourceMap).resourceBundle)
	    	{
		    	var r:IResourceBundle = resourceManager.getResourceBundle(Locale.ALL, getMediatorName());
		    	if (!r) r = new LocalResourceBundle(Locale.ALL, getMediatorName(), true);
		    	_resourceMap = new ResourceMap(r);
	    	}
	    	
	    	return _resourceMap;
	    }


		//-------------------------------------------------
		//	Overrided Medhods
		//-------------------------------------------------

		private var list:Array = [];
		private var notesMap:Dictionary = new Dictionary();
		
		override public function listNotificationInterests():Array
		{
			return list;
		}

		override public function dispose():void
		{
			$removeAllEventListeners();
			super.dispose();
		}
		
		override public function onRegister():void
		{
			if (uiComponent.initialized) viewComponentCreationCompleted();
			else
			{
				(uiComponent as IEventDispatcher).addEventListener(FlexEvent.CREATION_COMPLETE, viewComponent_CreationCompleteHandler, false, 0, true);
			}
		}
		
		override public function handleNotification(note:INotification):void
		{
			var noteName:String = note.getName();
			var noteType:String = note.getType();
			
			if (notesMap[noteName]) notesMap[noteName](note);
			if (notesMap[noteName+"_"+noteType]) notesMap[noteName+"_"+noteType](note);
		}
		
		//-------------------------------------------------
		//	Medhods
		//-------------------------------------------------
		
		protected function viewComponentCreationCompleted():void
		{
			
		}
		
		protected function registerNotification(note:String, ... rest):void
		{
			if (list.indexOf(note) == -1) list.push(note);
			
			if (rest.length > 0)
			{
				if (rest.length == 1) notesMap[note] = rest[0];
				if (rest.length == 2) notesMap[note+"_"+rest[0]] = rest[1];
			}
		}

		public function routeNotificationTo(noteName:Object, to:Object = null, noteBody:Object = null, noteType:String = null):void
		{
			if (to is String && (to as String).indexOf("/") == -1)	to = String(to) + "/*";
			routeNotification(noteName, noteBody, noteType, to);
		}

		// Events

		private var events:Array = new Array();

		public function registerEvent(name:String, handler:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			registerEventTo(viewComponent as IEventDispatcher, name, handler, useCapture, priority, useWeakReference);
		}

		public function registerEventTo(target:IEventDispatcher, name:String, handler:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			target.addEventListener(name, handler, useCapture, priority, useWeakReference);
			events.push([target, name, handler, useCapture]);
		}

		private function $removeAllEventListeners():void
		{
			for each (var e:Array in events)
				(e[0]as IEventDispatcher).removeEventListener(e[1], e[2], e[3]);
		}
		
		// viewComponent Events
		
		private function viewComponent_CreationCompleteHandler(event:Event):void
		{
			(event.target as IEventDispatcher).removeEventListener(event.type, viewComponent_CreationCompleteHandler);
			viewComponentCreationCompleted();
		}
	}
}