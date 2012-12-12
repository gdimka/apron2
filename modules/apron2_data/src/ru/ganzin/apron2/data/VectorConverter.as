/**
 * User: Dmitriy Ganzin
 * Date: 23.11.10
 * Time: 22:27
 */
package ru.ganzin.apron2.data
{
	import org.as3commons.lang.ClassUtils;

	import ru.ganzin.apron2.utils.StringUtil;

	public class VectorConverter implements IDataConverter
	{
		private var _itemType:Class;
		private var _vectorClass:Class;

		public function VectorConverter(vectorClass:*, itemType:*)
		{
			_vectorClass = vectorClass;
			_itemType = itemType;

			if (!ClassUtils.isImplementationOf(itemType, IDataContainer))
				throw new Error(StringUtil.substitute("Класс {0} должен наследоваться от IDataContainer", ClassUtils.getFullyQualifiedName(itemType)));
		}

		public function convert(data:*):*
		{
			var vector:* = new _vectorClass();
			var dc:IDataContainer;

			for each (var o:* in data)
			{
				dc = new _itemType();
				dc.setData(o);
				vector.push(dc);
			}

			return vector;
		}
	}
}
