package ru.ganzin.apron2.net.services.request
{
	import ru.ganzin.apron2.net.services.IResponse;

	public interface IResponseData extends IResponse
	{
		function get type():String;
		function get result():*;
	}
}