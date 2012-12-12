package ru.ganzin.apron2.data.codec.graphics
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;

	public interface IImageDecoder
	{
		function get contentType():String;

		function checkSingnature(bytes:ByteArray):Boolean;

		function decode(bytes:ByteArray):BitmapData;
	}
}
