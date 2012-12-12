package ru.ganzin.apron2.utils
{
	import flash.system.Capabilities;
	import flash.utils.getTimer;

	/***********************************************************************************************************/
	public class SystemUtil
	{
		private static var bCompiledByMTASC:Boolean = false;

		/*******************************************************************************************************/
		public static function getFlashPlayerVersion():String
		{
			return Capabilities.version;
		}
		public static function getFlashPlayerVersionFromObject():Object
		{
			var sVersion:String = getFlashPlayerVersion();
			var pattern:RegExp = /^(\w*) (\d*),(\d*),(\d*),(\d*)$/;
			var result:Object = pattern.exec(sVersion);
			var sPlatform:String = result[1];
			return {platform:sPlatform, major:result[2], minor:result[3], build:result[4], revision:result[5]};
		}
		/*******************************************************************************************************/
		public static function getFlashPlayerVersionPlatform():String
		{
			return getFlashPlayerVersionFromObject().platform;
		}
		public static function getFlashPlayerVersionMajor():Number
		{
			return getFlashPlayerVersionFromObject().major;
		}
		public static function getFlashPlayerVersionMinor():Number
		{
			return getFlashPlayerVersionFromObject().minor;
		}
		public static function getFlashPlayerVersionBuild():Number
		{
			return getFlashPlayerVersionFromObject().build;
		}
		public static function getFlashPlayerVersionRevision():Number
		{
			return getFlashPlayerVersionFromObject().revision;
		}
		/*******************************************************************************************************/
		public static function getSystemTimer():Number
		{
			return getTimer();
		}
		/*******************************************************************************************************/
		public static function setCompiledByMTASC(bValue:Boolean):void
		{
			bCompiledByMTASC = bValue;
		}
		public static function getCompiledByMTASC():Boolean
		{
			return isCompiledByMTASC();
		}
		public static function isCompiledByMTASC():Boolean
		{
			return bCompiledByMTASC;
		}
		/*******************************************************************************************************/
	}
}
