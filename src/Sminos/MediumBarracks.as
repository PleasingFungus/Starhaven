package Sminos {
	import flash.geom.Point;
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class MediumBarracks extends Barracks {
		
		public function MediumBarracks(X:int, Y:int) {
			var blocks:Array, sprite:Class, inactiveSprite:Class;
			
			blocks = [new Block(0, 0), new Block(1, 0), new Block(2, 0),
					  new Block(0, 1), new Block(1, 1), new Block(2, 1)];
			sprite = _sprite;
			inactiveSprite = _sprite_in;
			
			powerReq = 25;
			
			super(X, Y, blocks, new Point(1, 1), sprite, inactiveSprite);
			
			name = "Barracks";
		}
		
		[Embed(source = "../../lib/art/sminos/med_bear.png")] private static const _sprite:Class;
		[Embed(source = "../../lib/art/sminos/med_bear_in.png")] private static const _sprite_in:Class;
	}

}