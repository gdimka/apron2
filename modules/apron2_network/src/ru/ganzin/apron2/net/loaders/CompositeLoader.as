package ru.ganzin.apron2.net.loaders
{
	import com.adobe.net.URI;

	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	import ru.ganzin.apron2.SimpleClass;
	import ru.ganzin.apron2.net.FileDataFormat;
	import ru.ganzin.apron2.utils.ByteArrayUtil;

	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
	[Event(name="complete", type="flash.events.Event")]
	[Event(name="progress", type="flash.events.ProgressEvent")]

	public class CompositeLoader extends SimpleClass
	{
		private static var count:int = 0;
		private static var loading:Dictionary = new Dictionary();

		private var name:String = "ru.ganzin.apron2.net.loaders.CompositeLoader" + (count++);
		private var currentLoader:Object;

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function CompositeLoader()
		{
			logger = getLogger(name);
		}

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		// Request
		private var _request:URLRequest;

		public function get request():URLRequest
		{
			return _request;
		}

		public function set request(value:*):void
		{
			if (value is String || value is URI)
			{
				_request = new URLRequest(value.toString());
			}
			else if (value is URLRequest) _request = value;
			else throw new ArgumentError("Illegal request");
		}

		// URL
		public function get url():String
		{
			if (request) return request.url;
			return null;
		}

		public function set url(value:String):void
		{
			if (!request) request = new URLRequest();
			request.url = value;
		}

		// Type
		private var _type:String = FileDataFormat.BINARY;

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

		// Loaded
		private var _loaded:Boolean;

		public function get isLoaded():Boolean
		{
			return _loaded;
		}

		// Data
		private var _data:*;

		public function get data():*
		{
			return _data;
		}

		// Bytes
		private var _bytes:ByteArray;
		public function get bytes():ByteArray
		{
			return _bytes;
		}

		private var _context:LoaderContext;
		public function context():LoaderContext
		{
			return _context;
		}

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		public function load(request:* = null, type:String = null, context:LoaderContext = null):void
		{
			if (request) this.request = request;
			else if (!this.request) throw new Error("Request undefined.");

			if (type) this.type = type;

			_context = context;
			_loaded = false;

			loading[this] = this.request;

			switch (this.type)
			{
				case FileDataFormat.BINARY:

					var urlStream:URLStream = createUrlStream();
					urlStream.load(this.request);
					currentLoader = urlStream;

					break;

				case FileDataFormat.TEXT:
				case FileDataFormat.VARIABLES:
				case FileDataFormat.BINARY_MEDIA:

					var urlLoader:URLLoader = createUrlLoader(this.type);
					urlLoader.load(this.request);
					currentLoader = urlLoader;

					break;

				case FileDataFormat.MEDIA:

					var loader:Loader = createLoader();
					loader.load(this.request, context);
					currentLoader = loader;

					break;
			}
		}

		public function loadBytes(bytes:ByteArray, context:LoaderContext = null):void
		{
			_loaded = false;
			_data = null;
			type = FileDataFormat.MEDIA;

			var loader:Loader = createLoader();
			loader.loadBytes(bytes, context);

			currentLoader = loader;
		}

		public function close():void
		{
			try
			{
				if (currentLoader && currentLoader["close"]) currentLoader["close"]();
			}
			catch(e:Error)
			{
			}
		}

		private function createUrlStream():URLStream
		{
			var urlStream:URLStream = new URLStream();
			urlStream.addEventListener(Event.COMPLETE, eventsHandler, false, 0, true);
			urlStream.addEventListener(ProgressEvent.PROGRESS, eventsHandler, false, 0, true);
			urlStream.addEventListener(IOErrorEvent.IO_ERROR, eventsHandler, false, 0, true);
			urlStream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, eventsHandler, false, 0, true);
			return urlStream;
		}

		private function createUrlLoader(type:String):URLLoader
		{
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, eventsHandler, false, 0, true);
			urlLoader.addEventListener(ProgressEvent.PROGRESS, eventsHandler, false, 0, true);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, eventsHandler, false, 0, true);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, eventsHandler, false, 0, true);

			if (type == FileDataFormat.TEXT) urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			else if (type == FileDataFormat.VARIABLES) urlLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
			else if (type == FileDataFormat.BINARY_MEDIA) urlLoader.dataFormat = URLLoaderDataFormat.BINARY;

			return urlLoader;
		}

		private function createLoader():Loader
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, eventsHandler, false, 0, true);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, eventsHandler, false, 0, true);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, eventsHandler, false, 0, true);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, eventsHandler, false, 0, true);
			return loader;
		}

		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		private function eventsHandler(e:Event):void
		{
			var target:Object = e.target;
			switch (e.type)
			{
				case Event.COMPLETE:

					if (target is URLLoader)
					{
						if (URLLoader(target).dataFormat == URLLoaderDataFormat.TEXT
								|| URLLoader(target).dataFormat == URLLoaderDataFormat.VARIABLES) _data = URLLoader(target).data;
						else if (type == FileDataFormat.BINARY_MEDIA)
						{
                            if (!_context) _context = new LoaderContext(false);
							else _context.checkPolicyFile = false;
							var byteLoader:Loader = new Loader();
							byteLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, eventsHandler, false, 0, true);
							byteLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, eventsHandler, false, 0, true);
							byteLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, eventsHandler, false, 0, true);
							byteLoader.loadBytes(URLLoader(target).data, _context);

							_bytes = ByteArrayUtil.clone(URLLoader(target).data);

							return;
						}

						_bytes = new ByteArray();
						_bytes.writeObject(_data);
					}
					else if (target is URLStream)
					{
						var b:ByteArray = new ByteArray();
						URLStream(target).readBytes(b);
						_data = _bytes = b;
					}
					else if (target is LoaderInfo)
					{
						_data = LoaderInfo(target).content;
						if (LoaderInfo(target).bytes) _bytes = ByteArrayUtil.clone(LoaderInfo(target).bytes);
					}

					_loaded = true;
					onComplete(e);
					break;

				case IOErrorEvent.IO_ERROR:
					logger.warn(e.toString());
					onIOError(IOErrorEvent(e));
					break;

				case SecurityErrorEvent.SECURITY_ERROR:
					logger.warn(e.toString());
					onSecurityError(SecurityErrorEvent(e));
					break;

				case ProgressEvent.PROGRESS:
					onProgress(ProgressEvent(e));
					break;
			}
		}

		protected function onComplete(event:Event):void
		{
			dispatchEvent(event);
		}

		protected function onIOError(event:IOErrorEvent):void
		{
			dispatchEvent(event);
		}

		protected function onSecurityError(event:SecurityErrorEvent):void
		{
			dispatchEvent(event);
		}

		protected function onProgress(event:ProgressEvent):void
		{
			dispatchEvent(event);
		}
	}

}
