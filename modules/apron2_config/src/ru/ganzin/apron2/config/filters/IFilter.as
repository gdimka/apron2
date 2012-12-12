package ru.ganzin.apron2.config.filters
{
	import flash.events.IEventDispatcher;

	import ru.ganzin.apron2.config.ConfigLoader;

	public interface IFilter extends IEventDispatcher
	{
		function get loader():ConfigLoader;
		function set loader(value:ConfigLoader):void;
		
		function canApply(data:XML):Boolean;
		function process(data:XML):void;
	}
}