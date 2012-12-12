package ru.ganzin.apron2.utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	import flash.utils.getQualifiedClassName;

	import org.as3commons.lang.ObjectUtils;
	import org.as3commons.reflect.Field;
	import org.as3commons.reflect.Type;

	import ru.ganzin.apron2.apron_internal;
	import ru.ganzin.apron2.events.PropertyChangeEvent;
	import ru.ganzin.apron2.events.PropertyChangeEventKind;
	import ru.ganzin.apron2.interfaces.IPropertyChangeNotifier;
	import ru.ganzin.apron2.utils.uid.UidUtil;

	use namespace flash_proxy;

	[Bindable("apronPropertyChange")]

	public dynamic class ObjectProxy extends Proxy implements IExternalizable, IEventDispatcher
	{
		public function ObjectProxy(item:Object = null, uid:String = null, proxyDepth:int = -1)
		{
			super();

			if (!item)
				item = {};
			_item = item;

			_proxyLevel = proxyDepth;

			notifiers = {};

			dispatcher = new EventDispatcher();

			// If we got an id, use it.  Otherwise the UID is lazily
			// created in the getter for UID.
			if (uid)
				_id = uid;
		}

		protected var dispatcher:EventDispatcher;

		protected var notifiers:Object;

		protected var proxyClass:Class = ObjectProxy;

		protected var propertyList:Array;

		private var _proxyLevel:int;

		private var _item:Object;

		apron_internal function get object():Object
		{
			return _item;
		}

		private var _type:QName;

		apron_internal function get type():QName
		{
			return _type;
		}

		apron_internal function set type(value:QName):void
		{
			_type = value;
		}

		private var _id:String;

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
			// if we have a data proxy for this then
			var result:*;

			if (notifiers[name.toString()])
				return notifiers[name];

			result = _item[name];

			if (result)
			{
				if (_proxyLevel == 0 || ObjectUtils.isSimple(result))
				{
					return result;
				}
				else
				{
					result = apron_internal::getComplexProperty(name, result);
				} // if we are proxying
			}

			return result;
		}

		/**
		 *  Returns the value of the proxied object's method with the specified name.
		 *
		 *  @param name The name of the method being invoked.
		 *
		 *  @param rest An array specifying the arguments to the
		 *  called method.
		 *
		 *  @return The return value of the called method.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		override flash_proxy function callProperty(name:*, ...rest):*
		{
			return _item[name].apply(_item, rest)
		}

		/**
		 *  Deletes the specified property on the proxied object and
		 *  sends notification of the delete to the handler.
		 *
		 *  @param name Typically a string containing the name of the property,
		 *  or possibly a QName where the property name is found by
		 *  inspecting the <code>localName</code> property.
		 *
		 *  @return A Boolean indicating if the property was deleted.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		override flash_proxy function deleteProperty(name:*):Boolean
		{
			if (notifiers[name] is IPropertyChangeNotifier)
			{
				var notifier:IPropertyChangeNotifier = IPropertyChangeNotifier(notifiers[name]);
				notifier.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,
						propertyChangeHandler);
				delete notifiers[name];
			}

			var oldVal:* = _item[name];
			var deleted:Boolean = delete _item[name];

			if (dispatcher.hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE))
			{
				var event:PropertyChangeEvent = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
				event.kind = PropertyChangeEventKind.DELETE;
				event.property = name;
				event.oldValue = oldVal;
				event.source = this;
				dispatcher.dispatchEvent(event);
			}

			return deleted;
		}

		/**
		 *  @private
		 */
		override flash_proxy function hasProperty(name:*):Boolean
		{
			return(name in _item);
		}

		/**
		 *  @private
		 */
		override flash_proxy function nextName(index:int):String
		{
			return propertyList[index - 1];
		}

		/**
		 *  @private
		 */
		override flash_proxy function nextNameIndex(index:int):int
		{
			if (index == 0)
			{
				setupPropertyList();
			}

			if (index < propertyList.length)
			{
				return index + 1;
			}
			else
			{
				return 0;
			}
		}

		/**
		 *  @private
		 */
		override flash_proxy function nextValue(index:int):*
		{
			return _item[propertyList[index - 1]];
		}

		/**
		 *  Updates the specified property on the proxied object
		 *  and sends notification of the update to the handler.
		 *
		 *  @param name Object containing the name of the property that
		 *  should be updated on the proxied object.
		 *
		 *  @param value Value that should be set on the proxied object.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		override flash_proxy function setProperty(name:*, value:*):void
		{
			var oldVal:* = _item[name];
			if (oldVal !== value)
			{
				// Update item.
				_item[name] = value;

				// Stop listening for events on old item if we currently are.
				if (notifiers[name] is IPropertyChangeNotifier)
				{
					var notifier:IPropertyChangeNotifier =
							IPropertyChangeNotifier(notifiers[name]);

					notifier.removeEventListener(
							PropertyChangeEvent.PROPERTY_CHANGE,
							propertyChangeHandler);
					delete notifiers[name];
				}

				// Notify anyone interested.
				if (dispatcher.hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE))
				{
					if (name is QName)
						name = QName(name).localName;
					var event:PropertyChangeEvent =
							PropertyChangeEvent.createUpdateEvent(
									this, name.toString(), oldVal, value);
					dispatcher.dispatchEvent(event);
				}
			}
		}

		//--------------------------------------------------------------------------
		//
		//  object_proxy methods
		//
		//--------------------------------------------------------------------------

		/**
		 *  Provides a place for subclasses to override how a complex property that
		 *  needs to be either proxied or daisy chained for event bubbling is managed.
		 *
		 *  @param name Typically a string containing the name of the property,
		 *  or possibly a QName where the property name is found by
		 *  inspecting the <code>localName</code> property.
		 *
		 *  @param value The property value.
		 *
		 *  @return The property value or an instance of <code>ObjectProxy</code>.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		apron_internal function getComplexProperty(name:*, value:*):*
		{
			if (value is IPropertyChangeNotifier)
			{
				value.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,
						propertyChangeHandler);
				notifiers[name] = value;
				return value;
			}

			if (getQualifiedClassName(value) == "Object")
			{
				value = new proxyClass(_item[name], null,
						_proxyLevel > 0 ? _proxyLevel - 1 : _proxyLevel);
				value.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,
						propertyChangeHandler);
				notifiers[name] = value;
				return value;
			}

			return value;
		}

		//--------------------------------------------------------------------------
		//
		//  IExternalizable Methods
		//
		//--------------------------------------------------------------------------

		/**
		 *  Since Flex only uses ObjectProxy to wrap anonymous objects,
		 *  the server flex.messaging.io.ObjectProxy instance serializes itself
		 *  as a Map that will be returned as a plain ActionScript object.
		 *  You can then set the object_proxy object property to this value.
		 *
		 *  @param input The source object from which the ObjectProxy is
		 *  deserialized.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function readExternal(input:IDataInput):void
		{
			var value:Object = input.readObject();
			_item = value;
		}

		/**
		 *  Since Flex only serializes the inner ActionScript object that it wraps,
		 *  the server flex.messaging.io.ObjectProxy populates itself
		 *  with this anonymous object's contents and appears to the user
		 *  as a Map.
		 *
		 *  @param output The source object from which the ObjectProxy is
		 *  deserialized.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function writeExternal(output:IDataOutput):void
		{
			output.writeObject(_item);
		}

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		/**
		 *  Registers an event listener object
		 *  so that the listener receives notification of an event.
		 *  For more information, including descriptions of the parameters see
		 *  <code>addEventListener()</code> in the
		 *  flash.events.EventDispatcher class.
		 *
		 *  @param type The type of event.
		 *
		 *  @param listener The listener function that processes the event. This function must accept
		 *  an Event object as its only parameter and must return nothing.
		 *
		 *  @param useCapture Determines whether the listener works in the capture phase or the
		 *  target and bubbling phases. If <code>useCapture</code> is set to <code>true</code>,
		 *  the listener processes the event only during the capture phase and not in the
		 *  target or bubbling phase. If <code>useCapture</code> is <code>false</code>, the
		 *  listener processes the event only during the target or bubbling phase. To listen for
		 *  the event in all three phases, call <code>addEventListener</code> twice, once with
		 *  <code>useCapture</code> set to <code>true</code>, then again with
		 *  <code>useCapture</code> set to <code>false</code>.
		 *
		 *  @param priority The priority level of the event listener.
		 *
		 *  @param useWeakReference Determines whether the reference to the listener is strong or
		 *  weak. A strong reference (the default) prevents your listener from being garbage-collected.
		 *  A weak reference does not.
		 *
		 *  @see flash.events.EventDispatcher#addEventListener()
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			dispatcher.addEventListener(type, listener, useCapture,
					priority, useWeakReference);
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
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
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
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
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
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
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
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function willTrigger(type:String):Boolean
		{
			return dispatcher.willTrigger(type);
		}

		/**
		 *  Called when a complex property is updated.
		 *
		 *  @param event An event object that has changed.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function propertyChangeHandler(event:PropertyChangeEvent):void
		{
			dispatcher.dispatchEvent(event);
		}

		//--------------------------------------------------------------------------
		//
		//  Protected Methods
		//
		//--------------------------------------------------------------------------

		/**
		 *  This method creates an array of all of the property names for the
		 *  proxied object.
		 *  Descendants must override this method if they wish to add more
		 *  properties to this list.
		 *  Be sure to call <code>super.setupPropertyList</code> before making any
		 *  changes to the <code>propertyList</code> property.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		protected function setupPropertyList():void
		{
			if (getQualifiedClassName(_item) == "Object")
			{
				propertyList = [];
				for (var prop:String in _item)
					propertyList.push(prop);
			}
			else
			{
				propertyList = [];
				var pList:Array = Type.forInstance(_item).properties;
				for each (var f:Field in pList)
					propertyList.push(f.name);
			}
		}
	}

}
