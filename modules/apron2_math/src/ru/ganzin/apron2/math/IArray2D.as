/**
 * User: Dmitriy Ganzin
 * Date: 29.09.2010
 * Time: 13:11:42
 */
package ru.ganzin.apron2.math
{
	import flash.geom.Point;

	public interface IArray2D
	{
		function get size():Point;

		function setSize(newRows:int, newCols:int):void;

		function addRows(count:uint, value = undefined):void;

		function addColumns(count:uint, value = undefined):void;

		function hasIJ(i:uint, j:uint):Boolean;

		function getRows():uint;

		function getCols():uint;

		function getUpPoint(i:uint, j:uint):Point;

		function getDownPoint(i:uint, j:uint):Point;

		function getRightPoint(i:uint, j:uint):Point;

		function getLeftPoint(i:uint, j:uint):Point;

		function getUpLeftPoint(i:uint, j:uint):Point;

		function getUpRightPoint(i:uint, j:uint):Point;

		function getDownLeftPoint(i:uint, j:uint):Point;

		function getDownRightPoint(i:uint, j:uint):Point;

		function getUp(i:uint, j:uint):*;

		function getDown(i:uint, j:uint):*;

		function getRight(i:uint, j:uint):*;

		function getLeft(i:uint, j:uint):*;

		function getUpLeft(i:uint, j:uint):*;

		function getUpRight(i:uint, j:uint):*;

		function getDownLeft(i:uint, j:uint):*;

		function getDownRight(i:uint, j:uint):*;

		function fill(value:*):void;

		function getAdjacentTilesPoints(i:int, j:int):Array;

		function isAdjacentTile(point:Point, checkPnt:Point):Boolean;

		function getTilesPointOnRadius(i:int, j:int, radius:int):Array;

		function getAdjacentTilesPointsByTilesPoints(tiles:Array):Array;

		function getDirectionType(pointA:Point, pointB:Point):String;

		function getPointByDirection(i:uint, j:uint, direction:String):Point;
	}
}