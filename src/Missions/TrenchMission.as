package Missions {
	import org.flixel.FlxU;
	import Mining.MineralBlock;
	import Mining.Terrain;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class TrenchMission extends Mission {
		
		public function TrenchMission(Seed:Number) {
			super(Seed);
			
			var mapHeight:int = MAP_HEIGHT + WALL_WIDTH; //including bottom bit
			var mapWidth:int = TRENCH_WIDTH + (WALL_WIDTH + TRENCH_VARIANCE) * 2;
			
			mapBlocks = [];
			var chunkSize:int = 5;
			var x:int, y:int;
			
			for (y = 0; y < MAP_HEIGHT; y++) {
				if (y % chunkSize == 0) {
					var leftOffset:int = FlxU.random() * 2;
					var rightOffset:int = FlxU.random() * 2;
				}
					
				var fullWallWidth:int = WALL_WIDTH + leftOffset + FlxU.random() * 3;
				for (x = 0; x < fullWallWidth; x++)
					mapBlocks.push(new MineralBlock(x, y));
				
				fullWallWidth = WALL_WIDTH + rightOffset + FlxU.random() * 2;
				for (x = mapWidth - 1; x >= mapWidth - 1 - fullWallWidth; x--)
					mapBlocks.push(new MineralBlock(x, y));
			}
			
			for (x = 0; x < mapWidth; x++) {	
				var bedrockDepth:int = mapHeight - Math.ceil(FlxU.random() * 2);
				for (y = MAP_HEIGHT; y < mapHeight; y++)  {
					var newBlock:MineralBlock = new MineralBlock(x, y);
					if (y >= bedrockDepth)
						newBlock.type = MineralBlock.BEDROCK;
					mapBlocks.push(newBlock);
				}
			}
			
			
			var totalArea:int = mapBlocks.length;
			var largeClusters:int = totalArea * .010;
			var smallClusters:int = totalArea * .015;
			
			for (var i:int = 0; i < largeClusters; i++)
				genCluster(3, FlxU.random() < 1/3 ? MineralBlock.ORANGE_MINERALS : MineralBlock.PURPLE_MINERALS);
			for (i = 0; i < smallClusters; i++)
				genCluster(2);
			genNoise();
			
			fullMapSize = new Point(Math.floor(mapWidth/2), Math.floor(mapHeight / 2));
			rawMap = new Terrain(mapBlocks, fullMapSize);
		}
		
		protected const WALL_WIDTH:int = 8;
		public static const TRENCH_WIDTH:int = 12;
		protected const TRENCH_VARIANCE:int = 4;
		protected const MAP_HEIGHT:int = 30;
		
	}

}