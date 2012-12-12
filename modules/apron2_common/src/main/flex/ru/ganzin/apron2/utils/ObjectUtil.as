package ru.ganzin.apron2.utils
{
	import flash.utils.getQualifiedClassName;

	import org.as3commons.reflect.Method;
	import org.as3commons.reflect.Type;

	public class ObjectUtil
	{
		public static function isPrimitiveType(value:*):Boolean
		{
			var type:String = getQualifiedClassName(value);
			switch (type)
			{
				case "Boolean":
				case "void":
				case "int":
				case "uint":
				case "Number":
				case "String":
				case "undefined":
				case "null": return true;
				default: return false;
			}
		}

		public static function getFirstNotNull(...rest):*
		{
			for each (var v:* in rest)
				if (v != null) return v;
			return null;
		}

		public static function getFirstNotValue(...rest):*
		{
			var value:* = rest[rest.length - 1];
			for each (var v:* in rest)
				if (v != value) return v;
			return null;
		}

		public static function equals(a:Object, b:Object, depth:int = -1):Boolean
		{
			var type:Type = Type.forName("mx.utils.ObjectUtil");
			if (type)
			{
				var method:Method = type.getMethod("compare");
				if (method && method.isStatic) return method.invoke(type.clazz, [a, b, depth]) == 0;
			}

			return a === b;
		}

		public static function addCharsBeforeNames(value:Object, chars:String = ""):void
		{
			for (var name:String in value)
			{
				value[chars + name] = value[name];
				delete value[name];
			}
		}

		public static function addCharsAfterNames(value:Object, chars:String = ""):void
		{
			for (var name:String in value)
			{
				value[name + chars] = value[name];
				delete value[name];
			}
		}
	}
}