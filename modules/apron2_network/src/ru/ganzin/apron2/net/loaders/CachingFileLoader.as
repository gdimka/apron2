package ru.ganzin.apron2.net.loaders
{
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;

	import ru.ganzin.apron2.net.*;
	import com.adobe.net.URI;

	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class CachingFileLoader extends CompositeLoader
	{
		private static var cache:BitmapCacheMap = new BitmapCacheMap();

		public static function isFileCached(url:Object):Boolean
		{
			return cache.containsKey(url.toString());
		}
		
		public static function getCachedBytes(url:Object):ByteArray
		{
			return cache.getValueAsByteArray(url.toString());
		}

		public static function getCachedData(url:Object):*
		{
			return cache.getValue(url.toString());
		}

		private static var loaders:Dictionary = new Dictionary();

		public static function getLoader(request:* = null, type:String = null, ttl:int = -1, autoLoad:Boolean = false):CachingFileLoader
		{
			var url:String;
			if (request)
			{
				if (request is String || request is URI) url = request.toString();
				else if (request is URLRequest) url = URLRequest(request).url;
				if (loaders[url]) return loaders[url];
			}
			
			var loader:CachingFileLoader = new CachingFileLoader(ttl);
			if (type) loader.type = type;
			if (request) loader.request = request;
			if (autoLoad) loader.load(null, type);
			return loader;
		}

		private var loadedFromCache:Boolean = false;
		private var loading:Boolean = false;
		private var loaded:Boolean = false;

		public function CachingFileLoader(ttl:int = -1)
		{
			super();
			this.ttl = ttl;
		}

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		// TTL
		private var _ttl:int;

		public function get ttl():int
		{
			return _ttl;
		}

		public function set ttl(value:int):void
		{
			_ttl = value;
		}

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		override public function load(request:* = null, type:String = null, context:LoaderContext = null):void
		{
			if (loading) return;
			
			if (request) this.request = request;
			
			var bytes:ByteArray;
			var key:String = url;
			
			if (cache.containsKey(key))	bytes = getCachedBytes(key);
			
			if (bytes)
			{
				loadedFromCache = true;
				if (context) context.checkPolicyFile = false;
				super.loadBytes(bytes, context);
			}
			else
			{
				loaders[url] = this;
				super.load(this.request, type, context);
			}
			
			loading = true;
		}

		override protected function onComplete(e:Event):void
		{
			loading = false;
			
			if (!loadedFromCache && ttl != 0)
			{
				var ci:BitmapCacheInfo = new BitmapCacheInfo();
				ci.bytes = bytes;
				ci.data = data;
				cache.putTTL(url.toString(), ci, ttl);
			}
			
			loaded = true;
			
			super.onComplete(e);
		}

		override protected function onIOError(event:IOErrorEvent):void
		{
			loading = false;

			super.onIOError(event);
		}

		override protected function onSecurityError(event:SecurityErrorEvent):void
		{
			loading = false;

			super.onSecurityError(event);
		}

		override public function close() : void
		{
			loading = false;
			super.close();
		}

	}
}