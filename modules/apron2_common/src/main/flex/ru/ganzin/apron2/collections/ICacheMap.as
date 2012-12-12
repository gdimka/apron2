package ru.ganzin.apron2.collections
{
	public interface ICacheMap extends IMap
	{
		function putEntryTTL(entry:IHashMapEntry, ttl:int = -1) : void;
		function putTTL(key:*, value:*, ttl:int = -1) : void;
		function updateTTL(key:*, ttl:int = -1) : void;
		function getCacheInfo(key:*):CacheInfo;
	}
}