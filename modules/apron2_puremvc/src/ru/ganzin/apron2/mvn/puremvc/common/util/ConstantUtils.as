package ru.ganzin.apron2.mvn.puremvc.common.util
{
	public final class ConstantUtils
	{
		public static function getConstant(value:String):String
		{
			return "/const/" + value;
		}

		public static function getNoteType(value:String):String
		{
			return "/noteType/" + value;
		}

		public static function getNote(value:String):String
		{
			return "/note/" + value;
		}
	}
}