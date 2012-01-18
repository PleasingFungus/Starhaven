package Missions {
	import org.flixel.FlxU;
	import Mining.Terrain;
	import Mining.MineralBlock;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class WaterMission extends TerrestrialMission {
		
		protected var waterDepth:int;
		public function WaterMission(Seed:Number) {
			mapWidth = 39 * 2;
			chunkSize = 4;
			rockDepth = 10;
			waterDepth = 11;
			atmosphere = 22;
			
			super(Seed);
		}
		
		override protected function broadHeightmapHeight(X:int):int {
			var centerDist:int = Math.abs(X - (mapWidth / chunkSize) / 2);
			if (centerDist < 1)
				return -waterDepth - 3;
			if (centerDist < 2)
				return -waterDepth / 2 - 1;
			return super.broadHeightmapHeight(X);
		}
			
		override protected function buildMinerals():void {
			var totalArea:int = mapBlocks.length;
			var largeClusters:int = totalArea * .006;
			var smallClusters:int = totalArea * .009;
			
			for (var i:int = 0; i < largeClusters; i++)
				genCluster(3, FlxU.random() < 1/3 ? MineralBlock.MED_MINERALS : MineralBlock.WEAK_MINERALS);
			for (i = 0; i < smallClusters; i++)
				genCluster(2);
			genNoise();
		}
		
		override protected function buildReturns():void {	
			rawMap = new Terrain(mapBlocks, new Point(mapWidth, rockDepth - waterDepth));
			fullMapSize = new Point(mapWidth/2, Math.floor((rockDepth + atmosphere + waterDepth) / 2));
		}
		
		override protected function validMineralLoc(block:MineralBlock):Boolean {
			return super.validMineralLoc(block) && block.y > -waterDepth/2 && Math.abs(block.x - mapWidth/2) > 2;
		}
		
		protected function convertSize(sizeFraction:Number):int {
			return 39;
		}
		
	}

}