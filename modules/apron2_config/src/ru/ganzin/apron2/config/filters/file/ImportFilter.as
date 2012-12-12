package ru.ganzin.apron2.config.filters.file
{
	import flash.utils.Dictionary;

	import ru.ganzin.apron2.config.ConfigEvent;
	import ru.ganzin.apron2.config.ConfigLoader;
	import ru.ganzin.apron2.config.filters.AbstractFilter;
	import ru.ganzin.apron2.utils.StringUtil;
	import ru.ganzin.apron2.utils.URIUtil;

	public class ImportFilter extends AbstractFilter
	{
		private static var loaders:Dictionary = new Dictionary();
		
		public static function getImportConfigLoader(node:XML):ConfigLoader
		{
			if (node.name() != IMPORT_NODE) return null;
			var filePath:String = node.attribute(FILE_ATTRIBUTE)[0];
			var absFilePath:String = URIUtil.getRootFlexAbsoluteURI(filePath).toString();
			var cl:ConfigLoader = loaders[absFilePath];
			return cl;
		}
		
		public static const IMPORT_NODE:String = "import";
		public static const FILE_ATTRIBUTE:String = "file";
		public static const SKIP_FIRST_NODE_ATTRIBUTE:String = "skip-first-node";
		
		override public function canApply(data:XML):Boolean
		{
			if (data.name() == IMPORT_NODE) return true;
			else return false
		}
		
		override protected function processFilter():*
		{
			var filePath:String = data.attribute(FILE_ATTRIBUTE)[0];
			var skipFirstNode:String = data.attribute(SKIP_FIRST_NODE_ATTRIBUTE)[0];
			
			logger.info("Process Import filter. File "+filePath);
			
			var absFilePath:String = URIUtil.getRootFlexAbsoluteURI(filePath).toString();
			var cl:ConfigLoader = loader.clone();
			if (skipFirstNode && skipFirstNode.length>0) cl.skipFirstNode = StringUtil.toBoolean(skipFirstNode);
			cl.addEventListener(ConfigEvent.COMPLETE,completeHandler);
			cl.addEventListener(ConfigEvent.ERROR,completeHandler);
			cl.load(absFilePath+"?no-cache="+int(Math.random()*10000));
			
			loaders[absFilePath] = cl;
		}
		
		private function completeHandler(e:ConfigEvent):void
		{
			complete();
		}
	}
}