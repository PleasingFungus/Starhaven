package Sminos {
	import flash.geom.Point;
	import Icons.Icontext;
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class PowerGen extends Smino {
		
		public function PowerGen(X:int, Y:int, Blocks:Array, Center:Point,
								 PowerGeneration:int = 0, CrewReq:int = 0,
								 Sprite:Class = null, InopSprite:Class = null) {
			
			powerGen = PowerGeneration;
			crewReq = CrewReq;
			transmitsPower = true;
			
			super(X, Y, Blocks, Center, 0xffdb3d3d, 0xfffff947, Sprite, InopSprite);
		}
	}

}