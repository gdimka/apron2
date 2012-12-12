package ru.ganzin.apron2.collections
{
	import flash.utils.getTimer;

	public class CacheInfo
	{
		public var wh:uint;
		public var ttl:int = -1;
		public var data:*;
		
		public function CacheInfo()
		{
			resetWh();
		}
		
		public function resetWh():void
		{
			wh = getTimer();
		}
		
		public function isExpired():Boolean
		{
			if (ttl == -1) return false;
			return getTimer() > (wh+ttl);
		}
	}
}
