/**
 * Created by IntelliJ IDEA.
 * User: Dimka-Lenovo
 * Date: 20.01.12
 * Time: 17:56
 */
package ru.ganzin.apron2.pools
{
	public interface IPool
	{
		function get factory():IPoolEntryFactory;

		function get freeCount():uint;

		function get totalSize():uint;

		function get growSize():uint;

		function alloc():IPoolable;

		function free(value:IPoolable):void;
	}
}
