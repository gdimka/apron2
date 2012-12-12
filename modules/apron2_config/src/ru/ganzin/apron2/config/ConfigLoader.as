package ru.ganzin.apron2.config
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;

	import ru.ganzin.apron2.SimpleClass;
	import ru.ganzin.apron2.config.filters.FilterEvent;
	import ru.ganzin.apron2.config.filters.IFilter;
	import ru.ganzin.apron2.config.filters.SequenceFilter;
	import ru.ganzin.apron2.config.filters.file.ImportFilter;
	import ru.ganzin.apron2.executor.SequenceExecutor;
	import ru.ganzin.apron2.executor.events.ExecutorEvent;
	import ru.ganzin.apron2.executor.tasks.DelayTask;
	import ru.ganzin.apron2.executor.tasks.EventTask;
	import ru.ganzin.apron2.net.FileDataFormat;
	import ru.ganzin.apron2.net.loaders.CompositeLoader;
	import ru.ganzin.apron2.utils.Delegate;

	public class ConfigLoader extends SimpleClass
	{
		private var loader:CompositeLoader;
		protected var filters:Array = new Array();
		private var data:XML;

		//-------------------------------------------------
		//	Constructor
		//-------------------------------------------------

		public function ConfigLoader()
		{
			loader = new CompositeLoader();
			loader.type = FileDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, resultEventHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, faultEventHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, faultEventHandler);

			addFilter(new ImportFilter());
			addFilter(new SequenceFilter());
		}

		//-------------------------------------------------
		//	Properties
		//-------------------------------------------------

		public function get url():String
		{
			return loader.url;
		}

		public function set url(value:String):void
		{
			loader.url = value;
		}

		private var _skipFirstNode:Boolean = true;
		public function get skipFirstNode():Boolean
		{
			return _skipFirstNode;
		}

		public function set skipFirstNode(value:Boolean):void
		{
			_skipFirstNode = value;
		}

		//-------------------------------------------------
		//	Public Medhods
		//-------------------------------------------------

		public function clone():ConfigLoader
		{
			var cl:ConfigLoader = new ConfigLoader();
			cl.skipFirstNode = skipFirstNode;
			cl.filters = filters;
			return cl;
		}

		public function addFilter(filter:IFilter):void
		{
			filters.push(filter);
		}

		public function removeFilter(filter:IFilter):Boolean
		{
			var id:int = filters.indexOf(filter);
			if (id == -1) return false;
			else filters.splice(id, 0);

			return true;
		}

		public function load(url:String = null):void
		{
			if (url) this.url = url;
			loader.load();
		}

		public function loadByXML(xml:XML):void
		{
			data = xml;
			doFilters();
		}

		public function doFilter(filter:IFilter, now:Boolean = false):Boolean
		{
			var result:Boolean = false;
			var executor:SequenceExecutor = new SequenceExecutor();

			if (!now) executor.addTask(new DelayTask(100));

			function checkFilter(target:ConfigLoader, filter:IFilter, node:XML):void
			{
				if (filter.canApply(node))
				{
					filter.loader = ConfigLoader(target);
					executor.addTask(new EventTask(Delegate.create(filter, filter.process, [node]),
							filter, FilterEvent.COMPLETE));
					result = true;
				}
				else if (node.name() == ImportFilter.IMPORT_NODE)
				{
					var cl:ConfigLoader = ImportFilter.getImportConfigLoader(node);
					if (cl && cl.doFilter(filter))
						executor.addTask(new EventTask(null, cl, ConfigEvent.COMPLETE));
				}
			}

			if (skipFirstNode)
			{
				for each (var node:XML in data.children())
					checkFilter(this, filter, node);
			}
			else checkFilter(this, filter, data);

			if (result)
			{
				executor.addEventListener(ExecutorEvent.EXECUTE_COMPLETE, filteringCompleted);
				executor.run();
			}

			return result;
		}

		//-------------------------------------------------
		//	Other Medhods
		//-------------------------------------------------

		protected function doFilters():void
		{
			var executor:SequenceExecutor = new SequenceExecutor();

			function checkFilter(target:ConfigLoader, filter:IFilter, node:XML):void
			{
				if (filter.canApply(node))
				{
					filter.loader = target;
					executor.addTask(new EventTask(Delegate.create(filter, filter.process, [node]),
							filter, FilterEvent.COMPLETE));
				}
			}

			for each (var filter:IFilter in filters)
			{
				if (skipFirstNode)
				{
					for each (var node:XML in data.children())
						checkFilter(this, filter, node);
				}
				else checkFilter(this, filter, data);
			}

			executor.addEventListener(ExecutorEvent.EXECUTE_COMPLETE, filteringCompleted);
			executor.run();
		}

		private function filteringCompleted(e:Event):void
		{
			dispatchEvent(new ConfigEvent(ConfigEvent.COMPLETE));
		}

		protected function resultEventHandler(event:Event):void
		{
			loadByXML(XML(loader.data));
		}

		protected function faultEventHandler(event:ErrorEvent):void
		{
//			logger.error("ConfigController loading fault.");
//			logger.error(event.fault.faultString);
//			logger.error(event.fault.toString());
			dispatchEvent(new ConfigEvent(ConfigEvent.ERROR, new Error(event.text, event.errorID)));
		}
	}
}
