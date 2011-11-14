package Missions {
	import flash.geom.Point;
	import org.flixel.FlxU;
	import Mining.MineralBlock;
	import Mining.Terrain;
	
	/**
	 * ...
	 * @author ...
	 */
	public class NebulaMission extends Mission {
		
		private var nebulaBlocks:Array;
		private var nebulaGrid:Array;
		public function NebulaMission(Seed:Number) {
			super(Seed);
			
			var size:int = 36;
			var area:int = size * size / 4;
			
			var largeClusters:int = area * 0.03;
			var smallClusters:int = area * 0.12;
			
			fullMapSize = new Point(size, size);
			
			nebulaBlocks = [];
			nebulaGrid = [];
			for (var i:int = 0; i < largeClusters; i++)
				genCluster(4);
			for (i = 0; i < smallClusters; i++)
				genCluster(3);
			genNoise();
			
			rawMap = new Terrain(nebulaBlocks, fullMapSize.clone());
			fullMapSize.x /= 2;
			fullMapSize.y /= 2;
		}
		
		override protected function genCluster(radius:int, _:int = -1):void {
			var centerX:int = FlxU.random() * fullMapSize.x;
			var centerY:int = FlxU.random() * fullMapSize.y;
			var rsqr:int = radius * radius;
			var type:int = randomMineralType();
			
			for (var x:int = -radius; x < radius; x++)
				for (var y:int = -radius; y < radius; y++)
					if (x >= 0 && x < fullMapSize.x && y >= 0 && y < fullMapSize.y &&
						x*x + y*y <= rsqr)
						addBlock(centerX + x, centerY + y, type);
		}
		
		override protected function genNoise(addChance:Number = 0.06, killChance:Number = 0.08):void {
			for (var x:int = 0; x < fullMapSize.x; x++)
				for (var y:int = 0; y < fullMapSize.y; y++) {
					var roll:Number = FlxU.random();
					if (roll < addChance)
						addBlock(x, y, randomMineralType());
					else if (roll < addChance + killChance)
						removeBlock(x, y);
				}
		}
		
		private function addBlock(x:int, y:int, type:int):void {
			var gridCoord:int = x + y * fullMapSize.x;
			if (!nebulaGrid[gridCoord]) {
				var block:MineralBlock = new MineralBlock(x, y, 1, type);
				nebulaGrid[gridCoord] = block;
				nebulaBlocks.push(block);
			}
		}
		
		private function removeBlock(x:int, y:int):void {
			var gridCoord:int = x + y * fullMapSize.x;
			if (nebulaGrid[gridCoord]) {
				var block:MineralBlock = nebulaGrid[gridCoord];
				nebulaGrid[gridCoord] = null;
				nebulaBlocks.splice(nebulaBlocks.indexOf(block), 1);
			}
		}
		
	}

}