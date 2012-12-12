package ru.ganzin.apron2.utils
{
	public class MathUtils
	{
		/*******************************************************************************************************/
		public static function getDegressByRadians(nRadians:Number):Number 
		{ 
			return nRadians / Math.PI * 180; 
		}
		/*******************************************************************************************************/
		public static function getRadiansByDegrees(nDegrees:Number):Number 
		{ 
			return Math.PI / 180 * nDegrees; 
		}
		/*******************************************************************************************************
		 * Функция возвращает заначение противолежащего угла прямоугольного треугольника
		 * где X - это длинна прилежащей стороны, а Y - это динна противолежащего катита.
		 * Угол возвращается в радианах.
		 * @return Угол в радианах
		 */
		public static function getRadians(nX1:Number,nX2:Number,nY1:Number,nY2:Number):Number 
		{
			var nXBase:Number = nX2 - nX1;
			var nYHeight:Number = nY2 - nY1;
			if (nXBase == 0) 
			{
				if (nYHeight > 0) return getRadiansByDegrees(90);
				return getRadiansByDegrees(270);
			}
			if (nYHeight == 0) 
			{
				if (nXBase > 0) return getRadiansByDegrees(180);
				return getRadiansByDegrees(0);
			}
			return getAngleOppositeRadians(nXBase, nYHeight); 
		}
		/*******************************************************************************************************/
		public static function getAngleAdjacentRadians(nBase:Number,nHeight:Number):Number 
		{
			// The return value represents the opposite angle of a right triangle in nRadians
			// where nX is the adjacent side length and nY is the opposite side length.
			return Math.atan2(nHeight, nBase); 
		}
		/*******************************************************************************************************/
		public static function getAngleOppositeRadians(nBase:Number,nHeight:Number):Number 
		{
			// The return value represents the opposite angle of a right triangle in nRadians
			// where nX is the adjacent side length and nY is the opposite side length.
			return Math.atan2(nBase, nHeight); 
		}
		/*******************************************************************************************************/
		public static function max3ByNumber(a:Number, b:Number, c:Number):Number
		{
			if( a > b ) 
			{
				if( a > c ) return(a);
        		else return(c);
			}
			else 
			{
				if( b > c ) return(b);
        		else return(c);
			}			
		}

		public static function max3ByArray(values:Array):Number
		{
			if( values[0] > values[1] ) 
			{
				if( values[0] > values[2] ) return(values[0]);
        		else return(values[2]);
			}
			else 
			{
				if( values[1] > values[2] ) return(values[1]);
        		else return(values[2]);
			}
		}

		public static function min3ByNumber(a:Number, b:Number, c:Number):Number
		{
			if( a < b )
			{
				if( a < c ) return(a);
        		else return(c);
			}
			else 
			{
				if( b < c ) return(b);
        		else return(c);
			}			
		}

		public static function min3ByArray(values:Array):Number
		{
			if( values[0] < values[1] ) 
			{
				if( values[0] < values[2] ) return(values[0]);
        		else return(values[2]);
			}
			else 
			{
				if( values[1] < values[2] ) return(values[1]);
        		else return(values[2]);
			}
		}	

		public static function max2ByNumber(a:Number, b:Number):Number
		{
			if( a > b ) return a;
			return b;
		}

		public static function max2ByArray(values:Array):Number
		{
			if( values[0] > values[1] ) return values[0];
			return values[1];
		}

		public static function min2ByNumber(a:Number, b:Number):Number
		{
			if( a < b ) return a;
			return b;
		}

		public static function min2ByArray(values:Array):Number
		{
			if( values[0] < values[1] ) return values[0];
			return values[1];
		}

		public static function round(value:Number,step:Number = 1):Number
		{
			return Math.round(value/step)*step
		}
		
		public static function floor(value:Number,step:Number = 1):Number
		{
			return Math.floor(value/step)*step
		}
		
		public static function ceil(value:Number,step:Number = 1):Number
		{
			return Math.ceil(value/step)*step;
		}
		
		static public function approximate(valueA:Number, valueB:Number, approxValue:Number):Boolean
		{
			valueA = Math.abs(valueA);
			valueB = Math.abs(valueB);
			approxValue = Math.abs(approxValue);
			
			if (valueA == valueB) return true;
			if (valueA+approxValue >= valueB && valueA-approxValue <= valueB) return true;
			return false;		
		}
		
		static public function range(min:Number,max:Number,value:Number):Number
		{
			return Math.max(Math.min(value,max),min);
		}
			
		static public function randomInt(min:int,max:int,step:int = 1):int
		{
			return random(min,max,step);
		}
		
		static public function getAllValue(min:Number,max:Number,step:Number = 1):Array
		{
			var values:Array = new Array();
			for (var i:Number=min;i<=max;i=i+step) values.push(i);
			return values;
		}
			
		public static function random(min:Number,max:Number,inc:Number = 1e-10):Number
		{
			return min + (Math.round(Math.random()*(max - min)/inc)* inc);
		}
		
		public static function getSign(value:Number):Number
		{
			if (value > 0) return 1;
			return -1;
		}		
	}
}
