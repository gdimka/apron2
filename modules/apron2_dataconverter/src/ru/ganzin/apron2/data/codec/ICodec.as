package ru.ganzin.apron2.data.codec
{
	public interface ICodec
	{
		function encode(data:*):*
		function decode(data:*):*
	}
}