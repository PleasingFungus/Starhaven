package Sminos {
	import flash.geom.Point;
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class SmallBarracks extends Barracks {
		
		public function SmallBarracks(X:int,Y:int) {
			var blocks:Array, sprite:Class, inactiveSprite:Class;
			if (C.BEAM_DEFENSE) {
				blocks = [new Block(0, 0), new Block(1, 0),
						  new Block(0, 1), new Block(1, 1)];
				sprite = _sprite;
				inactiveSprite = _sprite_in;
				
			} else {
				blocks = [new Block(0, 0),
						  new Block(0, 1), new Block(1, 1)];
				sprite = _sprite_2;
				inactiveSprite = _sprite_in_2;
			}
			powerReq = 10;
			
			super(X, Y, blocks, new Point(0, 0), sprite, inactiveSprite);
			
			name = "Small Barracks";
		}
		
		[Embed(source = "../../lib/art/sminos/small_bear_2.png")] private static const _sprite:Class;
		[Embed(source = "../../lib/art/sminos/small_bear_in_2.png")] private static const _sprite_in:Class;
		
		[Embed(source = "../../lib/art/sminos/small_bear_3.png")] private static const _sprite_2:Class;
		[Embed(source = "../../lib/art/sminos/small_bear_in_3.png")] private static const _sprite_in_2:Class;
	}

}