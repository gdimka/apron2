package ru.ganzin.apron2.pools.factory
{
	import ru.ganzin.apron2.interfaces.IFactory;
	import ru.ganzin.apron2.pools.IPoolEntryFactory;
	import ru.ganzin.apron2.pools.IPoolable;

	public class FactoryPollEntryFactory implements IPoolEntryFactory
	{
		private var _factory:IFactory;

		public function FactoryPollEntryFactory(factory:IFactory)
		{
			_factory = factory;
		}

		public function get factory():IFactory
		{
			return _factory;
		}

		public function newInstance():IPoolable
		{
			return _factory.newInstance();
		}
	}
}