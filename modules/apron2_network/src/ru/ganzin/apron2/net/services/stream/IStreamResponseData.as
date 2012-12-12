package ru.ganzin.apron2.net.services.stream
{
	import ru.ganzin.apron2.net.services.IResponse;

	public interface IStreamResponseData extends IResponse
	{
		function get type():String;
		function get result():*;
	}
}
