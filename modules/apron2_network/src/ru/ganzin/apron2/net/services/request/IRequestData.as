package ru.ganzin.apron2.net.services.request
{
	import ru.ganzin.apron2.net.services.IRequest;

	public interface IRequestData extends IRequest
	{
		function get type():String;
		
		function get messageId():String;
		function set messageId(value:String):void;
	}
}