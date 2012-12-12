package ru.ganzin.apron2.config.filters.vo
{
	public class FilterResultVO
	{
		public var node:XML
		public var result:*;

		public function FilterResultVO(node:XML, result:*)
		{
			this.node = node;
			this.result = result;
		}
	}
}