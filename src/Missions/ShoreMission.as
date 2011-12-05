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
			
			var map_width:int = 39;
			planetWidth = map_width * 2;
			
			var sinPeriod:Number = Math.PI * 2;
			sinPeriod /= planetWidth; //conversion;
			//sinPeriod /= 1.5;
			var A:int = -(waterDepth + surfaceDepth);
			var sinSign:int = FlxU.random() > 0.5 ? 1 : -1;
			
			var chunkSize:int = 5;
			var broadHeightmap:Array = new Array(Math.floor(planetWidth / chunkSize));
			for (var X:int = 0; X < broadHeightmap.length; X++)
				broadHeightmap[X] = FlxU.random() * 2;
			
			var narrowHeightmap:Array = new Array(planetWidth);
			mapBlocks = [];
			for (var x:int = 0; x < planetWidth; x++) {
				var heightmapLevel:int = broadHeightmap[Math.floor(x / chunkSize)];
				var sinComponent:Number = A * Math.sin((x - planetWidth/2) / sinPeriod) * sinSign + A / 2;
				var fullHeight:int = heightmapLevel + sinComponent + FlxU.random() * 3;
				fullHeight = Math.min(2, fullHeight);
				var bedrockDepth:int = Math.max( - fullHeight - 3, 1) + FlxU.random() * 2;
				
				for (var y:int = fullHeight; y < planetDepth; y++) {
					var newBlock:MineralBlock = new MineralBlock(x, y);
					if (planetDepth - y <= bedrockDepth)
						newBlock.type = MineralBlock.BEDROCK;
					mapBlocks.push(newBlock);
				}
				
				narrowHeightmap[x] = new Point(fullHeight, planetDepth - bedrockDepth); //misusing points!
			}
			
			for (var i:int = 0; i < 6; i++) {
				genCluster(2, -1, locCluster(i, narrowHeightmap));
				genCluster(2, -1, locCluster(i, narrowHeightmap));
				genCluster(3, -1, locCluster(i, narrowHeightmap));
			}
			
			genNoise();
			
			rawMap = new Terrain(mapBlocks, new Point(planetWidth, planetDepth - waterDepth));
			fullMapSize = new Point(map_width, Math.floor((planetDepth + atmosphere + waterDepth) / 2));
		}
		
		protected function locCluster(i:int, narrowHeightmap:Array):MineralBlock {
			var rx:int = (FlxU.random() + i) * planetWidth / 6;
			var heightRange:Point = narrowHeightmap[rx];
			var ry:int = FlxU.random() * (heightRange.y - heightRange.x) + heightRange.x;
			C.log("Random cluster: "+rx, ry);
			for each (var block:MineralBlock in mapBlocks)
				if (block.x == rx && block.y == ry)
					return block;
			return null;
		}
		
		override protected function randomMineralType():int {
			return MineralBlock.WEAK_MINERALS;
		}
		
		protected const planetDepth:int = 9;
		protected const waterDepth:int = 2;
		protected const surfaceDepth:int = 9;
		public static const atmosphere:int = 25;
		
	}

}