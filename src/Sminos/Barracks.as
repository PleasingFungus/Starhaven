package Sminos {
	import flash.geom.Point;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class Barracks extends Smino {
		
		public function Barracks(X:int, Y:int, blocks:Array, center:Point,
								 Sprite:Class = null, InopSprite:Class = null) {
			crewCapacity = blocks.length;
			powerReq = blocks.length * 5; //eh
			
			super(X, Y, blocks, center, 0xff304c6d, 0xff4a8cd9, Sprite, InopSprite);
			crew = crewCapacity;
			
			cladeName = "Barracks";
			description = "This is a barracks.\n\nBarracks crew adjacent launchers.";		}
	}

}