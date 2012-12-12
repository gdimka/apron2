/**
 * Created by IntelliJ IDEA.
 * User: Dmitriy Ganzin
 * Date: 20.06.12
 * Time: 16:18
 */
package ru.ganzin.apron2.pools.entry {
	import flash.display.Sprite;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.natives.sets.InteractiveObjectSignalSet;

	import ru.ganzin.apron2.pools.IPoolable;

	public class SpritePoolEntry implements IPoolable {

		private var _sprite : Sprite;
		private var _signals : InteractiveObjectSignalSet;

		public function SpritePoolEntry(sprite : Sprite) {
			_sprite = sprite;
			_signals = new InteractiveObjectSignalSet(sprite);
		}

		public function get sprite() : Sprite {
			return _sprite;
		}

		public function get signals() : InteractiveObjectSignalSet {
			return _signals;
		}

		public function free() : void {
			for each (var signal : ISignal in _signals.signals)
				signal.removeAll();
		}
	}
}
