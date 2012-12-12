package ru.ganzin.apron2.zip.utils.zip
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.getClassByAlias;
	import flash.utils.ByteArray;
	import flash.utils.IExternalizable;
	import flash.utils.Proxy;
	import flash.utils.describeType;
	import flash.utils.flash_proxy;
	import flash.utils.getDefinitionByName;

	import nochump.util.zip.ZipError;

	import org.as3commons.lang.ObjectUtils;

	import ru.ganzin.apron2.events.PropertyChangeEvent;
	import ru.ganzin.apron2.events.PropertyChangeEventKind;
	import ru.ganzin.apron2.interfaces.IPropertyChangeNotifier;
	import ru.ganzin.apron2.utils.ObjectProxy;
	import ru.ganzin.apron2.utils.uid.UidUtil;

	[Bindable("apronPropertyChange")]
	
	public dynamic class ZipProxy extends Proxy implements IEventDispatcher, IPropertyChangeNotifier
	{
		private var zip:ZipComposite;

		public function ZipProxy(zip:ZipComposite, notifyOldValue:Boolean = false)
		{
			this.zip = zip;
			this.notifyOldValue = notifyOldValue;
			
			dispatcher = new EventDispatcher(this);
		}

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		//----------------------------------
		//  uid
		//----------------------------------

		/**
		 *  @private
		 *  Storage for the uid property.
		 */
		private var _id:String;

		/**
		 *  The unique identifier for this object.
		 */
		public function get uid():String
		{
			if (_id === null)
            _id = UidUtil.createUID();
            
			return _id;
		}

		public function set uid(value:String):void
		{
			_id = value;
		}

		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		override flash_proxy function getProperty(name:*):*
		{
			if (flash_proxy::isAttribute(name))
			{
				return zip.getFile(name);
			}
			else
			{
				var bytes:ByteArray = zip.getFile(name);
				if (!bytes) return undefined;

				var comment:String = zip.getFileComment(name);
				if (comment)
				{
					var info:XML = new XML(comment);
					if (Boolean(info.@isSimple.toString())) return bytes.readObject();
					else if (Boolean(info.@isExternalizable.toString()))
					{
						return getExternalizableObject(info.@className, bytes);
					}
					else return bytes.readObject();
				}
				
				return bytes;
			}
		}

		override flash_proxy function hasProperty(name:*):Boolean
		{
			return zip.containFile(name);
		}

		override flash_proxy function setProperty(name:*, value:*):void
		{
			var oldVal:* = null;
			
			if (flash_proxy::isAttribute(name))
			{
				if (value is ByteArray)
				{
					if (notifyOldValue && dispatcher.hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE))
					{
						oldVal = zip.getFile(name);
					}	
				
					zip.addFile(name, ByteArray(value));
				}
				else return;
			}
			else
			{
				if (notifyOldValue && dispatcher.hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE))
				{
					oldVal = flash_proxy::getProperty(name);
				}
				
				var bytes:ByteArray;
				if (value is ByteArray)
				{
					bytes = value;
					zip.addFile(name, bytes);
				}
				else
				{
					var info:XML = <info />;
					bytes = new ByteArray();

					if (ObjectUtils.isSimple(value) && !(value is IExternalizable))
					{
						info.@isSimple = true;
						bytes.writeObject(value);
					}
					else
					{
						var className:String = ObjectUtils.getClassName(value);

						if (value is ObjectProxy)
						{
							var cinfo:XML = describeType(value);
							className = cinfo.@name.toString();
						}

						info.@className = className;

						if (value is IExternalizable)
						{
							info.@isExternalizable = true;
							IExternalizable(value).writeExternal(bytes);
						}
						else bytes.writeObject(value);
					}

					zip.addFile(name, bytes, info.toXMLString());
				}
			}
			
			if (dispatcher.hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE))
			{
				if (name is QName) name = QName(name).localName;
				var event:PropertyChangeEvent = PropertyChangeEvent.createUpdateEvent(this, name.toString(), oldVal, value);
				dispatcher.dispatchEvent(event);
			}
		}

		override flash_proxy function deleteProperty(name:*):Boolean
		{
			if (zip.containFile(name))
			{				
				if (dispatcher.hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE))
				{
					var oldVal:* = null;
					if (notifyOldValue) oldVal = zip.getFile(name);
					var deleted:Boolean = zip.removeFile(name);
			
					var event:PropertyChangeEvent = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
					event.kind = PropertyChangeEventKind.DELETE;
					event.property = name;
					event.oldValue = oldVal;
					event.source = this;
					dispatcher.dispatchEvent(event);
					
					return deleted;
				}
				else return zip.removeFile(name);
			}
			return false;
		}

		override flash_proxy function nextName(index:int):String
		{
			return zip.getFileNameById(index - 1);
		}

		override flash_proxy function nextNameIndex(index:int):int
		{
			var size:int = zip.size;
			if (size == 0) return 0;
			if (index < size) return index + 1;
			else return 0;
		}

		override flash_proxy function nextValue(index:int):*
		{
			if (zip.size == 0) return undefined;
			return zip.getFileByIndex(index - 1);
		}

		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function getExternalizableObject(className:String, bytes:ByteArray):IExternalizable
		{
			var result:Object;
			try
			{
				var classType:Class = null;
				try
				{
					classType = getClassByAlias(className);
				}
            	catch(e1:Error)
				{
					if (!classType)
                    classType = getDefinitionByName(className) as Class;
				}

				result = new classType();
			}
        	catch(e:Error)
			{
				throw new ZipError("Error instantiating class: " + className + ".");
			}

			if (result is IExternalizable)
			{
				IExternalizable(result).readExternal(bytes);
				return IExternalizable(result);
			}
			else
			{
				throw new ZipError("Class " + className + " not implementing IExternalizable.");
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  IEventDispatcher methods
		//
		//--------------------------------------------------------------------------
		
		protected var dispatcher:EventDispatcher;
		protected var notifyOldValue:Boolean = false;

		/**
		 *  Registers an event listener object  
		 *  so that the listener receives notification of an event. 
		 *  For more information, including descriptions of the parameters see 
		 *  <code>addEventListener()</code> in the 
		 *  flash.events.EventDispatcher class.
		 *
		 *  @see flash.events.EventDispatcher#addEventListener()
		 */
		public function addEventListener(type:String, listener:Function,
                                     useCapture:Boolean = false,
                                     priority:int = 0,
                                     useWeakReference:Boolean = false):void
		{
			dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		/**
		 *  Removes an event listener. 
		 *  If there is no matching listener registered with the EventDispatcher object, 
		 *  a call to this method has no effect.
		 *  For more information, see 
		 *  the flash.events.EventDispatcher class.
		 *  
		 *  @param type The type of event.
		 * 
		 *  @param listener The listener object to remove.
		 *
		 *  @param useCapture Specifies whether the listener was registered for the capture 
		 *  phase or the target and bubbling phases. If the listener was registered for both 
		 *  the capture phase and the target and bubbling phases, two calls to 
		 *  <code>removeEventListener()</code> are required to remove both, one call with 
		 *  <code>useCapture</code> 
		 *  set to <code>true</code>, and another call with <code>useCapture</code>
		 *  set to <code>false</code>.
		 *
		 *  @see flash.events.EventDispatcher#removeEventListener()
		 */
		public function removeEventListener(type:String, listener:Function,
                                        useCapture:Boolean = false):void
		{
			dispatcher.removeEventListener(type, listener, useCapture);
		}

		/**
		 *  Dispatches an event into the event flow. 
		 *  For more information, see
		 *  the flash.events.EventDispatcher class.
		 *  
		 *  @param event The Event object that is dispatched into the event flow. If the 
		 *  event is being redispatched, a clone of the event is created automatically. 
		 *  After an event is dispatched, its target property cannot be changed, so you 
		 *  must create a new copy of the event for redispatching to work.
		 *
		 *  @return Returns <code>true</code> if the event was successfully dispatched. 
		 *  A value 
		 *  of <code>false</code> indicates failure or that <code>preventDefault()</code>
		 *  was called on the event.
		 *
		 *  @see flash.events.EventDispatcher#dispatchEvent()
		 */
		public function dispatchEvent(event:Event):Boolean
		{
			return dispatcher.dispatchEvent(event);
		}

		/**
		 *  Checks whether there are any event listeners registered 
		 *  for a specific type of event. 
		 *  This allows you to determine where an object has altered handling 
		 *  of an event type in the event flow hierarchy. 
		 *  For more information, see
		 *  the flash.events.EventDispatcher class.
		 *
		 *  @param type The type of event
		 *
		 *  @return Returns <code>true</code> if a listener of the specified type is 
		 *  registered; <code>false</code> otherwise.
		 *
		 *  @see flash.events.EventDispatcher#hasEventListener()
		 */
		public function hasEventListener(type:String):Boolean
		{
			return dispatcher.hasEventListener(type);
		}

		/**
		 *  Checks whether an event listener is registered with this object 
		 *  or any of its ancestors for the specified event type. 
		 *  This method returns <code>true</code> if an event listener is triggered 
		 *  during any phase of the event flow when an event of the specified 
		 *  type is dispatched to this object or any of its descendants.
		 *  For more information, see the flash.events.EventDispatcher class.
		 *
		 *  @param type The type of event.
		 *
		 *  @return Returns <code>true</code> if a listener of the specified type will 
		 *  be triggered; <code>false</code> otherwise.
		 *
		 *  @see flash.events.EventDispatcher#willTrigger()
		 */
		public function willTrigger(type:String):Boolean
		{
			return dispatcher.willTrigger(type);
		}
	}
}
