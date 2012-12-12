package ru.ganzin.apron2.math
{
	import flash.geom.Point;
	import flash.utils.Dictionary;

	import ru.ganzin.apron2.errors.UnsupportedOperationException;
	import ru.ganzin.apron2.interfaces.IFactory;

	dynamic public class Array2D extends Array implements IArray2D
	{
		protected var rows:int = 0;
		protected var cols:int = 0;
		protected var _defaultValue:*;
		protected var _virtual:Boolean;
		protected var _swapCoords:Boolean;

		/*******************************************************************************************************/
		function Array2D(rows:int, cols:int, defaultValue:* = undefined, isVirtual:Boolean = false)
		{
			_defaultValue = defaultValue;
			_virtual = isVirtual;
			setSize(rows, cols);
		}

		private function makeValue(i:uint, j:uint, value:*):*
		{
			if (value is Function) return value(i, j);
			else if (value is IFactory) return IFactory(value).newInstance();
			else return value;
		}

		public function clone():Array2D
		{
			var value:Array2D = new Array2D(0, 0, undefined, _virtual);
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

		public function get size():Point
		{
			return new Point(rows, cols);
		}

		public function setSize(newRows:int, newCols:int):void
		{
			if (_virtual)
			{
				rows = newRows;
				cols = newCols;
			}
			else
			{
				if (newRows != rows)
				{
					if (newRows < rows) this.splice(newRows - rows);
					else addRows(newRows - rows, _defaultValue);

					rows = newRows;
				}

				if (newCols != cols)
				{
					if (newCols < cols)
					{
						var arr:Array;
						for (var i:int = 0; i < rows; i++)
						{
							arr = this[i];
							arr.splice(newCols - cols);
						}
					}
					else addColumns(newCols - cols, _defaultValue);

					cols = newCols;
				}
			}
		}

		public function addRows(count:uint, value = undefined):void
		{
			if (_virtual) rows += count;
			else
			{
				if (value === undefined) value = _defaultValue;

				var arr:Array;
				for (var i:int = 0; i < count; i++)
				{
					arr = this[this.push(new Array(cols)) - 1];
					rows++;

					if (!(_defaultValue === undefined))
					{
						for (var j:int = 0; j < cols; j++)
						{
							arr[j] = makeValue(i, j, value);
						}
					}
				}
			}
		}

		public function addColumns(count:uint, value = undefined):void
		{
			cols += count;
			if (_virtual) return;
			if (value === undefined) value = _defaultValue;

			var arr:Array;
			for (var i:int = 0; i < rows; i++)
			{
				if (value === undefined)
				{
					this[i] = (this[i] as Array).concat(new Array(count));
				}
				else
				{
					for (var j:int = 0; j < count; j++)
					{
						arr = this[i];
						arr.push(makeValue(i, j, value));
					}
				}
			}
		}

		public function hasIJ(i:uint, j:uint):Boolean
		{
			return i < rows && j < cols && i >= 0 && j >= 0;
		}

		public function getRows():uint
		{
			return rows;
		}

		public function getCols():uint
		{
			return cols;
		}

		public function getUpPoint(i:uint, j:uint):Point
		{
			return new Point(i, j - 1);
		}

		public function getDownPoint(i:uint, j:uint):Point
		{
			return new Point(i, j + 1);
		}

		public function getRightPoint(i:uint, j:uint):Point
		{
			return new Point(i + 1, j);
		}

		public function getLeftPoint(i:uint, j:uint):Point
		{
			return new Point(i - 1, j);
		}

		public function getUpLeftPoint(i:uint, j:uint):Point
		{
			return new Point(i - 1, j - 1);
		}

		public function getUpRightPoint(i:uint, j:uint):Point
		{
			return new Point(i + 1, j - 1);
		}

		public function getDownLeftPoint(i:uint, j:uint):Point
		{
			return new Point(i - 1, j + 1);
		}

		public function getDownRightPoint(i:uint, j:uint):Point
		{
			return new Point(i + 1, j + 1);
		}

		public function getUp(i:uint, j:uint):*
		{
			if (_virtual) virtualArrayException();
			if (!hasIJ(i, j - 1)) return null;
			return this[i][j - 1];
		}

		public function getDown(i:uint, j:uint):*
		{
			if (_virtual) virtualArrayException();
			if (!hasIJ(i, j + 1)) return null;
			return this[i][j + 1];
		}

		public function getRight(i:uint, j:uint):*
		{
			if (_virtual) virtualArrayException();
			if (!hasIJ(i + 1, j)) return null;
			return this[i + 1][j];
		}

		public function getLeft(i:uint, j:uint):*
		{
			if (_virtual) virtualArrayException();
			if (!hasIJ(i - 1, j)) return null;
			return this[i - 1][j];
		}

		public function getUpLeft(i:uint, j:uint):*
		{
			if (_virtual) virtualArrayException();
			if (!hasIJ(i - 1, j - 1)) return null;
			return this[i - 1][j - 1];
		}

		public function getUpRight(i:uint, j:uint):*
		{
			if (_virtual) virtualArrayException();
			if (!hasIJ(i + 1, j - 1)) return null;
			return this[i + 1][j - 1];
		}

		public function getDownLeft(i:uint, j:uint):*
		{
			if (_virtual) virtualArrayException();
			if (!hasIJ(i - 1, j + 1)) return null;
			return this[i - 1][j + 1];
		}

		public function getDownRight(i:uint, j:uint):*
		{
			if (_virtual) virtualArrayException();
			if (!hasIJ(i + 1, j + 1)) return null;
			return this[i + 1][j + 1];
		}

		public function fill(value:*):void
		{
			for (var i:int = 0; i < rows; i++)
			{
				this[i] = new Array(cols);
				for (var j:int = 0; j < cols; j++)
					this[i][j] = value;
			}
		}

		public function getAdjacentTilesPoints(i:int, j:int):Array
		{
			var up:Point = getUpPoint(i, j);
			var down:Point = getDownPoint(i, j);
			var left:Point = getLeftPoint(i, j);
			var right:Point = getRightPoint(i, j);
			var upLeft:Point = getUpLeftPoint(i, j);
			var upRight:Point = getUpRightPoint(i, j);
			var downLeft:Point = getDownLeftPoint(i, j);
			var downRight:Point = getDownRightPoint(i, j);

			var tiles:Array = new Array();
			var tmpPoints:Array = [up, down, left, right, upLeft, upRight, downLeft, downRight];
			for each (var p:Point in tmpPoints)
				if (hasIJ(p.x, p.y)) tiles.push(p);

			return tiles;
		}

		public function isAdjacentTile(point:Point, checkPnt:Point):Boolean
		{
			var tiles:Array = getAdjacentTilesPoints(point.x, point.y);
			for each (var p:Point in tiles)
				if (p.equals(checkPnt)) return true;
			return false;
		}

		public function getTilesPointOnRadius(i:int, j:int, radius:int):Array
		{
			var tiles:Array = [new Point(i, j)];
			var adjTiles:Array = tiles;
			while (radius--)
			{
				adjTiles = sliceTilesArray(getAdjacentTilesPointsByTilesPoints(adjTiles), tiles);
				tiles = mergeUniqueTilesArray(tiles, adjTiles);
			}

			return tiles;
		}

		public function getAdjacentTilesPointsByTilesPoints(tiles:Array):Array
		{
			var adjTiles:Array = [];
			var tile:Point;
			var adjTilesT:Array;
			for (var i:int = 0; i < tiles.length; i++)
			{
				tile = tiles[i];
				adjTilesT = getAdjacentTilesPoints(tile.x, tile.y);
				adjTiles = mergeUniqueTilesArray(adjTiles, adjTilesT);
			}

			return adjTiles;
		}

		public function getDirectionType(pointA:Point, pointB:Point):String
		{
			if (pointA.equals(pointB)) return null;

			var point:Point = pointB.subtract(pointA);
			var normPoint = new Point(int(point.x / Math.abs(point.x)), int(point.y / Math.abs(point.y)));
			var checkPoint:Point = pointA.add(normPoint);

			var i:int = pointA.x;
			var j:int = pointA.y;

			try
			{
				if (getUpPoint(i, j).equals(checkPoint)) return DirectionType.UP;
			}
			catch(e:Error)
			{
			}
			try
			{
				if (getRightPoint(i, j).equals(checkPoint)) return DirectionType.RIGHT;
			}
			catch(e:Error)
			{
			}
			try
			{
				if (getDownPoint(i, j).equals(checkPoint)) return DirectionType.DOWN;
			}
			catch(e:Error)
			{
			}
			try
			{
				if (getLeftPoint(i, j).equals(checkPoint)) return DirectionType.LEFT;
			}
			catch(e:Error)
			{
			}
			try
			{
				if (getUpLeftPoint(i, j).equals(checkPoint)) return DirectionType.UP_LEFT;
			}
			catch(e:Error)
			{
			}
			try
			{
				if (getUpRightPoint(i, j).equals(checkPoint)) return DirectionType.UP_RIGHT;
			}
			catch(e:Error)
			{
			}
			try
			{
				if (getDownRightPoint(i, j).equals(checkPoint)) return DirectionType.DONW_RIGHT;
			}
			catch(e:Error)
			{
			}
			try
			{
				if (getDownLeftPoint(i, j).equals(checkPoint)) return DirectionType.DONW_LEFT;
			}
			catch(e:Error)
			{
			}

			return null;

//			var direction:String;
//			if (point.x == 0)
//			{
//				if (point.y > 0) return DirectionType.LEFT;
//				return DirectionType.RIGHT;
//			}
//			else if (point.y == 0)
//			{
//				if (point.x > 0) return DirectionType.DOWN;
//				return DirectionType.UP;
//			}
//			else
//			{
//				if (point.x > 0)
//				{
//					if (point.y > 0) return DirectionType.DONW_LEFT;
//					else return DirectionType.DONW_RIGHT;
//				}
//				else
//				{
//					if (point.y > 0) return DirectionType.UP_LEFT;
//					else return DirectionType.UP_RIGHT;
//				}
//			}
		}

		public function getPointByDirection(i:uint, j:uint, direction:String):Point
		{
			with (DirectionType)
				switch (direction)
				{
					case UP: return getUpPoint(i, j); break;
					case RIGHT: return getRightPoint(i, j); break;
					case DOWN: return getDownPoint(i, j); break;
					case LEFT: return getLeftPoint(i, j); break;
					case UP_RIGHT: return getUpRightPoint(i, j); break;
					case UP_LEFT: return getUpLeftPoint(i, j); break;
					case DONW_RIGHT: return getDownRightPoint(i, j); break;
					case DONW_LEFT: return getDownLeftPoint(i, j); break;
				}

			return null;
		}

		/*******************************************************************************************************/
		public function toString():String
		{
			var ret:String = "";

			if (_virtual) ret += "(rows=" + rows + ", cols=" + cols + ", isVirtual=true)";
			else
			{
				for (var i:int = 0; i < rows; i++)
				{
					for (var j:int = 0; j < cols; j++) ret += ((j == 0) ? "" : ",") + this[i][j];
					ret += "\n";
				}
			}

			return ret;
		}

		/*******************************************************************************************************/
		protected function virtualArrayException():void
		{
			throw new UnsupportedOperationException("Виртуальный массив не поддерживает эту операцию.");
		}

		public static function mergeUniqueTilesArray(arr1:Array, arr2:Array):Array
		{
			if (arr1.length == 0) return arr2.concat();
			if (arr2.length == 0) return arr1.concat();

			var hash:Dictionary = new Dictionary();
			var arrRet:Array = new Array();

			var i:int;
			var value:Point;
			for (i = 0; i < arr1.length; i++)
			{
				value = arr1[i];
				hash[value.x + "_" + value.y] = value;
			}
			for (i = 0; i < arr2.length; i++)
			{
				value = arr2[i];
				hash[value.x + "_" + value.y] = value;
			}

			for each (var point:Point in hash) arrRet.push(point);

			return arrRet;
		}

		public static function sliceTilesArray(arr1:Array, arr2:Array):Array
		{
			if (arr1.length == 0) return [];
			if (arr2.length == 0) return arr1.concat();

			var hash:Dictionary = new Dictionary();
			var arrRet:Array = new Array();
			var i:int;
			var value:Point;
			var name:String;
			for (i = 0; i < arr1.length; i++)
			{
				value = arr1[i];
				hash[value.x + " " + value.y] = value;
			}
			for (i = 0; i < arr2.length; i++)
			{
				name = arr2[i].x + " " + arr2[i].y;
				if (hash[name] != null) delete hash[name];
			}

			for each (var point:Point in hash) arrRet.push(point);

			return arrRet;
		}

	}
}
