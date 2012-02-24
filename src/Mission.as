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
		protected var scale:Number;
		
		public var rawMap:Terrain;
		public var fullMapSize:Point;
		protected var mapBlocks:Array;
		protected var goalFactor:Number;
		public function Mission(Seed:Number, Scale:Number) {
			seed = Seed;
			FlxU.seed = Seed;
			scale = Scale;
			goalFactor = 1;
		}
		
		
		protected function genMinerals():void {
			var goal:int = mapBlocks.length * 2 * goalFactor;
			while (totalMinerals() < goal * (1 + NOISE_FACTOR)) {
				var clusterSize:int;
				genCluster(randomClusterSize());
			}
			
			while (totalMinerals() > goal)
				genSingleNoise(findRandomBlock());
		}
		
		protected function totalMinerals():int {
			var total:int = 0;
			for each (var block:MineralBlock in mapBlocks)
				total += block.value;
			return total;
		}
		
		protected function genCluster(radius:int, clusterType:int = -1, Target:MineralBlock = null):void {
			if (clusterType == -1)
				clusterType = randomMineralType();
			
			var randomBlock:MineralBlock = Target ? Target : findRandomBlock();
			
			for (var i:int = 0; i < mapBlocks.length; i++) {
				var block:MineralBlock = mapBlocks[i];
				if (validMineralLoc(block) && block.subtract(randomBlock).length <= radius)
					mapBlocks[i].type = clusterType;
			}
		}
		
		protected function findRandomBlock():MineralBlock {;
			var randomIndex:int = FlxU.random() * mapBlocks.length;
			var randomBlock:MineralBlock = mapBlocks[randomIndex];
			
			while (!validMineralLoc(randomBlock)) {
				randomIndex = FlxU.random() * mapBlocks.length;
				randomBlock = mapBlocks[randomIndex];
			}
			
			return randomBlock;
		}
		
		protected function validMineralLoc(block:MineralBlock):Boolean {
			return block.type != MineralBlock.BEDROCK;
		}
		
		protected function genNoise(addChance:Number = 0.04, removeChance:Number = 0.08):void {
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
		
		protected function genSingleNoise(block:MineralBlock, addChance:Number = 0.2):void {
			if (!validMineralLoc(block))
				return;
			
			block.type = FlxU.random() < addChance ? randomMineralType() : MineralBlock.ROCK;
		}
		
		protected function randomMineralType():int {
			var roll:Number = FlxU.random();
			if (roll < 2/3)
				return MineralBlock.WEAK_MINERALS;
			return MineralBlock.MED_MINERALS;
		}
		
		protected function randomClusterSize():int {
			var roll:Number = FlxU.random();
			if (roll < 27 / 63) //27 / x
				return 2;
			if (roll < 42 / 63) //18 / x
				return 3;
			if (roll < 54 / 63) //12 / x
				return 4;
			return 5;		 	//8 / x
		}
		
		protected const NOISE_FACTOR:Number = 0.075;
	}

}