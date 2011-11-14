package Sminos {
	import flash.geom.Point;
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class HookConduit extends Conduit {
		
		public function HookConduit(X:int, Y:int) {
			var blocks:Array = [new Block(1, 0), new Block(0, 0),
												new Block(0, 1),
												new Block(0, 2)];
			super(X, Y, blocks, new Point(0, 0), _sprite, _sprite_in);
			name = "Hook-Conduit";
		}
		
		[Embed(source = "../../lib/art/sminos/arr_cond.png")] private static const _sprite:Class;
		[Embed(source = "../../lib/art/sminos/arr_cond_in.png")] private static const _sprite_in:Class;
	}

}