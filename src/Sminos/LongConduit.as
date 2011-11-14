package Sminos {
	import flash.geom.Point;
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class LongConduit extends Conduit {
		
		public function LongConduit(X:int, Y:int) {
			var blocks:Array = [];
			for (var y:int = 0; y < 4; y++)
				blocks.push(new Block(0, y));
			super(X, Y, blocks, new Point(0, 2), _sprite, _sprite_in);
			name = "Long-Conduit";
		}
		
		[Embed(source = "../../lib/art/sminos/long_cond.png")] private static const _sprite:Class;
		[Embed(source = "../../lib/art/sminos/long_cond_in.png")] private static const _sprite_in:Class;
	}

}