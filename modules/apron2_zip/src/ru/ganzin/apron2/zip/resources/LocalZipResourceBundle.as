package ru.ganzin.apron2.zip.resources
{
	import nochump.util.zip.ZipConstants;

	import ru.ganzin.apron2.apron_internal;
	import ru.ganzin.apron2.resources.LocalResourceBundle;
	import ru.ganzin.apron2.zip.utils.zip.ZipComposite;
	import ru.ganzin.apron2.zip.utils.zip.ZipEvent;
	import ru.ganzin.apron2.zip.utils.zip.ZipProxy;

	use namespace apron_internal;

	public class LocalZipResourceBundle extends LocalResourceBundle
	{
		public function LocalZipResourceBundle(locale:String, bundleName:String, method:int = ZipConstants.STORED, autoFlush:Boolean = false, reserveSize:int = 0)
		{
			super(locale, bundleName, autoFlush, reserveSize);

			zip = new ZipComposite();

			try
			{
				if (_content["zip_data"]) zip.bytes = _content["zip_data"];
			}
			catch(e:Error)
			{
				trace(e);
				clear();
			}

			zip.addEventListener(ZipEvent.UPDATED, updateZipHandler, false, 0, true);
			zip.method = method;
			zipProxy = new ZipProxy(zip);

		}

		//-------------------------------------------------
		//
		//	Overrided properties
		//
		//-------------------------------------------------
		apron_internal var zip:ZipComposite;
		apron_internal var zipProxy:ZipProxy;

		override public function get content():Object
		{
			return zipProxy;
		}

		override public function get size():int
		{
			return zip.size;
		}

		//--------------------------------------------------------------------------
		//
		//  Overrided methods
		//
		//--------------------------------------------------------------------------

		override public function clear():void
		{
			super.clear();
			zip.clear();
		}

		override public function flush():void
		{
			so.data["zip_data"] = zip.bytes;
			super.flush();
		}

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		private function updateZipHandler(event:ZipEvent):void
		{
			_content["zip_data"] = zip.bytes;
		}
	}
}
