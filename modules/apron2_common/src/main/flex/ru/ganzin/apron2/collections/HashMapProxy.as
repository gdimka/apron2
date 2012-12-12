package ru.ganzin.apron2.collections
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	import org.as3commons.collections.framework.IList;

	import ru.ganzin.apron2.errors.IllegalArgumentException;
	import ru.ganzin.apron2.events.PropertyChangeEvent;
	import ru.ganzin.apron2.events.PropertyChangeEventKind;
	import ru.ganzin.apron2.interfaces.IPropertyChangeNotifier;
	import ru.ganzin.apron2.utils.ObjectUtil;
	import ru.ganzin.apron2.utils.uid.UidUtil;

	[Bindable("apronPropertyChange")]

	dynamic public class HashMapProxy extends Proxy implements IMap, IPropertyChangeNotifier
	{
		public static const PROPERTY_CHANGE:String = "apronPropertyChange";

		private var _map:IMap;

		private var keys:Array;

		protected var eventDispatcher:EventDispatcher;
		protected var dispatchPropertyChangeEvent:Boolean = true;

		public function HashMapProxy(map:IMap = null)
		{
			if (map) this.map = map;
			else this.map = new HashMap();

			eventDispatcher = new EventDispatcher(this);
		}

		public function get map():IMap
		{
			return _map;
		}

		public function set map(value:IMap):void
		{
			_map = value;
			keys = _map.getKeys();
		}

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
			if (_id === null) _id = UidUtil.createUID();
			return _id;
		}

		/**
		 *  @private
		 */
		public function set uid(value:String):void
		{
			_id = value;
		}

		/**
		 *
		 * Adds a key and value to the HashMap instance
		 *
		 * @example
		 * <listing version="3.0">
		 *
		 * import com.ericfeminella.collections.HashMap;
		 * import com.ericfeminella.collections.IMap;
		 *
		 * var map:IMap = new HashMap();
		 * map.put( "user", userVO );
		 *
		 * </listing>
		 *
		 * @param the key to add to the map
		 * @param the value of the specified key
		 *
		 */
		public function put(key:*, value:*):void
		{
			checkKeyType(key);

			var event:PropertyChangeEvent;
			if (dispatchPropertyChangeEvent && hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE))
			{
				event = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
				event.kind = PropertyChangeEventKind.UPDATE;
				event.property = key;
				event.oldValue = map.getValue(key);
				event.newValue = value;
				event.source = this;
			}

			if (!map.containsKey(key)) keys.push(key);
			map.put(key, value);

			if (event) dispatchEvent(event);
		}

		/**
		 *
		 * Places all name / value pairs into the current
		 * <code>IMap</code> instance.
		 *
		 * @example
		 * <listing version="3.0">
		 *
		 * import com.ericfeminella.collections.HashMap;
		 * import com.ericfeminella.collections.IMap;
		 *
		 * var table:Object = {a: "foo", b: "bar"};
		 * var map:IMap = new HashMap();
		 * map.putAll( table );
		 *
		 * trace( map.getValues() );
		 * // foo, bar
		 *
		 * </listing>
		 *
		 * @param an <code>Object</code> of name / value pairs
		 *
		 */
		public function putAll(table:*):void
		{
			dispatchPropertyChangeEvent = false;

			for (var prop:String in table)
			{
				put(prop, table[prop]);
			}

			dispatchPropertyChangeEvent = true;

			dispatchUpdatePropertiesEvent();
		}

		protected function dispatchUpdatePropertiesEvent():void
		{
			if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE))
			{
				var event:PropertyChangeEvent = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
				event.kind = PropertyChangeEventKind.UPDATE;
				event.source = this;
				dispatchEvent(event);
			}
		}

		/**
		 *
		 * <code>putEntry</code> is intended as a pseudo-overloaded
		 * <code>put</code> implementation whereby clients may call
		 * <code>putEntry</code> to pass an <code>IHashMapEntry</code>
		 * implementation.
		 *
		 * @param concrete <code>IHashMapEntry</code> implementation
		 *
		 */
		public function putEntry(entry:IHashMapEntry):void
		{
			put(entry.key, entry.value);
		}

		/**
		 *
		 * Removes a key and value from the HashMap instance
		 *
		 * @example
		 * <listing version="3.0">
		 *
		 * import com.ericfeminella.collections.HashMap;
		 * import com.ericfeminella.collections.IMap;
		 *
		 * var map:IMap = new HashMap();
		 * map.put( "admin", adminVO );
		 * map.remove( "admin" );
		 *
		 * </listing>
		 *
		 * @param the key to remove from the map
		 *
		 */
		public function remove(key:*):void
		{
			checkKeyType(key);

			var index:int = keys.indexOf(key);
			if (index != -1)
			{
				var event:PropertyChangeEvent;
				if (dispatchPropertyChangeEvent && hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE))
				{
					event = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
					event.kind = PropertyChangeEventKind.DELETE;
					event.property = key;
					event.oldValue = map.getValue(key);
					event.source = this;
				}

				map.remove(key);
				keys.splice(index, 1);

				if (event) dispatchEvent(event);
			}
		}

		/**
		 *
		 * Determines if a key exists in the HashMap instance
		 *
		 * @example
		 * <listing version="3.0">
		 *
		 * import com.ericfeminella.collections.HashMap;
		 * import com.ericfeminella.collections.IMap;
		 *
		 * var map:IMap = new HashMap();
		 * map.put( "admin", adminVO );
		 *
		 * trace( map.containsKey( "admin" ) ); //true
		 *
		 * </listing>
		 *
		 * @param  the key in which to determine existance in the map
		 * @return true if the key exisits, false if not
		 *
		 */
		public function containsKey(key:*):Boolean
		{
			checkKeyType(key);
			return map.containsKey(key);
		}

		/**
		 *
		 * Determines if a value exists in the HashMap instance
		 *
		 * @example
		 * <listing version="3.0">
		 *
		 * import com.ericfeminella.collections.HashMap;
		 * import com.ericfeminella.collections.IMap;
		 *
		 * var map:IMap = new HashMap();
		 * map.put( "admin", adminVO );
		 *
		 * trace( map.containsValue( adminVO ) ); //true
		 *
		 * </listing>
		 *
		 * @param  the value in which to determine existance in the map
		 * @return true if the value exisits, false if not
		 *
		 */
		public function containsValue(value:*):Boolean
		{
			return map.containsValue(value);
		}

		/**
		 *
		 * Returns a key value from the HashMap instance
		 *
		 * @example
		 * <listing version="3.0">
		 *
		 * import com.ericfeminella.collections.HashMap;
		 * import com.ericfeminella.collections.IMap;
		 *
		 * var map:IMap = new HashMap();
		 * map.put( "admin", adminVO );
		 *
		 * trace( map.getKey( adminVO ) ); //admin
		 *
		 * </listing>
		 *
		 * @param  the key in which to retrieve the value of
		 * @return the value of the specified key
		 *
		 */
		public function getKey(value:*):*
		{
			return map.getKey(value);
		}

		/**
		 *
		 * Returns each key added to the HashMap instance
		 *
		 * @example
		 * <listing version="3.0">
		 *
		 * import com.ericfeminella.collections.HashMap;
		 * import com.ericfeminella.collections.IMap;
		 *
		 * var map:IMap = new HashMap();
		 * map.put( "admin", adminVO );
		 * map.put( "editor", editorVO );
		 *
		 * trace( map.getKeys() ); //admin, editor
		 *
		 * </listing>
		 *
		 * @return Array of key identifiers
		 *
		 */
		public function getKeys():Array
		{
			return keys;
		}

		/**
		 *
		 * Retrieves the value of the specified key from the HashMap instance
		 *
		 * @example
		 * <listing version="3.0">
		 *
		 * import com.ericfeminella.collections.HashMap;
		 * import com.ericfeminella.collections.IMap;
		 *
		 * var map:IMap = new HashMap();
		 * map.put( "admin", adminVO );
		 * map.put( "editor", editorVO );
		 *
		 * trace( map.getValue( "editor" ) ); //[object, editorVO]
		 *
		 * </listing>
		 *
		 * @param  the key in which to retrieve the value of
		 * @return the value of the specified key, otherwise returns undefined
		 *
		 */
		public function getValue(key:*):*
		{
			checkKeyType(key);
			return map.getValue(key);
		}

		/**
		 *
		 * Retrieves each value assigned to each key in the HashMap instance
		 *
		 * @example
		 * <listing version="3.0">
		 *
		 * import com.ericfeminella.collections.HashMap;
		 * import com.ericfeminella.collections.IMap;
		 *
		 * var map:IMap = new HashMap();
		 * map.put( "admin", adminVO );
		 * map.put( "editor", editorVO );
		 *
		 * trace( map.getValues() ); //[object, adminVO],[object, editorVO]
		 *
		 * </listing>
		 *
		 * @return Array of values assigned for all keys in the map
		 *
		 */
		public function getValues():Array
		{
			return map.getValues();
		}

		/**
		 *
		 * Determines the size of the HashMap instance
		 *
		 * @example
		 * <listing version="3.0">
		 *
		 * import com.ericfeminella.collections.HashMap;
		 * import com.ericfeminella.collections.IMap;
		 *
		 * var map:IMap = new HashMap();
		 * map.put( "admin", adminVO );
		 * map.put( "editor", editorVO );
		 *
		 * trace( map.size() ); //2
		 *
		 * </listing>
		 *
		 * @return the current size of the map instance
		 *
		 */
		public function size():int
		{
			return keys.length;
		}

		/**
		 *
		 * Determines if the current HashMap instance is empty
		 *
		 * @example
		 * <listing version="3.0">
		 *
		 * import com.ericfeminella.collections.HashMap;
		 * import com.ericfeminella.collections.IMap;
		 *
		 * var map:IMap = new HashMap();
		 * trace( map.isEmpty() ); //true
		 *
		 * map.put( "admin", adminVO );
		 * trace( map.isEmpty() ); //false
		 *
		 * </listing>
		 *
		 * @return true if the current map is empty, false if not
		 *
		 */
		public function isEmpty():Boolean
		{
			return size() <= 0;
		}

		/**
		 *
		 * Resets all key value assignments in the HashMap instance to null
		 *
		 * @example
		 * <listing version="3.0">
		 *
		 * import com.ericfeminella.collections.HashMap;
		 * import com.ericfeminella.collections.IMap;
		 *
		 * var map:IMap = new HashMap();
		 * map.put( "admin", adminVO );
		 * map.put( "editor", editorVO );
		 * map.reset();
		 *
		 * trace( map.getValues() ); //null, null
		 *
		 * </listing>
		 *
		 */
		public function reset():void
		{
			map.reset();

			if (dispatchPropertyChangeEvent)
			{
				dispatchUpdatePropertiesEvent();
			}
		}

		/**
		 *
		 * Resets all key / values defined in the HashMap instance to null
		 * with the exception of the specified key
		 *
		 * @example
		 * <listing version="3.0">
		 *
		 * import com.ericfeminella.collections.HashMap;
		 * import com.ericfeminella.collections.IMap;
		 *
		 * var map:IMap = new HashMap();
		 * map.put( "admin", adminVO );
		 * map.put( "editor", editorVO );
		 *
		 * trace( map.getValues() ); //[object, adminVO],[object, editorVO]
		 *
		 * map.resetAllExcept( "editor", editorVO );
		 * trace( map.getValues() ); //null,[object, editorVO]
		 *
		 * </listing>
		 *
		 * @param the key which is not to be cleared from the map
		 *
		 */
		public function resetAllExcept(key:*):void
		{
			checkKeyType(key);
			map.resetAllExcept(key);

			if (dispatchPropertyChangeEvent)
			{
				dispatchUpdatePropertiesEvent();
			}
		}

		/**
		 *
		 * Resets all key / values in the HashMap instance to null
		 *
		 * @example
		 * <listing version="3.0">
		 *
		 * import com.ericfeminella.collections.HashMap;
		 * import com.ericfeminella.collections.IMap;
		 *
		 * var map:IMap = new HashMap();
		 * map.put( "admin", adminVO );
		 * map.put( "editor", editorVO );
		 * trace( map.size() ); //2
		 *
		 * map.clear();
		 * trace( map.size() ); //0
		 *
		 * </listing>
		 *
		 */
		public function clear():void
		{
			dispatchPropertyChangeEvent = false;

			for (var key:* in map.getDictonary())
			{
				remove(key);
			}

			dispatchPropertyChangeEvent = false;

			dispatchUpdatePropertiesEvent();
		}

		/**
		 *
		 * Clears all key / values defined in the HashMap instance
		 * with the exception of the specified key
		 *
		 * @example
		 * <listing version="3.0">
		 *
		 * import com.ericfeminella.collections.HashMap;
		 * import com.ericfeminella.collections.IMap;
		 *
		 * var map:IMap = new HashMap();
		 * map.put( "admin", adminVO );
		 * map.put( "editor", editorVO );
		 * trace( map.size() ); //2
		 *
		 * map.clearAllExcept( "editor", editorVO );
		 * trace( map.getValues() ); //[object, editorVO]
		 * trace( map.size() ); //1
		 *
		 * </listing>
		 *
		 * @param the key which is not to be cleared from the map
		 *
		 */
		public function clearAllExcept(keyId:*):void
		{
			dispatchPropertyChangeEvent = false;

			for (var key:* in map.getDictonary())
			{
				if (key != keyId)
				{
					remove(key);
				}
			}

			dispatchPropertyChangeEvent = true;
			dispatchUpdatePropertiesEvent();
		}

		/**
		 *
		 * Returns an <code>IList</code> of <code>IHashMapEntry</code>
		 * objects based on the underlying internal map.
		 *
		 * @param <code>IList</code> of <code>IHashMapEntry</code> objects
		 *
		 */
		public function getEntries():IList
		{
			return map.getEntries();
		}

		public function getDictonary():Dictionary
		{
			return map.getDictonary();
		}

		public function keyToIndex(key:*):int
		{
			return keys.indexOf(key);
		}

		public function indexToKey(index:int):*
		{
			if (index < keys.length) return keys[index];
			return null;
		}

		private function checkKeyType(key:*):void
		{
			if (!ObjectUtil.isPrimitiveType(key)) throw new IllegalArgumentException("Key may be only a String.");
		}

		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------

		flash_proxy override function getProperty(name:*):*
		{
			return getValue(name.toString());
		}

		flash_proxy override function hasProperty(name:*):Boolean
		{
			return containsKey(name.toString());
		}

		flash_proxy override function setProperty(name:*, value:*):void
		{
			put(String(name), value);
		}

		flash_proxy override function deleteProperty(name:*):Boolean
		{
			if (!containsKey(String(name))) return false;
			remove(String(name));
			return true;
		}

		flash_proxy override function nextName(index:int):String
		{
			return keys[index - 1];
		}

		flash_proxy override function nextNameIndex(index:int):int
		{
			if (size() == 0) return 0;
			if (index < size()) return index + 1;
			else return 0;
		}

		flash_proxy override function nextValue(index:int):*
		{
			if (size() == 0) return undefined;
			return getValue(keys[index - 1]);
		}

		flash_proxy override function callProperty(name:*, ... rest):*
		{
			var value:* = getValue(name.toString());
			return value.apply(value, rest);
		}

// IEventDispatcher

		public function hasEventListener(type:String):Boolean
		{
			return eventDispatcher.hasEventListener(type);
		}

		public function willTrigger(type:String):Boolean
		{
			return eventDispatcher.willTrigger(type);
		}

		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			eventDispatcher.removeEventListener(type, listener, useCapture);
		}

		public function dispatchEvent(event:Event):Boolean
		{
			return eventDispatcher.dispatchEvent(event);
		}
	}
}