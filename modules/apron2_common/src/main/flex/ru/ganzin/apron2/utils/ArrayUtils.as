package ru.ganzin.apron2.utils
{
	public class ArrayUtils
	{
		static public function makeIntArray(start:int, end:int, interval:int):Array
		{
			if (interval <= 0) return [start,end];
			if (end <= start) return [];
			var arr:Array = [];
			while (start < end)
			{
				arr.push(start);
				start += interval;
			}
			arr.push(end);
			return arr;
		}

		static public function makeNumberArray(start:Number, end:Number, interval:Number):Array
		{
			if (end <= start) return [];
			var arr:Array = [];
			while (start < end)
			{
				arr.push(start);
				start += interval;
			}
			arr.push(end);
			return arr;
		}

		/**
		 * Создает массив длинны nSize и заполняет его переменной value
		 * @param nSize Длинна массива
		 * @param value Переменная, которой заполняется массив
		 * @return Массив длинны nSize, заполненный его переменной value
		 */
		static public function fillArray(nSize:Number, value:*):Array
		{
			var aRet:Array = new Array();
			for (var i:int = 0; i < nSize; i++) aRet.push(value);
			return aRet;
		}

		/**
		 * Возвращает случаный элемент массива aArray начиная с nSt элемента и заканчивая nEnd.
		 * @param aArray Массива данных
		 * @param nSt Начало списка элементов
		 * @param nEnd Конец списка элементов
		 * @return Случаный элемент массива
		 */
		static public function getRandomElement(arr:Array, start:int = 0, end:int = -1):*
		{
			if (end == -1) end = arr.length - 1;
			var aPart:Array = arr.slice(start, end + 1);
			if (aPart.length == 0) return null;
			return aPart[MathUtils.randomInt(start, end)];
		}

		/**************************************************************************************************************/
		//This method translate an nArray of numerical values into the specified format.
		//This method is used by other methods that have specific value requirements for Muber Arrays.
		public static function getActualNumbers(aValues:Array, nMinNumber:Number, nMaxNumber:Number):Array
		{
			var nSize:int = aValues.length;
			var nMinValue:Number = aValues[0];
			var nMaxValue:Number = aValues[nSize - 1];
			if (nMinValue == nMinNumber && nMaxValue == nMaxNumber) return aValues;

			var aActualValues:Array = new Array();
			var nValue:Number;

			for (var i:Number = 0; i < nSize; i++)
			{
				nValue = aValues[i] - nMinValue + nMinNumber;
				aActualValues.push((nValue / nMaxValue) * nMaxNumber);
			}
			return aActualValues;
		}

		/**
		 * Конвертирует все элементы массива aArray в числа и возвращает новый массив.
		 * @param aArray Массив элементов
		 * @return Новый массив, где все элементы типа Number.
		 */
		public static function allItemsToNumber(aArray:Array):Array
		{
			var aRet:Array = new Array();
			for (var i:int = 0; i < aArray.length; i++)
				aRet.push(Number(aArray[i]));
			return aRet;
		}

		public static function remove(aArray:Array, object:*, bAll:Boolean):Boolean
		{
			for (var i:int = 0; i < aArray.length; i++)
				if (aArray[i] === object)
				{
					aArray.splice(i--, 1);
					if (!bAll) return true;
				}
			return false;
		}

		/**************************************************************************************************************/
		public static function trim(aArray:Array):Array
		{
			return leftTrim(rightTrim(aArray));
		}

		/**************************************************************************************************************/
		public static function leftTrim(aArray:Array):Array
		{
			return leftTrimForValues(aArray, [null,undefined]);
		}

		/*******************************************************************************************************/
		public static function rightTrim(aArray:Array):Array
		{
			return rightTrimForValues(aArray, [null,undefined]);
		}

		/*******************************************************************************************************/
		public static function leftTrimForValues(aArray:Array, aValues:Array):Array
		{
			var aRet:Array = aArray.concat();
			for (var i:int = 0; i < aRet.length; i++)
			{
				for (var j:int = 0; j < aValues.length; j++)
				{
					if (aRet[i] == aValues[j]) aRet.splice(i, 1);
					else return aRet;
				}
				i--;
			}
			return aRet;
		}

		/*******************************************************************************************************/
		public static function rightTrimForValues(aArray:Array, aValues:Array):Array
		{
			var aRet:Array = aArray.concat();
			for (var i:int = aRet.length - 1; i >= 0; i--)
			{
				for (var j:int = 0; j < aValues.length; j++)
				{
					if (aRet[i] == aValues[j]) aRet.splice(i, 1);
					else return aRet;
				}
			}
			return aRet;
		}

		/**
		 * Объединяет массивы. Входящих аргументов может быть сколько угодно, но только массивы.
		 */
		public static function merge(...args):Array
		{
			var aRet:Array = new Array();
			for (var i:int = 0; i < args.length; i++)
				aRet = aRet.concat(args[i]);
			return aRet;
		}

		/**************************************************************************************************************/
		public static function equals(aA:Array, aB:Array):Boolean
		{
			if (aA == aB) return true;
			else if (aA.length != aB.length) return false;

			for (var i:int = 0; i < aA.length; i++)
				if (!ObjectUtil.equals(aA[i], aB[i])) return false;

			return true;
		}

		/**************************************************************************************************************/
		public static function isTypedPrimitiveArray(aArray:Array):Boolean
		{
			var sType:String = typeof(aArray[0]);
			for (var i:int = 1; i < aArray.length; i++)
			{
				if (aArray[i] is Object) return false;
				if (typeof(aArray[i]) != sType && aArray[i] != null) return false;
			}
			return true;
		}

		/**************************************************************************************************************/
		public static function matrixToString(aMatrix:Array, sRowSeparator:String, sColSeparator:String):String
		{
			var aRetMat:Array = new Array();
			for (var i:int = 0; i < aMatrix.length; i++)
				aRetMat.push(aMatrix[i].join(sColSeparator));
			return aRetMat.join(sRowSeparator);
		}

		/**************************************************************************************************************/
		public static function vectorToArray(v:*):Array
		{
			var arr:Array = [];
			for each(var i:Object in v)
				arr.push(i);
			return arr;
		}
		/**************************************************************************************************************/
	}
}