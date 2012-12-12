package ru.ganzin.apron2.utils.uid
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class UidUtil
	{
		private static const ALPHA_CHAR_CODES:Array = [48, 49, 50, 51, 52, 53, 54,
			55, 56, 57, 65, 66, 67, 68, 69, 70];

		private static var uidDictionary:Dictionary = new Dictionary(true);

		public static function createUID():String
		{
			var uid:Array = new Array(36);
			var index:int = 0;

			var i:int;
			var j:int;

			for (i = 0; i < 8; i++)
			{
				uid[index++] = ALPHA_CHAR_CODES[Math.floor(Math.random() * 16)];
			}

			for (i = 0; i < 3; i++)
			{
				uid[index++] = 45; // charCode for "-"

				for (j = 0; j < 4; j++)
				{
					uid[index++] = ALPHA_CHAR_CODES[Math.floor(Math.random() * 16)];
				}
			}

			uid[index++] = 45; // charCode for "-"

			var time:Number = new Date().getTime();
			// Note: time is the number of milliseconds since 1970,
			// which is currently more than one trillion.
			// We use the low 8 hex digits of this number in the UID.
			// Just in case the system clock has been reset to
			// Jan 1-4, 1970 (in which case this number could have only
			// 1-7 hex digits), we pad on the left with 7 zeros
			// before taking the low digits.
			var timeString:String = ("0000000" + time.toString(16).toUpperCase()).substr(-8);

			for (i = 0; i < 8; i++)
			{
				uid[index++] = timeString.charCodeAt(i);
			}

			for (i = 0; i < 4; i++)
			{
				uid[index++] = ALPHA_CHAR_CODES[Math.floor(Math.random() * 16)];
			}

			return String.fromCharCode.apply(null, uid);
		}

		public static function fromByteArray(ba:ByteArray):String
		{
			if (ba != null && ba.length >= 16 && ba.bytesAvailable >= 16)
			{
				var chars:Array = new Array(36);
				var index:uint = 0;
				for (var i:uint = 0; i < 16; i++)
				{
					if (i == 4 || i == 6 || i == 8 || i == 10)
						chars[index++] = 45; // Hyphen char code

					var b:int = ba.readByte();
					chars[index++] = ALPHA_CHAR_CODES[(b & 0xF0) >>> 4];
					chars[index++] = ALPHA_CHAR_CODES[(b & 0x0F)];
				}
				return String.fromCharCode.apply(null, chars);
			}

			return null;
		}

		public static function isUID(uid:String):Boolean
		{
			if (uid != null && uid.length == 36)
			{
				for (var i:uint = 0; i < 36; i++)
				{
					var c:Number = uid.charCodeAt(i);

					// Check for correctly placed hyphens
					if (i == 8 || i == 13 || i == 18 || i == 23)
					{
						if (c != 45)
						{
							return false;
						}
					}
					// We allow capital alpha-numeric hex digits only
					else if (c < 48 || c > 70 || (c > 57 && c < 65))
					{
						return false;
					}
				}

				return true;
			}

			return false;
		}

		public static function toByteArray(uid:String):ByteArray
		{
			if (isUID(uid))
			{
				var result:ByteArray = new ByteArray();

				for (var i:uint = 0; i < uid.length; i++)
				{
					var c:String = uid.charAt(i);
					if (c == "-")
						continue;
					var h1:uint = getDigit(c);
					i++;
					var h2:uint = getDigit(uid.charAt(i));
					result.writeByte(((h1 << 4) | h2) & 0xFF);
				}
				result.position = 0;
				return result;
			}

			return null;
		}

		public static function getUID(item:Object):String
		{
			var result:String = null;

			if (item == null)
				return result;

			if (item is IUid)
			{
				result = IUid(item).uid;
				if (result == null || result.length == 0)
				{
					result = createUID();
					IUid(item).uid = result;
				}
			}
			else if (item is String)
			{
				return item as String;
			}
			else
			{
				try
				{
					// We don't create uids for XMLLists, but if
					// there's only a single XML node, we'll extract it.
					if (item is XMLList && item.length == 1)
						item = item[0];

					if ("mx_internal_uid" in item)
						return item.mx_internal_uid;

					if ("uid" in item)
						return item.uid;

					result = uidDictionary[item];

					if (!result)
					{
						result = createUID();
						try
						{
							item.mx_internal_uid = result;
						}
						catch (e:Error)
						{
							uidDictionary[item] = result;
						}
					}
				}
				catch (e:Error)
				{
					result = item.toString();
				}
			}

			return result;
		}

		/**
		 * Returns the decimal representation of a hex digit.
		 * @private
		 */
		private static function getDigit(hex:String):uint
		{
			switch (hex)
			{
				case "A":
				case "a":
					return 10;
				case "B":
				case "b":
					return 11;
				case "C":
				case "c":
					return 12;
				case "D":
				case "d":
					return 13;
				case "E":
				case "e":
					return 14;
				case "F":
				case "f":
					return 15;
				default:
					return new uint(hex);
			}
		}
	}

}
