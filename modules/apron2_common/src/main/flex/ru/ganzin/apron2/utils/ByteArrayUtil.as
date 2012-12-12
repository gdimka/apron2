package ru.ganzin.apron2.utils
{
	import flash.utils.ByteArray;

	public class ByteArrayUtil
	{
		static public function clone(bytes:ByteArray):ByteArray
		{
			if (!_bytes) return null;

			var oldPos:int = bytes.position;
			var _bytes:ByteArray = new ByteArray();
			_bytes.endian = bytes.endian;
			_bytes.objectEncoding = bytes.objectEncoding;
			_bytes.writeBytes(bytes);
			_bytes.position = oldPos;
			bytes.position = oldPos;
			
			return _bytes;
		}

		static public function compare(a:ByteArray, b:ByteArray):Boolean
		{
			if (a == null || b == null || a.length != b.length) return false;
        	else
			{
				a.position = 0;
				b.position = 0;
				for (var i:int = 0;i < a.length; i++)
				{
					if(a.readByte() != b.readByte()) return false;
				}
			}
			return true;
		}
	}
}
