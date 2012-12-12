package ru.ganzin.apron2.data.json
{
	import com.adobe.serialization.json.JSON;
	import com.adobe.serialization.json.JSONParseError;

	import ru.ganzin.apron2.SimpleClass;
	import ru.ganzin.apron2.data.IDataConverter;

	public class JSON2ObjectConverter extends SimpleClass implements IDataConverter
	{
		public function convert(data:*):*
		{
			var json:Object;
			
			try { json = com.adobe.serialization.json.JSON.decode(data); }
			catch(e:JSONParseError)
			{
				if (logger.errorEnabled)
				{
					logger.error("An error occurred during the parsing JSON data.");
					logger.error(e.message);
					logger.error(data);
				}

				throw new Error("An error occurred during the parsing JSON data");
			}
			
			return json;
		}
	}
}