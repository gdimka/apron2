package ru.ganzin.apron2.utils
{
	import org.as3commons.reflect.Type;

	public class ApplicationUtil
	{
		static public function getGlobalApplication():*
		{
			var type:Type = Type.forName("mx.core.FlexGlobals");
			if (type) return type.getField("topLevelApplication").getValue();
			else return Type.forName("mx.core.Application").getField("application").getValue();
		}
		
		static public function getFlashVars():Object
		{
			var app:* = getGlobalApplication();
			if (app) return app.parameters;
			return null;
		}
	}
}
