package ru.ganzin.apron2.net.services
{
	public interface IResultParser
	{
		function parse(data:*):IResponse;
	}
}