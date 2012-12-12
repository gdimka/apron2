package ru.ganzin.apron2.mvn.puremvc.fabrication.pattern.view
{
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FabricationMediator;

	import ru.ganzin.apron2.utils.Delegate;

	public class SimpleMediator extends FabricationMediator
	{
		public function SimpleMediator(name:String = null, viewComponent:Object = null)
		{
			super(name, viewComponent);
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
			super.dispose();
			
			unregisterAllEventListeners();
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
			routeNotification(noteName,noteBody,noteType,to);
		}
		
		public function retrieveManager( managerName:String ):IMediator
		{
			return facade.retrieveMediator(managerName);	
		}

		// Events
		
		private var events:Array = new Array();
		
		public function registerEvent(name:String, handler:Function, args:Array = null, useCapture:Boolean = false, priority:int=0, useWeakReference:Boolean=false):void
		{
			if (args) handler = Delegate.create(handler, args, true);
			registerEventTo(viewComponent as IEventDispatcher,name,handler,args,useCapture, priority,useWeakReference);
		}

		public function registerEventTo(target:IEventDispatcher, name:String, handler:Function, args:Array = null, useCapture:Boolean = false, priority:int=0, useWeakReference:Boolean=false):void
		{
			if (args) handler = Delegate.create(handler, args, true);
			target.addEventListener(name, handler, useCapture, priority, useWeakReference);
			events.push([target,name,handler,useCapture]);
		}
		
		public function unregisterEvent(name:String, handler:Function, args:Array = null, useCapture:Boolean = false):void
		{
			if (args) handler = Delegate.create(handler, args, true);
			unregisterEventFrom(viewComponent as IEventDispatcher, name, handler, args, useCapture);
		}
		
		public function unregisterEventFrom(target:IEventDispatcher, name:String, handler:Function, args:Array = null, useCapture:Boolean = false):void
		{
			var b:Boolean = false;
			for each (var e:Array in events)
			{
				b = (e[0] == target) && (e[1] == name) && (e[3] == useCapture);
				if (b && Delegate.equals(e[2],handler))
					(e[0] as IEventDispatcher).removeEventListener(e[1],e[2],e[3]);
			}
		}
		
		public function unregisterAllEventListeners():void
		{
			for each (var e:Array in events)
				(e[0] as IEventDispatcher).removeEventListener(e[1],e[2],e[3]);
		}
	}
}