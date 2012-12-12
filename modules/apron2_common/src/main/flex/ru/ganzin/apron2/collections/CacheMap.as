package ru.ganzin.apron2.collections
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import org.as3commons.collections.ArrayList;
	import org.as3commons.collections.framework.IList;

	public class CacheMap extends HashMap implements ICacheMap
	{
		private var timer:Timer;

		public function CacheMap(checkDelay:uint = 2000)
		{
			super(false);

			timer = new Timer(checkDelay);
			timer.addEventListener(TimerEvent.TIMER, timer_TimerHandler);
			timer.start();
		}

		private function timer_TimerHandler(e:Event):void
		{
			update();
		}

		public function putEntryTTL(entry:IHashMapEntry, ttl:int = -1):void
		{
			putTTL( entry.key, entry.value, ttl);
		}

		public function putTTL(key:*, value:*, ttl:int = -1):void
		{
			var info:CacheInfo = new CacheInfo();
			info.ttl = ttl;
			info.data = value;

			super.put(key, info);
		}
		
		public function updateTTL(key:*, ttl:int = -1):void
		{
			var info:CacheInfo = super.getValue(key) as CacheInfo;
			if (!info) return;
			info.ttl = ttl;			
			info.resetWh();
		}

		override public function getValue(key:*):*
		{
			update();
			
			var value:* = super.getValue(key);
			if (value is CacheInfo) return (value as CacheInfo).data;
			else return value;
		}

		public function getCacheInfo(key:*):CacheInfo
		{
			update();

			var value:* = super.getValue(key);
			if (value is CacheInfo) return value;
			else return null;
		}

		override public function getValues():Array
		{
			var values:Array = [];
			var keys:Array = getKeys();
			for each (var key:* in keys)
            {
                values.push( getValue(key) );
            }
            return values;
		}

		override public function getEntries():IList
		{
			var list:IList = new ArrayList();
			var keys:Array = getKeys();
			for each(var key:* in keys)
			{
				list.add(new HashMapEntry(key, getValue(key)));
			}
			return list;
		}


		//---------------------------------------
		//	TTL
		//---------------------------------------
		private function update():void
		{
			if (size() == 0) return;

			var list:IList = super.getEntries();
			for each (var entry:HashMapEntry in list)
			{
				if (entry.value is CacheInfo && CacheInfo(entry.value).isExpired())
					remove(entry.key);
			}
			
			list.clear();
			list = null;
		}
	}
}
