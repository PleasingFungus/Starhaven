package GameBonuses.Collect.Sminos {
	import flash.geom.Point;
	import Sminos.Barracks;
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class SmallBarracksC extends Barracks {
		
		public function SmallBarracksC(X:int,Y:int) {
			var blocks:Array, sprite:Class, inactiveSprite:Class;
			
			blocks = [new Block(0, 0),
					  new Block(0, 1), new Block(1, 1)];
			sprite = _sprite;
			inactiveSprite = _sprite_in;
			
			powerReq = 10;
			
			super(X, Y, blocks, new Point(0, 0), sprite, inactiveSprite);
			
			name = "Small Barracks-C";
		}
		
		[Embed(source = "../../../../lib/art/sminos/small_bear_3.png")] private static const _sprite:Class;
		[Embed(source = "../../../../lib/art/sminos/small_bear_in_3.png")] private static const _sprite_in:Class;
	}

}