package ru.ganzin.apron2.pools.factory
{
	import ru.ganzin.apron2.pools.IPoolEntryFactory;
	import ru.ganzin.apron2.pools.IPoolable;

	public class ClassPollEntryFactory implements IPoolEntryFactory
	{
		private var _clazz:Class;

		public function ClassPollEntryFactory(clazz:Class)
		{
			_clazz = clazz;
		}

		public function get clazz():Class
		{
			return _clazz;
		}

		public function newInstance():IPoolable
		{
			return new _clazz();
		}
	}
}