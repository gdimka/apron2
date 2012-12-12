/**
 * Created by IntelliJ IDEA.
 * User: Dmitriy Ganzin
 * Date: 20.06.12
 * Time: 16:21
 */
package ru.ganzin.apron2.pools.factory {
	import flash.utils.Dictionary;

	import ru.ganzin.apron2.pools.IPoolEntryFactory;
	import ru.ganzin.apron2.pools.IPoolable;
	import ru.ganzin.apron2.pools.entry.SpritePoolEntry;

	public class SpritePoolFactory implements IPoolEntryFactory {

		private var clazz : Class;
		private var params : Object;

		public function SpritePoolFactory(clazz : Class, params : Object = null) {
			this.clazz = clazz;
			this.params = params;
		}

		public function getEntryBySprite(sprite : *) : SpritePoolEntry {
			return itemBySprite[sprite];
		}

		private var itemBySprite : Dictionary = new Dictionary();

		public function newInstance() : IPoolable {
			const sprite : * = new clazz();

			if (params)
				for (var key : * in params)
					sprite[key] = params[key];

			const item : SpritePoolEntry = new SpritePoolEntry(sprite);
			itemBySprite[sprite] = item;

			return item;
		}
	}
}
