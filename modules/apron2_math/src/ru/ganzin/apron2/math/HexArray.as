package ru.ganzin.apron2.math
{
	import flash.geom.Point;
	import flash.utils.Dictionary;

	import ru.ganzin.apron2.errors.UnsupportedOperationException;

	dynamic public class HexArray extends Array2D
	{
		private var _horizontal:Boolean;

		public function HexArray(nRows:int, nCols:int, isHorizontal:Boolean = true, defaultValue:* = null, isVirtual:Boolean = false)
		{
			super(nRows, nCols, defaultValue, isVirtual);

			_horizontal = isHorizontal;
			_virtual = isVirtual;
		}

		override public function clone():Array2D
		{
			var value:HexArray = new HexArray(0, 0, _horizontal, undefined, _virtual);
			value.rows = rows;
			value.cols = cols;
			
			var arr:Array;
			for (var i:int = 0; i < this.length; i++)
			{
				arr = this[i];
				value[i] = arr.concat();
			}
			return value;
		}

		public function get isHorizontal():Boolean
		{
			return _horizontal;
		}

		override public function getUp(i:uint, j:uint):*
		{
			if (_virtual) virtualArrayException();
			if (!_horizontal)
			{
				if (!hasIJ(i - 1, j)) return null;
				return this[i - 1][j];
			}
			else unsupportedOperationException();

			return null;
		}

		override public function getDown(i:uint, j:uint):*
		{
			if (_virtual) virtualArrayException();
			if (!_horizontal)
			{
				if (!hasIJ(i + 1, j)) return null;
				return this[i + 1][j];
			}
			else unsupportedOperationException();

			return null;
		}

		override public function getRight(i:uint, j:uint):*
		{
			if (_virtual) virtualArrayException();
			if (_horizontal)
			{
				if (!hasIJ(i, j + 1)) return null;
				return this[i][j + 1];
			}
			else unsupportedOperationException();

			return null;
		}

		override public function getLeft(i:uint, j:uint):*
		{
			if (_virtual) virtualArrayException();
			if (_horizontal)
			{
				if (!hasIJ(i, j - 1)) return null;
				return this[i][j - 1];
			}
			else unsupportedOperationException();

			return null;
		}

		override public function getUpLeft(i:uint, j:uint):*
		{
			if (_virtual) virtualArrayException();
			var pnt:Point = getUpLeftPoint(i, j);
			i = pnt.x;
			j = pnt.y;

			if (!hasIJ(i, j)) return null;
			return this[i][j];
		}

		override public function getUpRight(i:uint, j:uint):*
		{
			if (_virtual) virtualArrayException();
			var pnt:Point = getUpRightPoint(i, j);
			i = pnt.x;
			j = pnt.y;

			if (!hasIJ(i, j)) return null;
			return this[i][j];
		}

		override public function getDownLeft(i:uint, j:uint):*
		{
			if (_virtual) virtualArrayException();
			var pnt:Point = getDownLeftPoint(i, j);
			i = pnt.x;
			j = pnt.y;

			if (!hasIJ(i, j)) return null;
			return this[i][j];
		}

		override public function getDownRight(i:uint, j:uint):*
		{
			if (_virtual) virtualArrayException();
			var pnt:Point = getDownRightPoint(i, j);
			i = pnt.x;
			j = pnt.y;

			if (!hasIJ(i, j)) return null;
			return this[i][j];
		}

		/*******************************************************************************************************/
		override public function getUpPoint(i:uint, j:uint):Point
		{
			if (!_horizontal) return new Point(i - 1, j);
			else unsupportedOperationException();
			return null;
		}

		override public function getDownPoint(i:uint, j:uint):Point
		{
			if (!_horizontal) return new Point(i + 1, j);
			else unsupportedOperationException();
			return null;
		}

		override public function getRightPoint(i:uint, j:uint):Point
		{
			if (_horizontal)  return new Point(i, j + 1);
			else unsupportedOperationException();
			return null;
		}

		override public function getLeftPoint(i:uint, j:uint):Point
		{
			if (_horizontal)  return new Point(i, j - 1);
			else unsupportedOperationException();
			return null;
		}

		override public function getUpLeftPoint(i:uint, j:uint):Point
		{
			if (_horizontal)
			{
				if (i % 2 == 0) return new Point(i - 1, j - 1);
				else return new Point(i - 1, j);
			}
			else
			{
				if (j % 2 == 0) return new Point(i - 1, j - 1);
				else return new Point(i, j - 1);
			}
		}

		override public function getUpRightPoint(i:uint, j:uint):Point
		{
			if (_horizontal)
			{
				if (i % 2 == 0) return new Point(i - 1, j);
				else return new Point(i - 1, j + 1);
			}
			else
			{
				if (j % 2 == 0) return new Point(i - 1, j + 1);
				else return new Point(i, j + 1);
			}
		}

		override public function getDownLeftPoint(i:uint, j:uint):Point
		{
			if (_horizontal)
			{
				if (i % 2 == 0) return new Point(i + 1, j - 1);
				else return new Point(i + 1, j);
			}
			else
			{
				if (j % 2 == 0) return new Point(i, j - 1);
				else return new Point(i + 1, j - 1);
			}
		}

		override public function getDownRightPoint(i:uint, j:uint):Point
		{
			if (_horizontal)
			{
				if (i % 2 == 0) return new Point(i + 1, j);
				else return new Point(i + 1, j + 1);
			}
			else
			{
				if (j % 2 == 0) return new Point(i, j + 1);
				else return new Point(i + 1, j + 1);
			}
		}

		/*******************************************************************************************************/
		override public function getAdjacentTilesPoints(i:int, j:int):Array
		{
			var tmpPoints:Array = [];
			if (_horizontal) tmpPoints.push(getLeftPoint(i, j), getRightPoint(i, j));
			else tmpPoints.push(getUpPoint(i, j), getDownPoint(i, j));

			tmpPoints.push(getUpLeftPoint(i, j), getUpRightPoint(i, j), getDownLeftPoint(i, j), getDownRightPoint(i, j));

			var tiles:Array = new Array();
			var pt:Point;
			for (var k:int = 0; k < tmpPoints.length; k++)
			{
				pt = tmpPoints[k];
				if (hasIJ(pt.x, pt.y)) tiles.push(pt);
			}

			return tiles;
		}

		override public function isAdjacentTile(point:Point, checkPnt:Point):Boolean
		{
			var tiles:Array = getAdjacentTilesPoints(point.x, point.y);
			for (var i:int = 0; i < tiles.length; i++)
				if (Point(tiles[i]).equals(checkPnt)) return true;
			return false;
		}

		private function unsupportedOperationException():void
		{
			if (_horizontal) throw new UnsupportedOperationException("Эта операция не поддерживается горизонтальным массивом");
			else throw new UnsupportedOperationException("Эта операция не поддерживается вертикальным массивом");
		}
	}
}
