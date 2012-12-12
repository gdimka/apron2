package ru.ganzin.apron2.pools
{
	public class Pool implements IPool
	{
		protected var pool:Array = [];

		private var _factory:IPoolEntryFactory;
		private var _growSize:uint;

		private var _totalSize:uint;

		public function Pool(factory:IPoolEntryFactory, initCount:uint = 1, growSize:uint = 1)
		{
			_factory = factory;
			_growSize = growSize;

			for (var i:int = 0; i < initCount; i++)
				pool.push(factory.newInstance());

			_totalSize = initCount;
		}

		public function get factory():IPoolEntryFactory
		{
			return _factory;
		}

		public function get freeCount():uint
		{
			return pool.length;
		}

		public function get totalSize():uint
		{
			return _totalSize;
		}

		public function get growSize():uint
		{
			return _growSize;
		}

		public function alloc():IPoolable
		{
			if (pool.length == 0)
			{
				var i:uint = 0;
				while (growSize > i++) pool.push(factory.newInstance());
				_totalSize += growSize;
			}

			return pool.shift();
		}

		public function free(value:IPoolable):void
		{
			value.free();
			pool.push(value);
		}
	}
}