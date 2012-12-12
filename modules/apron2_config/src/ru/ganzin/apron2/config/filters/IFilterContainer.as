package ru.ganzin.apron2.config.filters
{
	public interface IFilterContainer
	{
		function addFilter(filter:IFilter):void
		function removeFilter(filter:IFilter):Boolean;
	}
}