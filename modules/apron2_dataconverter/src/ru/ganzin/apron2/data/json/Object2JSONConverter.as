package ru.ganzin.apron2.data.json
{
	import com.adobe.serialization.json.JSON;

	import ru.ganzin.apron2.SimpleClass;
	import ru.ganzin.apron2.data.IDataConverter;

	public class Object2JSONConverter extends SimpleClass implements IDataConverter
	{
		public function convert(data:*):*
		{
			return com.adobe.serialization.json.JSON.encode(data);
		}
	}
}