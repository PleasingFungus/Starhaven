package Missions {
	import org.flixel.FlxU;
	import Mining.MineralBlock;
	import Mining.Terrain;
	import flash.geom.Point;
	/**
	 * ...
	 * @author ...
	 */
	public class PlanetMission extends Mission {
		
		public function PlanetMission(Seed:Number) {
			super(Seed);
			
			var map_width:int = convertSize(FlxU.random());
			
			var planetWidth:int = map_width * 2;
			var broadHeightmap:Array = [];
			var chunkSize:int = 5;
			for (var X:int = 0; X < planetWidth / chunkSize; X++)
				broadHeightmap[X] = FlxU.random() * 2;
			
			mapBlocks = [];
			for (var x:int = 0; x < planetWidth; x++) {
				var bedrockDepth:int = FlxU.random() * 2 + 2;
				for (var y:int = broadHeightmap[Math.floor(x / chunkSize)] + FlxU.random() * 3; y < planetDepth; y++) {
					var newBlock:MineralBlock = new MineralBlock(x, y);
					if (planetDepth - y <= bedrockDepth || Math.abs(x - planetWidth/2) < 3)
						newBlock.type = MineralBlock.BEDROCK;
					mapBlocks.push(newBlock);
				}
			}
			
			var totalArea:int = map_width * planetDepth;
			var largeClusters:int = totalArea * .012;
			var smallClusters:int = totalArea * .018;
			
			for (var i:int = 0; i < largeClusters; i++)
				genCluster(3);
			for (i = 0; i < smallClusters; i++)
				genCluster(2);
			genNoise();
			
			rawMap = new Terrain(mapBlocks, new Point(planetWidth, planetDepth));
			fullMapSize = new Point(map_width, Math.floor((planetDepth + atmosphere) / 2));
		}
		
		override protected function randomMineralType():int {
			return MineralBlock.PURPLE_MINERALS;
		}
		
		protected function convertSize(sizeFraction:Number):int {
			return 27 + sizeFraction * 6;
		}
		
		protected const planetDepth:int = 12;
		public static const atmosphere:int = 24;
	}

}