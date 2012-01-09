package Sminos {
	import flash.geom.Point;
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class MediumBarracks extends Barracks {
		
		public function MediumBarracks(X:int, Y:int) {
			var blocks:Array, sprite:Class, inactiveSprite:Class;
			if (C.BEAM_DEFENSE) {
				blocks = [new Block(0, 0), new Block(1, 0), new Block(2, 0),
						  new Block(0, 1), new Block(1, 1), new Block(2, 1)];
				sprite = _sprite;
				inactiveSprite = _sprite_in;
				
			} else {
				blocks = [new Block(0, 0), 					new Block(2, 0),
						  new Block(0, 1), new Block(1, 1), new Block(2, 1)];
				sprite = _sprite_2;
				inactiveSprite = _sprite_in_2;
			}
			powerReq = 25;
			
			super(X, Y, blocks, new Point(1, 1), sprite, inactiveSprite);
			
			name = "Barracks";
		}
		
		[Embed(source = "../../lib/art/sminos/med_bear.png")] private static const _sprite:Class;
		[Embed(source = "../../lib/art/sminos/med_bear_in.png")] private static const _sprite_in:Class;
		
		[Embed(source = "../../lib/art/sminos/med_bear_2.png")] private static const _sprite_2:Class;
		[Embed(source = "../../lib/art/sminos/med_bear_in_2.png")] private static const _sprite_in_2:Class;
	}

}