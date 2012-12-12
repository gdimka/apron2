package ru.ganzin.apron2.pools
{
	public interface IPoolEntryFactory
	{
		function newInstance():IPoolable;
	}
}