package Sminos {
	import flash.geom.Point;
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class SmallBarracks extends Barracks {
		
		public function SmallBarracks(X:int,Y:int) {
			var blocks:Array = [new Block(0, 0), new Block(1, 0),
								new Block(0, 1), new Block(1, 1)];
			powerReq = 10;
			
			super(X, Y, blocks, new Point(0, 0), _sprite, _sprite_in);
			
			name = "Small Barracks";
		}
		
		[Embed(source = "../../lib/art/sminos/small_bear_2.png")] private static const _sprite:Class;
		[Embed(source = "../../lib/art/sminos/small_bear_in_2.png")] private static const _sprite_in:Class;
	}

}