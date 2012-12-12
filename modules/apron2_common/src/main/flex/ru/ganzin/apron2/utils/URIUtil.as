package ru.ganzin.apron2.utils
{
	import com.adobe.net.URI;

	import org.as3commons.reflect.Type;

	public class URIUtil
	{
		static public function getAbsoluteURI(base:*, path:*):URI
		{
			var baseURI:URI = new URI();

			if (base is String) baseURI = new URI(base);
			else if (base is URI) baseURI.copyURI(base);
			else baseURI = new URI(base.toString());
			
			if (!baseURI.isValid()) return null;
			
			var pathURI:URI = new URI();

			if (path is String) pathURI = new URI(path);
			else if (path is URI) pathURI.copyURI(path);
			else return baseURI;
			
			if (!pathURI.isValid()) return baseURI;
			if (pathURI.isAbsolute()) return pathURI;

			baseURI.chdir(".");
			baseURI.chdir(pathURI.toString());

			return baseURI;
		}

		static public function getRootFlexAbsoluteURI(path:*):URI
		{
			return getAbsoluteURI(getRootFlexAppURI(),path);
		}

		static public function getCurrentFlexAbsoluteURI(path:*):URI
		{
			return getAbsoluteURI(getCurrentFlexAppURI(),path);
		}

		static public function getRootFlexAppURI():URI
		{
			return (new URI(Type.forName("mx.messaging.config.LoaderConfig").getField("url").getValue()));
		}

		static public function getCurrentFlexAppURI():URI
		{
			var app:* = ApplicationUtil.getGlobalApplication();
			if (!app) return null;
			var url:String = app.url;
			return new URI(url.split("/[[DYNAMIC]]/")[0]);
		}
		
		static public function isUri(value:*):Boolean
		{
			if (value is String && String(value).indexOf("\n") != -1)
				return false;
			
			var uri:URI = new URI(String(value));
			return uri.isValid();
		}
	}
}
