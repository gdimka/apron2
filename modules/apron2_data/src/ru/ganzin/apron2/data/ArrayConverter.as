/**
 * User: Dmitriy Ganzin
 * Date: 23.11.10
 * Time: 22:27
 */
package ru.ganzin.apron2.data
{
	public class ArrayConverter implements IDataConverter
	{
		private var valueConverter:*;
		private var mapHelper:MappedDataContainer;

		public function ArrayConverter(valueConverter:* = null)
		{
			this.valueConverter = valueConverter;

			if (valueConverter)
			{
				mapHelper = new MappedDataContainer();
				mapHelper.mapKey("value", valueConverter);
			}
		}

		public function convert(data:*):*
		{
			var list:Array = [];
			if (data is Array)
			{
				var dc:IDataContainer;
				for each (var o:* in data)
				{
					if (mapHelper)
					{
						mapHelper.put("value", o);
						o = mapHelper.getValue("value");
					}

					list.push(o);
				}
			}

			return list;
		}
	}
}
