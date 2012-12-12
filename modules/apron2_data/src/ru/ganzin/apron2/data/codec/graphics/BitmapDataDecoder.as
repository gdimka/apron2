package ru.ganzin.apron2.data.codec.graphics
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;

	import ru.ganzin.apron2.apron_internal;

	public class BitmapDataDecoder implements IImageDecoder
	{
		apron_internal static function checkSingnature(bytes:ByteArray):Boolean
		{
			bytes.position = 0;
			var sig:int = bytes.readUnsignedInt();
			if (sig == 0x214244) return true;
			return false;
		}

		public function get contentType():String
		{
			return BitmapDataEncoder.apron_internal::CONTENT_TYPE;
		}

		public function decode(bytes:ByteArray):BitmapData
		{
			if (!checkSingnature(bytes)) return null;

			var width:int = bytes.readInt();
			var height:int = bytes.readInt();
			var transparent:Boolean = bytes.readBoolean();

			var pixels:ByteArray = new ByteArray();
			bytes.readBytes(pixels);

			var bmp:BitmapData = new BitmapData(width, height, transparent);
			bmp.setPixels(bmp.rect, pixels);
			
			return bmp;
		}

		public function checkSingnature(bytes:ByteArray):Boolean
		{
			return apron_internal::checkSingnature(bytes);
		}
	}
}
