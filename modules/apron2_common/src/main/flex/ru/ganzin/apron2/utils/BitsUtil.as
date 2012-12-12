package ru.ganzin.apron2.utils
{
	public class BitsUtil 
	{
		public static function getNumber(value:Number, start:Number, length:Number):Number 
		{
			if (length == -1) length = countBits(value) - start;
			if (length < 0) return 0;
			return ((((value >>> start) >>> length) << length) ^ (value >>> start));
		}

		public static function setNumber(value:Number, val:Number, start:Number, length:Number):Number 
		{
			var a:Number = getNumber(value, start, length);
			var b:Number = value ^ (a << start);
			var c:Number = val << start;
			return (b ^ c);
		}

		public static function countBits(value:Number):int
		{
			return value.toString(2).length;
		}
	}
}
