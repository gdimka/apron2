package ru.ganzin.apron2.config.filters
{
	import flash.events.IEventDispatcher;

	import ru.ganzin.apron2.config.filters.vo.FilterResultVO;
	import ru.ganzin.apron2.executor.IExecutor;
	import ru.ganzin.apron2.executor.SequenceExecutor;
	import ru.ganzin.apron2.executor.tasks.EventTask;
	import ru.ganzin.apron2.executor.tasks.SimpleTask;
	import ru.ganzin.apron2.utils.Delegate;

	public class GroupFilter extends AbstractFilter
	{
		protected var resultDataContainer:* = new Array();

		public var itemFilter:IFilter;
		
		public function GroupFilter()
		{
		}
		
		//-------------------------------------------------
		//	Medhods
		//-------------------------------------------------
		
		override protected function processFilter():*
		{
			var executor:IExecutor = new SequenceExecutor();
			var df:Function;
			var node:XML;
			
			function filterComplentHandler(e:FilterEvent):void
			{
				addItemToResult(e.result);
				(e.target as IEventDispatcher).removeEventListener(e.type,arguments.callee);
			}
			
			if (itemFilter)
			{
				for each (node in data.*)
					if (itemFilter.canApply(node))
					{
						df = Delegate.create(filterComplentHandler);
						itemFilter.addEventListener(FilterEvent.COMPLETE, df);
						executor.addTask(new EventTask(Delegate.create(itemFilter,itemFilter.process,[node]),
														itemFilter,FilterEvent.COMPLETE));
					}
					
				executor.addTask(new SimpleTask(Delegate.create(complete,[resultDataContainer])));
				executor.run();
			}
			else
			{
				for each (node in data.*)
				{
					var result:* = groupItemProcessFilter(node);
					if (result == FILTER_DOES_NOT_PROCESSED) continue;
					else if (result == LISTENING_EVENT)
					{
						df = Delegate.create(filterComplentHandler);
						this.addEventListener(FilterEvent.COMPLETE, df);
						executor.addTask(new EventTask(null,this,FilterEvent.COMPLETE));
					}
					else 
					{
						addItemToResult(new FilterResultVO(node,result));
					}
				}
				
				executor.addTask(new SimpleTask(Delegate.create(complete,[resultDataContainer])));
				executor.run();
			}

			return null;
		}
		
		protected function groupItemProcessFilter(data:XML):*
		{
			return null
		}
		
		protected function addItemToResult(data:FilterResultVO):void
		{
			(resultDataContainer as Array).push(data.result);
		}
	}
}