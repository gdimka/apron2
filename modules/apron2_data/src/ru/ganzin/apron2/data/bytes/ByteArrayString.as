package ru.ganzin.apron2.data.bytes
{
	import com.hurlant.util.Hex;

	import flash.utils.ByteArray;

	public class ByteArrayString extends ByteArray
	{
		public function ByteArrayString(value:String = null)
		{
			if (value != null) setString(value);
		}

		public function getString():String
		{
			this.position = 0;
			return readUTFBytes(length);
		}
		public function setString(value:String):void
		{
			clear();
			writeUTFBytes(value);
		}

		public function getHex():String
		{
			return Hex.fromArray(this);
		}
		public function setHex(value:String):void
		{
			var ba:ByteArray = Hex.toArray(value);

			this.clear();
			this.writeBytes(ba);
		}
	}
}