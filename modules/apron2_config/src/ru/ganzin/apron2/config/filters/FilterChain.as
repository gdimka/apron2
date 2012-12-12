package ru.ganzin.apron2.config.filters
{
	import ru.ganzin.apron2.config.filters.vo.FilterResultVO;
	import ru.ganzin.apron2.executor.SequenceExecutor;
	import ru.ganzin.apron2.executor.events.ExecutorEvent;
	import ru.ganzin.apron2.executor.tasks.EventTask;
	import ru.ganzin.apron2.utils.Delegate;

	public class FilterChain extends AbstractFilter
	{
		protected var filters:Array = new Array();
		protected var results:Array;
		
		public function FilterChain()
		{
		}
		
		//-------------------------------------------------
		//	Medhods
		//-------------------------------------------------
		
		public function addFilter(filter:IFilter):void
		{
			filters.push(filter);
		}
		
		public function removeFilter(filter:IFilter):Boolean
		{
			var id:int = filters.indexOf(filter);
			if (id == -1) return false;
			else filters.splice(id,0);
			
			return true;
		}
		
		//-------------------------------------------------
		//	Overrided Medhods
		//-------------------------------------------------
		override public function canApply(data:XML):Boolean
		{
			for each (var node:XML in data.children())
				for each(var f:IFilter in filters)
					if (f.canApply(data)) return true;
			
			return false;
		}
				
		override protected function processFilter():*
		{
			applyFilters(data);
			return null;
		}
		
		//-------------------------------------------------
		//	Protected Medhods
		//-------------------------------------------------
		
		protected function applyFilters(data:XML):void
		{
			logger.debug("applyFilters({0})",data.name().toString());
			
			results = new Array();
			var executor:SequenceExecutor = new SequenceExecutor();
			
			for each (var filter:IFilter in filters)
				for each (var node:XML in data.children())
				{
					if (filter.canApply(node))
					{
						filter.addEventListener(FilterEvent.COMPLETE, filterCompleteHandler);
						executor.addTask(new EventTask(Delegate.create(filter.process,[node]),
											filter, FilterEvent.COMPLETE));
					}
				}
			
			executor.addEventListener(ExecutorEvent.EXECUTE_COMPLETE, allFiltersCompleteHandler);
			executor.run();
		}
		
		protected function filterComplete(filter:IFilter, result:FilterResultVO):void
		{
			results.push(result.result);
		}
		
		protected function chainComplete(result:* = null):void
		{
			complete(result);
		}
		
		//-------------------------------------------------
		//	Events Medhods
		//-------------------------------------------------
		
		private function allFiltersCompleteHandler(event:ExecutorEvent):void
		{
			chainComplete(results);
		}
		
		private function filterCompleteHandler(event:FilterEvent):void
		{
			filterComplete(event.target as IFilter, event.result);
		}
	}
}