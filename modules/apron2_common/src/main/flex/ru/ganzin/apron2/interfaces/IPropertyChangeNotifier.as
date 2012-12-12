/**
 * Created by IntelliJ IDEA.
 * User: Dimka-Lenovo
 * Date: 23.06.12
 * Time: 13:07
 */
package ru.ganzin.apron2.interfaces
{
	import flash.events.IEventDispatcher;

	import ru.ganzin.apron2.utils.uid.IUid;

	public interface IPropertyChangeNotifier extends IEventDispatcher, IUid
	{
	}
}
