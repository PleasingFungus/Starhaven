package  {
	import flash.geom.Point;
	import Mining.Terrain;
	import org.flixel.FlxU;
	import Mining.MineralBlock;
	/**
	 * ...
	 * @author ...
	 */
	public class Mission {
		
		public var seed:Number;
		public var rawMap:Terrain;
		public var fullMapSize:Point;
		protected var mapBlocks:Array;
		public function Mission(Seed:Number) {
			seed = Seed;
			FlxU.seed = Seed;
		}
		
		protected function genCluster(radius:int, clusterType:int = -1):void {
			var randomIndex:int = FlxU.random() * mapBlocks.length;
			var randomBlock:MineralBlock = mapBlocks[randomIndex];
			while (!validMineralLoc(randomBlock)) {
				randomIndex = FlxU.random() * mapBlocks.length;
				randomBlock = mapBlocks[randomIndex];
			}
			
			if (clusterType == -1)
				clusterType = randomMineralType();
			
			for (var i:int = 0; i < mapBlocks.length; i++) {
				var block:MineralBlock = mapBlocks[i];
				if (validMineralLoc(block) && block.subtract(randomBlock).length <= radius)
					mapBlocks[i].type = clusterType;
			}
		}
		
		protected function validMineralLoc(block:MineralBlock):Boolean {
			return block.type != MineralBlock.BEDROCK;
		}
		
		protected function genNoise(addChance:Number = 0.06, removeChance:Number = 0.08):void {
			for each (var block:MineralBlock in mapBlocks) {
				if (!validMineralLoc(block))
					continue;
				
				var rand:Number = FlxU.random();
				if (rand < addChance && block.type == MineralBlock.ROCK)
					block.type = randomMineralType();
				else if (rand < removeChance)
					block.type = MineralBlock.ROCK;
			}
		}
		
		protected function randomMineralType():int {
			var roll:Number = FlxU.random();
			if (roll < 4/7)
				return MineralBlock.PURPLE_MINERALS;
			if (roll < 6/7)
				return MineralBlock.ORANGE_MINERALS;
			return MineralBlock.TEAL_MINERALS;
		}
		
	}

}