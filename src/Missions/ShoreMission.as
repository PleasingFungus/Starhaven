package Missions {
	import org.flixel.FlxU;
	import Mining.MineralBlock;
	import Mining.Terrain;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class ShoreMission extends Mission {
		
		private var planetWidth:int;
		public function ShoreMission(Seed:Number) {
			super(Seed);
			
			var map_width:int = convertSize(FlxU.random());
			
			planetWidth = map_width * 2;
			
			var achLangSyne:Number = Math.PI * 2;
			achLangSyne /= planetWidth; //conversion;
			achLangSyne /= 1.5;
			var A:int = -(waterDepth + 7);
			
			var planetWidth:int = map_width * 2;
			var broadHeightmap:Array = [];
			var chunkSize:int = 5;
			for (var X:int = 0; X < planetWidth / chunkSize; X++)
				broadHeightmap[X] = FlxU.random() * 2;
			
			mapBlocks = [];
			for (var x:int = 0; x < planetWidth; x++) {
				var heightmapLevel:int = broadHeightmap[Math.floor(x / chunkSize)];
				var sinComponent:Number = A * Math.sin((x - planetWidth/2) / achLangSyne) + A / 2;
				var fullHeight:int = heightmapLevel + sinComponent + FlxU.random() * 3;
				fullHeight = Math.min(2, fullHeight);
				var bedrockDepth:int = Math.max( - fullHeight - 3, 1) + FlxU.random() * 2;
				
				for (var y:int = fullHeight; y < planetDepth; y++) {
					var newBlock:MineralBlock = new MineralBlock(x, y);
					if (planetDepth - y <= bedrockDepth)
						newBlock.type = MineralBlock.BEDROCK;
					mapBlocks.push(newBlock);
				}
			}
			
			var totalArea:int = mapBlocks.length;
			var largeClusters:int = totalArea * .006;
			var smallClusters:int = totalArea * .009;
			
			for (var i:int = 0; i < largeClusters; i++)
				genCluster(3, FlxU.random() < 1/3 ? MineralBlock.ORANGE_MINERALS : MineralBlock.PURPLE_MINERALS);
			for (i = 0; i < smallClusters; i++)
				genCluster(2);
			genNoise();
			
			rawMap = new Terrain(mapBlocks, new Point(planetWidth, planetDepth - waterDepth));
			fullMapSize = new Point(map_width, Math.floor((planetDepth + atmosphere + waterDepth) / 2));
		}
		
		protected function convertSize(sizeFraction:Number):int {
			return 39;
		}
		
		protected const planetDepth:int = 9;
		protected const waterDepth:int = 4;
		protected const surfaceDepth:int = 5;
		public static const atmosphere:int = 22;
		
	}

}