package ru.ganzin.apron2.net.loaders
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.net.URLLoader;
	import flash.utils.ByteArray;

	import org.as3commons.collections.ArrayList;
	import org.as3commons.collections.framework.IList;

	import ru.ganzin.apron2.apron_internal;
	import ru.ganzin.apron2.collections.CacheInfo;
	import ru.ganzin.apron2.collections.CacheMap;
	import ru.ganzin.apron2.collections.HashMapEntry;
	import ru.ganzin.apron2.data.codec.graphics.BitmapDataDecoder;
	import ru.ganzin.apron2.data.codec.graphics.BitmapDataEncoder;
	import ru.ganzin.apron2.utils.ByteArrayUtil;

	internal class BitmapCacheMap extends CacheMap
	{
		public function BitmapCacheMap()
		{
			super();
		}
		
		override public function putTTL(key:*, value:*, ttl:int=-1) : void
		{
			var bytes:ByteArray;
			
			if (value is CacheInfo)
			{
				if (ttl != -1) (value as CacheInfo).ttl = ttl;
				super.put(key, value);
				
				return;
			}
			else if (value is Loader)
			{
				bytes = ByteArrayUtil.clone(Loader(value).contentLoaderInfo.bytes);
				value = Loader(value).contentLoaderInfo.content;
			}
			else if (value is LoaderInfo)
			{
				bytes = ByteArrayUtil.clone(LoaderInfo(value).bytes);
				value = LoaderInfo(value).content;
			}
			else if (value is URLLoader)
			{
				bytes = new ByteArray();
				bytes.writeObject(URLLoader(value).data);
				value = URLLoader(value).data;
			}
			else if (value is Bitmap)
			{
				bytes = encBitmapData(Bitmap(value).bitmapData);
			}
			else if (value is BitmapData)
			{
				bytes = encBitmapData(BitmapData(value));
			}
			else if (value is ByteArray)
			{
				bytes = ByteArrayUtil.clone(value);
			}
			else if (value is Object)
			{
				bytes = new ByteArray();
				bytes.writeObject(value);
			}
			
			var info:BitmapCacheInfo = new BitmapCacheInfo();
			info.ttl = ttl;
			info.data = value;
			info.bytes = bytes;
			
			super.put(key, info);
		}
		
		//---------------------------------------
		//	Methods
		//---------------------------------------
		
		public function canGetValueAsBitmapData(key:*):Boolean
		{
			var value:BitmapCacheInfo = super.getValue(key);
			if (value.data is BitmapData) return true;
			return isBitmapDataByteArray(value.bytes);
		}
		
		private function encBitmapData(bitmapData:BitmapData):ByteArray
		{
			var enc:BitmapDataEncoder = new BitmapDataEncoder();
			return enc.encode(bitmapData);
		}
		
		private function isBitmapDataByteArray(bytes:ByteArray):Boolean
		{
			return BitmapDataDecoder.apron_internal::checkSingnature(bytes);
		}
		
		// Utils
		
		public function getValueAsByteArray(key:*):ByteArray
		{
			var value:BitmapCacheInfo = BitmapCacheInfo(super.getCacheInfo(key));
			return value.bytes;
		}
		
		public function getValueAsBitmapData(key:*):BitmapData
		{
			var value:BitmapCacheInfo = super.getValue(key);
			if (value.data is BitmapData) return value.data;
			var decoder:BitmapDataDecoder = new BitmapDataDecoder();
			return decoder.decode(value.bytes);
		}
		
		public function getValuesAsByteArray():Array
		{
			var values:Array = [];
			var keys:Array = getKeys();
			for each (var key:* in keys)
			{
				values.push( getValueAsByteArray(key) );
			}
			return values;
		}
		
		public function getEntriesAsByteArray():IList
		{
			var list:IList = new ArrayList();
			
			for each( var key:* in getKeys() )
			{
				list.add(new HashMapEntry(key, getValueAsByteArray(key)));
			}
			return list;
		}
		
	}
}