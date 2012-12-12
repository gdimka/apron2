package ru.ganzin.apron2.net.loaders
{
	import com.adobe.utils.StringUtil;

	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;

	import ru.ganzin.apron2.SimpleClass;
	import ru.ganzin.apron2.net.FileDataFormat;

	public class IndexLoader extends SimpleClass
	{
		private var loader:CompositeLoader;

		public function IndexLoader()
		{
			loader = new CompositeLoader();
			loader.type = FileDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, resultEventHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, faultEventHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, faultEventHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		private var _url:String;
		public function get url():String
		{
			return _url;
		}

		public function set url(value:String):void
		{
			_url = value;
		}
		
		private var _items:Array;
		public function get items():Array
		{
			return _items;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------		
		
		public function load():void
		{
			loader.load(url);
		}
		
		private function parse(value:XML):void
		{
			_items = new Array();
			
			var ahrefs:XMLList = (new XML(value))..a.@href;
			for each (var item:XML in ahrefs)
			{
				var href:String = item.toString();
				if (href.lastIndexOf("/") != (href.length - 1))
				{
					_items.push(href);
				}
			}
		}
		
		private function resultEventHandler(event:Event):void
		{
			var result:String = loader.data;
			result = StringUtil.replace(result, "<hr>", "<hr/>");
			parse(new XML(result));
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function faultEventHandler(event:ErrorEvent):void
		{
			logger.error("IndexLoader fault.");
			logger.error(event.text);
			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
		}
	}
}