package ru.ganzin.apron2.data
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	dynamic public class ProxyArray extends Proxy
	{
		protected var list:Array;
		
		//-------------------------------------------------
		//	Constructor
		//-------------------------------------------------
		
		public function ProxyArray(...args)
		{
			initArray(args);
		}
		
		//-------------------------------------------------
		//	Properties
		//-------------------------------------------------

		public function get length() : uint
		{
			return list.length;
		}
		
		//-------------------------------------------------
		//	Medhods
		//-------------------------------------------------
		
		protected function initArray(args:Array):void
		{
			if (args.length == 0) list = new Array();
			if (args.length == 1) list = new Array(args[0]);
			else
			{
				list = new Array();
				push.apply(this,args);
			}			
		}
		
		public function push(...parameters) : uint
		{
			return list.push.apply(list, parameters);
		}

		public function reverse():Array
		{
			return list.reverse();
		}

		public function some(callback:Function, thisObject:* = null):Boolean
		{
			return list.some(callback, thisObject);
		}

		public function every(callback:Function, thisObject:* = null):Boolean
		{
			return list.every(callback, thisObject);
		}

		public function map(callback:Function, thisObject:* = null):Array
		{
			return list.map(callback, thisObject);
		}

		public function join(sep:* = null):String
		{
			return list.join(sep);
		}

		public function lastIndexOf(searchElement:*, fromIndex:* = 2147483647):int
		{
			return list.lastIndexOf(searchElement, fromIndex);
		}

		public function pop():*
		{
			return list.pop();
		}

		public function slice(A:* = 0, B:* = NaN):Array
		{
			return list.slice(A, B);
		}

		public function concat(... __rest):Array
		{
			return list.concat.apply(this, __rest);
		}

		public function forEach(callback:Function, thisObject:* = null):void
		{
			list.forEach(callback, thisObject);
		}

		public function splice(... __rest):*
		{
			return list.splice.apply(this, __rest);
		}

		public function sortOn(names:*, options:* = 0, ... __rest):*
		{
			return list.sortOn.apply(list,[names, options].concat(__rest));
		}

		public function sort(... __rest):*
		{
			return list.sort.apply(list, __rest);
		}

		public function filter(callback:Function, thisObject:* = null):Array
		{
			return list.filter(callback, thisObject);
		}

		public function shift():*
		{
			return list.shift();
		}

		public function unshift(... __rest):uint
		{
			return list.unshift.apply(this, __rest);
		}

		public function indexOf(searchElement:*, fromIndex:* = 0):int
		{
			return list.indexOf(searchElement, fromIndex);
		}

		//-------------------------------------------------
		//	flash_proxy medhods
		//-------------------------------------------------
		
		override flash_proxy function callProperty(methodName:*, ... args):*
		{
			var res:*;
			var mn:String = methodName.toString();
			
			switch (mn)
			{
				default:
					res = list[mn].apply(list, args);
				break;
			}
			return res;
		}

		override flash_proxy function getProperty(name:*):*
		{
			return list[uint(name)];
		}

		override flash_proxy function setProperty(name:*, value:*):void
		{
			list[uint(name)] = value;
		}
		
		override flash_proxy function deleteProperty(name:*) : Boolean
		{
			var id:uint = uint(name);
			if (list.length > id)
			{
				delete list[id];
				return true;
			}
			
			return false;
		}		
	}
}