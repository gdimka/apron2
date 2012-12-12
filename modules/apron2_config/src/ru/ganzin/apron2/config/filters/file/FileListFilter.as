package ru.ganzin.apron2.config.filters.file
{
	import flash.events.ErrorEvent;
	import flash.events.Event;

	import ru.ganzin.apron2.config.filters.AbstractFilter;
	import ru.ganzin.apron2.net.loaders.IndexLoader;

	public class FileListFilter extends AbstractFilter
	{
		private var type:String;
		private var fileMask:String;
		
		override public function canApply(data:XML):Boolean
		{
			if (data.name() == "list") return true;
			else return false;
		}
		
		override protected function processFilter():*
		{
			type = data.@type;
			fileMask = data.attribute("file-mask")[0];
			
			var parent:XML = data.parent();
			
//			switch(type)
//			{
//				case "folder":
//					
//					var il:IndexLoader = new IndexLoader();
//					il.url = URIUtil.getAbsoluteURI(baseUrl,data.@url.toString()).toString();
//					il.addEventListener(Event.COMPLETE, onIndexLoaderComplete);
//					il.addEventListener(ErrorEvent.ERROR, onIndexLoaderError);
//					il.load();
//
//					logger.debug("Loading folder '{0}'",il.url);
//				
//				break;
//			}

			return null;
		}

		
		private function onIndexLoaderComplete(e:Event):void
		{
			var files:Array = new Array();
			var il:IndexLoader = e.target as IndexLoader;
			var match:RegExp;
			var matched:Boolean = true;
			if (fileMask) match = new RegExp(fileMask,"i");
			
			for each (var name:String in il.items)
				if (!match || (match && match.test(name)))
					files.push(name);
			
			logger.debug("Completed loading folder '{0}'", [il.url]);
			
			complete(files);
		}
		
		private function onIndexLoaderError(e:ErrorEvent):void
		{
			complete();
		}	
	}
}