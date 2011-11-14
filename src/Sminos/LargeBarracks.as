package Sminos {
	import flash.geom.Point;
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class LargeBarracks extends Barracks {
		
		public function LargeBarracks(X:int, Y:int) {
			var blocks:Array = [new Block(0, 0), new Block(1, 0), new Block(2, 0),
								new Block(0, 1), new Block(1, 1), new Block(2, 1),
								new Block(0, 2), 				  new Block(2, 2)];
			powerReq = 50;
			super(X, Y, blocks, new Point(1, 1), _sprite, _sprite_in);
			name = "Large Barracks";
		}
		
		[Embed(source = "../../lib/art/sminos/lg_bear.png")] private static const _sprite:Class;
		[Embed(source = "../../lib/art/sminos/lg_bear_in.png")] private static const _sprite_in:Class;
		
	}

}