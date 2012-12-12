package ru.ganzin.apron2.utils
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.geom.Point;

	public class DisplayObjectUtils
	{
		public static function getParentObjectByType(displayObject:DisplayObject, type:Class):DisplayObject
		{
			var parent:DisplayObject = displayObject.parent;
			while (parent && !(parent is type))
				parent = parent.parent;

			return parent;
		}

		public static function getScaleBy(value:DisplayObject):Point
		{
			if (value.stage)
			{
				var scale:Point = new Point(value.scaleX, value.scaleY);
				var curParent:DisplayObject = value.parent;
				while (curParent && curParent != value.stage)
				{
					scale.x *= curParent.scaleX;
					scale.y *= curParent.scaleY;
					curParent = curParent.parent;
				}

				return scale;
			}
			else
			{
				var stage:Stage = ApplicationUtil.getGlobalApplication().stage;

				var oldR:Number = value.rotation;
				value.rotation = 0;

				var diff:uint = 100;
				var stagePointA:Point = new Point(100, 100);
				var stagePointB:Point = stagePointA.clone();
				stagePointB.offset(diff, diff);

				var doPointA:Point = stage.globalToLocal(value.localToGlobal(stagePointA));
				var doPointB:Point = stage.globalToLocal(value.localToGlobal(stagePointB));
				var subPoint:Point = doPointB.subtract(doPointA);

				value.rotation = oldR;

				return new Point(Math.abs(subPoint.x / diff), Math.abs(subPoint.y / diff));
			}
		}
	}
}
