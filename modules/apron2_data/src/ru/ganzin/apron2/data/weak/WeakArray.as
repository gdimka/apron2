package ru.ganzin.apron2.data.weak
{
	import flash.utils.flash_proxy;

	import ru.ganzin.apron2.data.*;

	use namespace flash_proxy;
	
	dynamic public class WeakArray extends ProxyArray
	{
		private var autoDeleteNullValues:Boolean;
		
		public function WeakArray(autoDeleteNullValues:Boolean = false, ...args)
		{
			initArray(args);
			this.autoDeleteNullValues = autoDeleteNullValues;
		}
		
		override public function push(...parameters) : uint
		{
			if (autoDeleteNullValues) updateWeakLinks();
			
			var i:uint = 0;
			var len:uint = parameters.length;
			var curLen:uint = length;
			for (;i<len;i++) super.push(new WeakRef(parameters[i]));
			return length;
		}
		
		override public function indexOf(searchElement:*, fromIndex:*=0) : int
		{
			if (autoDeleteNullValues) updateWeakLinks();
			
			var i:uint = 0;
			var len:uint = length;
			for (;i<len;i++)
				if (searchElement == flash_proxy::getProperty(i))
					return i;
			
			return -1;
		}
		
		override public function shift() : *
		{
			if (autoDeleteNullValues) updateWeakLinks();
			
			var value:WeakRef = super.shift();
			if (value) return value.get();
			return null;
		}
		
		override public function unshift(...parameters) : uint
		{
			if (autoDeleteNullValues) updateWeakLinks();
			
			var i:int = parameters.length-1;
			for (;i>=0;i--) super.unshift(new WeakRef(parameters[i]));
			return length;
		}

		private var inUpdateWeakLinks:Boolean = false;
		
		private function updateWeakLinks():void
		{
			if (inUpdateWeakLinks) return;
			inUpdateWeakLinks = true;
			
			var i:uint = 0;
			var len:uint = length;
			
			for (;i<len;i++)
				if(flash_proxy::getProperty(i) == null)
				{
					super.splice(i,1);
					len--; i--;
				}
			
			inUpdateWeakLinks = false;
		}
		
		//-------------------------------------------------
		//	Overrided Medhods
		//-------------------------------------------------
		
		public function toString() : String
		{
			if (autoDeleteNullValues) updateWeakLinks();
			
			var i:uint = 0;
			var len:uint = length;
			var lastI:uint = len-1;
			var ret:String = "";
			for (;i<len;i++)
			{
				ret += flash_proxy::getProperty(i)
				if (i != lastI) ret += ",";
			}
			
			return ret;			
		}
		
		public function toArray():Array
		{
			if (autoDeleteNullValues) updateWeakLinks();
			
			var arr:Array = [];
			var i:uint = 0;
			var len:uint = length;
			for (;i<len;i++) arr.push(flash_proxy::getProperty(i));
			return arr;
		}

		override flash_proxy function getProperty(name:*):*
		{
			if (autoDeleteNullValues) updateWeakLinks();
			
			if (list[name]) return WeakRef(list[name]).get();
			return null;
		}
		
		override flash_proxy function setProperty(name:*, value:*):void
		{
			if (autoDeleteNullValues) updateWeakLinks();
			
			list[name] = new WeakRef(value);
		}
	}
}