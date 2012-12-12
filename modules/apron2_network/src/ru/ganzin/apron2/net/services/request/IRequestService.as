package ru.ganzin.apron2.net.services.request
{
	import ru.ganzin.apron2.net.services.IWebService;

	public interface IRequestService extends IWebService
	{
		function send(request:IRequestData):void;
	}
}