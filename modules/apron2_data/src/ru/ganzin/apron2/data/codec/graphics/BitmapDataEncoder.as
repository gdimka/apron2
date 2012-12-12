package ru.ganzin.apron2.data.codec.graphics
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;

	import ru.ganzin.apron2.apron_internal;

	public class BitmapDataEncoder
	{
		apron_internal static const CONTENT_TYPE:String = "image/bitmap-data";

		public function encodeByteArray(byteArray:ByteArray, width:int, height:int, transparent:Boolean = true):ByteArray
		{
			return internalEncode(byteArray, width, height, transparent);
		}

		public function encode(bitmapData:BitmapData):ByteArray
		{
			return internalEncode(bitmapData, bitmapData.width, bitmapData.height, bitmapData.transparent);
		}

		public function get contentType():String
		{
			return apron_internal::CONTENT_TYPE;
		}

		private function internalEncode(source:Object, width:int, height:int, transparent:Boolean = true):ByteArray
		{
			var sourceBitmapData:BitmapData = source as BitmapData;
			var sourceByteArray:ByteArray = source as ByteArray;
			
			if (sourceByteArray) sourceByteArray.position = 0;
			
			// Create output byte array
			var bmp:ByteArray = new ByteArray();
			
			// Write BitmapData signature "!BD"
			bmp.writeUnsignedInt(0x214244);
			
			// Build info chunk
			var info:ByteArray = new ByteArray();
			info.writeInt(width);
			info.writeInt(height);
			info.writeBoolean(transparent);

			bmp.writeBytes(info);
			
			if (sourceByteArray) bmp.writeBytes(sourceByteArray);
			else if (sourceBitmapData) bmp.writeBytes(sourceBitmapData.getPixels(sourceBitmapData.rect));
			
			return bmp;
		}
	}
}