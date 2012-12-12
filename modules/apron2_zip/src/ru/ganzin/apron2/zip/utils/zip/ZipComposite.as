package ru.ganzin.apron2.zip.utils.zip
{
	import com.adobe.net.URI;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	import nochump.util.zip.ZipConstants;
	import nochump.util.zip.ZipEntry;
	import nochump.util.zip.ZipFile;
	import nochump.util.zip.ZipOutput;

	import ru.ganzin.apron2.apron_internal;
	import ru.ganzin.apron2.events.PropertyChangeEvent;
	import ru.ganzin.apron2.interfaces.IPropertyChangeNotifier;
	import ru.ganzin.apron2.utils.uid.UidUtil;

	use namespace apron_internal;

	public class ZipComposite implements IPropertyChangeNotifier
	{
		private var out:ZipOutput;
		private var indexes:Array = new Array();
		private var files:Dictionary = new Dictionary();
		private var entries:Dictionary = new Dictionary();
		
		public function ZipComposite()
		{
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

		private var _method:int = ZipConstants.DEFLATED;
		
		public function get method():int
		{
			return _method;
		}

		public function set method(value:int):void
		{
			if (_method == value) return;
			if (dispatcher.hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) setMethodWithDispatcher(value);
			else setMethodSimple(value);
			
			dispatchEvent(new ZipEvent(ZipEvent.UPDATED));
		}

		public function get bytes():ByteArray
		{
			if (indexes.length == 0) return null;
			if (out) return out.byteArray;

			out = new ZipOutput();
			var entry:ZipEntry;
			var bytes:ByteArray;
			for (var i:int = 0;i < indexes.length;i++)
			{
				entry = entries[indexes[i]];
				bytes = files[entry.name];
				entry.method = method;
				if (method == ZipConstants.STORED)
				{
					entry.size = bytes.length;
					entry.crc = ZipUtil.getCRC32(bytes);
				}
				out.putNextEntry(entry);
				out.write(bytes);
				out.closeEntry();
			}
			out.finish();
			return out.byteArray;
		}

		public function set bytes(value:ByteArray):void
		{
			if (dispatcher.hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) setBytesWithDispatcher(value);
			else setBytesSimple(value);
			
			dispatchEvent(new ZipEvent(ZipEvent.UPDATED));
		}

		public function get size():int
		{
			return indexes.length;
		}

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		public function containFile(name:String):Boolean
		{
			return findFileId(name) != -1;
		}

		public function getFile(name:String):ByteArray
		{
			var bytes:ByteArray = getFileByIndex(findFileId(name));
			if (!bytes) return undefined;
			bytes.position = 0;
			return bytes;
		}

		public function getFileComment(name:String):String
		{
			return ZipEntry(entries[name]).comment;
		}

		public function getFileByIndex(id:int):ByteArray
		{
			return files[getFileNameById(id)];
		}

		public function addFile(name:String, bytes:ByteArray, comment:String = null):void
		{
			if (dispatcher.hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) addFileWithDispatcher(name, bytes, comment);
			else addFileSimple(name, bytes, comment);
			
			dispatchEvent(new ZipEvent(ZipEvent.UPDATED));
		}

		public function removeFile(name:String):Boolean
		{
			if (containFile(name))
			{
				if (dispatcher.hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) removeFileWithDispatcher(name);
				else removeFileSimple(name);
				
				dispatchEvent(new ZipEvent(ZipEvent.UPDATED));
				
				return true;
			}
			
			return false;
		}

		public function getFileNameById(id:int):String
		{
			return String(indexes[id]);
		}
		
		public function clear():void
		{
			if (indexes.length == 0) return;
			
			if (dispatcher.hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) clearWithDispatcher();
			else clearSimple();
			
			dispatchEvent(new ZipEvent(ZipEvent.UPDATED));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private Methods
		//
		//--------------------------------------------------------------------------
		
		private function setMethodSimple(value:int):void
		{
			_method = value;
			out = null;
		}

		private function setMethodWithDispatcher(value:int):void
		{
			var oldMethod:int = method;
			var oldBytes:ByteArray = bytes;
			
			setMethodSimple(value);
			
			var event:PropertyChangeEvent = PropertyChangeEvent.createUpdateEvent(this, "method", oldMethod, value);
			dispatcher.dispatchEvent(event);
				
			comiteBytesChange(oldBytes);
		}

		private function setBytesSimple(bytes:ByteArray):void
		{
			bytes.position = 0;

			indexes = new Array();
			files = new Dictionary();
			entries = new Dictionary();

			var zip:ZipFile = new ZipFile(bytes);
			var name:String;
			for each(var entry:ZipEntry in zip.entries)
			{
				name = entry.name;
				entries[name] = entry.clone();
				files[name] = zip.getInput(entry);
				indexes.push(name);
			}
		}

		private function setBytesWithDispatcher(bytes:ByteArray):void
		{
			var oldVal:ByteArray = bytes;
			setBytesSimple(bytes);
			comiteBytesChange(oldVal);
		}

		private function addFileSimple(name:String, bytes:ByteArray, comment:String = null):void
		{
			files[name] = bytes;
			entries[name] = new ZipEntry(name);
			
			var index:int = indexes.indexOf(name);
			if (index != -1) indexes.splice(index,1);
			indexes.push(name);
			
			if (comment) ZipEntry(entries[name]).comment = comment;
			
			out = null;
		}

		private function addFileWithDispatcher(name:String, bytes:ByteArray, comment:String = null):void
		{
			var oldVal:ByteArray = bytes;
			addFileSimple(name, bytes, comment);
			comiteBytesChange(oldVal);
		}

		private function removeFileSimple(name:String):void
		{
			delete files[name];
			delete entries[name];
			indexes.splice(indexes.indexOf(name), 1);
			
			out = null;
		}

		private function removeFileWithDispatcher(name:String):void
		{
			var oldVal:ByteArray = bytes;
			removeFile(name);
			comiteBytesChange(oldVal);
		}
		
		private function clearSimple():void
		{
			indexes = new Array();
			files = new Dictionary();
			entries = new Dictionary();
			out = null;			
		}
		
		private function clearWithDispatcher():void
		{
			var oldVal:ByteArray = bytes;
			clearSimple();
			comiteBytesChange(oldVal, null);
		}

		private function comiteBytesChange(oldBytes:ByteArray, newBytes:ByteArray = null):void
		{
			if (!newBytes) newBytes = bytes;
			var event:PropertyChangeEvent = PropertyChangeEvent.createUpdateEvent(this, "bytes", oldBytes, newBytes);
			dispatcher.dispatchEvent(event);			
		}
		
		private function findFileId(filePath:String):int
		{
			var uriFilePath:URI = new URI("zip://"+filePath.replace(/^[\.\/]*/,""));
			var uriFile:URI;
			for (var i:int=0;i<indexes.length;i++)
			{
				uriFile = new URI("zip://"+indexes[i].replace(/^[\.\/]*/,""));
				if (uriFile.getRelation(uriFilePath) == URI.EQUAL) return i;
			}
			
			return -1;
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