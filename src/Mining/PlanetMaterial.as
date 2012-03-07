package Mining {
	import flash.geom.Point;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class PlanetMaterial extends BaseAsteroid {
		
		public function PlanetMaterial(X:int, Y:int, Blocks:Array, Center:Point, Scale:Number = 1) {
			super(X, Y, Blocks, Center, Scale);
		}
		
		override protected function blockColor(block:MineralBlock):uint {
			if (block.type == MineralBlock.ROCK)
				return 0xffd6a071;
			return block.color;
		}
		
	}

}