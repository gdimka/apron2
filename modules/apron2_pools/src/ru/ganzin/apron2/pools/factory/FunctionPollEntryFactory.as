package ru.ganzin.apron2.pools.factory
{
	import ru.ganzin.apron2.pools.IPoolEntryFactory;
	import ru.ganzin.apron2.pools.IPoolable;

	public class FunctionPollEntryFactory implements IPoolEntryFactory
	{
		private var _func:Function;

		public function FunctionPollEntryFactory(func:Function)
		{
			_func = func;
		}

		public function func():Function
		{
			return _func;
		}

		public function newInstance():IPoolable
		{
			return _func();
		}
	}
}