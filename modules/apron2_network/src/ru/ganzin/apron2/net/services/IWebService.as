package ru.ganzin.apron2.net.services
{
	import com.adobe.net.URI;

	import flash.events.IEventDispatcher;

	import ru.ganzin.apron2.data.IDataConverter;
	import ru.ganzin.apron2.data.codec.ICodec;

	[Event(name="serviceResult", type="ru.ganzin.apron2.net.services.event.WebServiceEvent")]
	[Event(name="serviceError", type="ru.ganzin.apron2.net.services.event.WebServiceEvent")]
	
	public interface IWebService extends IEventDispatcher
	{
		function get name():String;
		function set name(value:String):void;

		function get responseContentType():String;
		function set responseContentType(value:String):void;

		function get url():String;
		function set url(value:String):void;
		
		function get uri():URI;

		function get requestTimeout():int;
		function set requestTimeout(value:int):void;

		function get method():String;
		function set method(value:String):void;

		function get commonCodec():ICodec;
		function set commonCodec(value:ICodec):void;

		function get requestConverter():IDataConverter;
		function set requestConverter(value:IDataConverter):void;
		
		function get responseConverter():IDataConverter;
		function set responseConverter(value:IDataConverter):void;
		
		function get resultParser():IResultParser;
		function set resultParser(value:IResultParser):void;
	}
}