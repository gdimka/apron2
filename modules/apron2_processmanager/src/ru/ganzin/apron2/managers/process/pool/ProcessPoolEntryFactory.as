package ru.ganzin.apron2.managers.process.pool
{
	import ru.ganzin.apron2.pools.factory.ClassPollEntryFactory;

	public class ProcessPoolEntryFactory extends ClassPollEntryFactory
	{
		public function ProcessPoolEntryFactory(clazz:Class = null)
		{
			super((clazz)?clazz:PoolableProcess);
		}
	}
}