package ru.ganzin.apron2.data.codec
{
	import com.adobe.serialization.json.JSON;
	import com.adobe.serialization.json.JSONParseError;

	import ru.ganzin.apron2.SimpleClass;

	public class JSONCodec extends SimpleClass implements ICodec
	{
		public function encode(data:*):*
		{
			return com.adobe.serialization.json.JSON.encode(data);
		}

		public function decode(data:*):*
		{
			var json:Object;
			
			try { json = com.adobe.serialization.json.JSON.decode(data); }
			catch(e:JSONParseError)
			{
				logger.error("An error occurred during the parsing JSON data.");
				logger.error(e.message);
				logger.error(data);
				throw new Error("An error occurred during the parsing JSON data");
			}
			
			return json;
		}

	}
}