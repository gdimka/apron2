package ru.ganzin.apron2.net.services.stream
{
	import ru.ganzin.apron2.net.services.IWebService;

	public interface IStreamService extends IWebService
	{
		function connect(data:IStreamRequestData):Boolean;
		function close():void;
	}
}