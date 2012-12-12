package ru.ganzin.apron2.resources
{
	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;

	import mx.resources.IResourceBundle;

	import ru.ganzin.apron2.SimpleClass;
	import ru.ganzin.apron2.apron_internal;
	import ru.ganzin.apron2.events.PropertyChangeEvent;
	import ru.ganzin.apron2.utils.ObjectProxy;

	use namespace apron_internal;

	public class LocalResourceBundle extends SimpleClass implements IResourceBundle
	{
		apron_internal var so:SharedObject;
		apron_internal var name:String;

		public function LocalResourceBundle(locale:String, bundleName:String, autoFlush:Boolean = false, reserveSize:int = 0)
		{
			_locale = locale;
			_bundleName = bundleName;
			_autoFlush = autoFlush;
			_reserveSize = Math.max(0, reserveSize);

			name = (locale) ? bundleName + "_" + locale : bundleName;
			so = SharedObject.getLocal(name);
			if (_reserveSize > 0) so.flush(_reserveSize);

			_content = new ObjectProxy(so.data);
			_content.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, updateContentHandler, false, 0, true);
		}

		//----------------------------------
		//  autoFlush
		//----------------------------------
		apron_internal var _autoFlush:Boolean = false;

		public function get autoFlush():Boolean
		{
			return Boolean(_autoFlush);
		}

		public function set autoFlush(value:Boolean):void
		{
			_autoFlush = value;
		}

		//----------------------------------
		//  size
		//----------------------------------
		public function get size():int
		{
			return so.size;
		}

		//----------------------------------
		//  reserveSize
		//----------------------------------
		apron_internal var _reserveSize:int;

		public function get reserveSize():int
		{
			return _reserveSize;
		}

		public function set reserveSize(value:int):void
		{
			_reserveSize = value;
			flush();
		}

		//----------------------------------
		//  content
		//----------------------------------
		apron_internal var _content:ObjectProxy;

		public function get content():Object
		{
			return _content;
		}

		//----------------------------------
		//  locale
		//----------------------------------

		/**
		 *  @private
		 *  Storage for the locale property.
		 */
		apron_internal var _locale:String;

		/**
		 *  @copy mx.resources.IResourceBundle#locale
		 */
		public function get locale():String
		{
			return _locale;
		}

		//----------------------------------
		//  bundleName
		//----------------------------------

		/**
		 *  @private
		 *  Storage for the bundleName property.
		 */
		apron_internal var _bundleName:String;

		/**
		 *  @copy mx.resources.IResourceBundle#bundleName
		 */
		public function get bundleName():String
		{
			return _bundleName;
		}

		//-------------------------------------------------
		//
		//	Methods
		//
		//-------------------------------------------------
		
		public function clear():void
		{
			so.clear();
			so.close();

			so = SharedObject.getLocal(name);
			if (reserveSize > 0) so.flush(reserveSize);

			_content = new ObjectProxy(so.data);
			_content.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, updateContentHandler, false, 0, true);
		}

		/**
		 *  @private
		 */
		private function updateContentHandler(e:PropertyChangeEvent):void
		{
			//trace(StringUtil.substitute("updateHandler('{0}', {1}, {2}, {3}, '{4}')", e.kind, e.property, e.oldValue, e.newValue, e.target.uid));
			if (autoFlush) flush();
		}

		public function flush():void
		{
			var flushStatus:String = null;
			try
			{
				flushStatus = so.flush(reserveSize);
			}
			catch(e:Error)
			{
				logger.error("Error...Could not write LocalResourceBundle to disk.");
			}

			switch(flushStatus)
			{
				case SharedObjectFlushStatus.PENDING:
					logger.debug("Requesting permission to save object...");
					so.addEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
					break;
				case SharedObjectFlushStatus.FLUSHED:
					logger.debug("Value flushed to disk.");
					break;
			}
		}

		private function onFlushStatus(event:NetStatusEvent):void
		{
			logger.debug("User closed permission dialogger...");
			switch (event.info["code"])
			{
				case "SharedObject.Flush.Success":
					logger.debug("User granted permission -- value saved.");
					break;
				case "SharedObject.Flush.Failed":
					logger.debug("User denied permission -- value not saved.");
					break;
			}
			so.removeEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
		}
	}
}