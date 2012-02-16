package Missions {
	import org.flixel.*;
	import Mining.MineralBlock;
	import Mining.Terrain;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class TerrestrialMission extends Mission {
		
		protected var mapWidth:int;
		protected var chunkSize:int = 5;
		public var rockDepth:int;
		public var atmosphere:int;
		protected var broadHeightmap:Array;
		public function TerrestrialMission(Seed:Number, Scale:Number) {
			super(Seed, Scale);
			buildBroadHeightmap();
			buildRock();
			buildMinerals();
			buildReturns();
		}
		
		protected function buildBroadHeightmap():Array {
			var chunkedWidth:int = mapWidth / chunkSize;
			broadHeightmap = new Array(chunkedWidth);
			for (var X:int = 0; X < chunkedWidth; X++)
				broadHeightmap[X] = broadHeightmapHeight(X);
			return broadHeightmap;
		}
		
		protected function broadHeightmapHeight(X:int):int {
			return Math.floor(FlxU.random() * 2);
		}
		
		protected function buildRock():void {
			mapBlocks = [];
			for (var x:int = 0; x < mapWidth; x++) {
				var top:int = topAt(x);
				var bedrockDepth:int = bedrockDepthAt(x);
				for (var y:int = top; y < rockDepth; y++) {
					var newBlock:MineralBlock = new MineralBlock(x, y);
					if (y >= bedrockDepth)
						newBlock.type = MineralBlock.BEDROCK;
					mapBlocks.push(newBlock);
				}
			}
		}
		
		protected function topAt(x:int):int {
			return broadHeightmap[Math.floor(x / chunkSize)] + FlxU.random() * 3;
		}
		
		protected function bedrockDepthAt(x:int):int {
			var distFromCenter:int = Math.abs(x - mapWidth / 2);
			distFromCenter = Math.max(distFromCenter - 2, 0);
			var bedrockDepth:int = Math.floor(rockDepth - (FlxU.random() * 2 + 2));
			if (distFromCenter < 6)
				return (distFromCenter / 6) * bedrockDepth;
			return bedrockDepth;
		}
		
		protected function buildMinerals():void {
			var totalArea:int = mapBlocks.length;
			var largeClusters:int = totalArea * .008;
			var smallClusters:int = totalArea * .012;
			
			for (var i:int = 0; i < largeClusters; i++)
				genCluster(3);
			for (i = 0; i < smallClusters; i++)
				genCluster(2);
			genNoise();
		}
		
		protected function buildReturns():void {
			rawMap = new Terrain(mapBlocks, new Point(mapWidth, rockDepth));
			fullMapSize = new Point(mapWidth/2, Math.floor((rockDepth + atmosphere) / 2));
		}
	}

}