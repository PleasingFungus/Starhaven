package GameBonuses.Collect.Sminos {
	import flash.geom.Point;
	import Sminos.Barracks;
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class MediumBarracksC extends Barracks {
		
		public function MediumBarracksC(X:int, Y:int) {
			var blocks:Array, sprite:Class, inactiveSprite:Class;
			
			blocks = [new Block(0, 0),					new Block(2, 0),
					  new Block(0, 1), new Block(1, 1), new Block(2, 1)];
			sprite = _sprite;
			inactiveSprite = _sprite_in;
			
			powerReq = 25;
			
			super(X, Y, blocks, new Point(1, 1), sprite, inactiveSprite);
			
			name = "Barracks-C";
		}
		
		[Embed(source = "../../../../lib/art/sminos/med_bear_2.png")] private static const _sprite:Class;
		[Embed(source = "../../../../lib/art/sminos/med_bear_in_2.png")] private static const _sprite_in:Class;
	}

}