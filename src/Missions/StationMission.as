package Missions {
	import org.flixel.FlxU;
	import Mining.MineralBlock;
	import Mining.Terrain;
	import flash.geom.Point;
	/**
	 * ...
	 * @author ...
	 */
	public class StationMission extends Mission {
		
		private var iAxis:int;
		private var jAxis:int;
		private var stationBlocks:Array;
		private var stationGrid:Array;
		public function StationMission(Seed:Number) {
			super(Seed);
			
			//generate gross shape
			
			var size:int = 16;//convertSize(FlxU.random());
			
			var majorAxis:int = 16;// size * (1 + eccentricity * FlxU.random());
			var minorAxis:int = 16;// size * (1 - eccentricity * FlxU.random());
			
			if (FlxU.random() > 0.5) {
				iAxis = majorAxis;
				jAxis = minorAxis;
			} else {
				iAxis = minorAxis;
				jAxis = majorAxis;
			}
			
			C.log("Axes: "+iAxis, jAxis);
			
			stationBlocks = [];
			stationGrid = [];
			
			//generate specific shape
			
			genBar(-iAxis, -jAxis*3/4, iAxis*2, jAxis/2); 
			genBar(-iAxis, jAxis/4, iAxis*2, jAxis/2);
			genBar(-iAxis*3/4, -jAxis, iAxis/2, jAxis*2);
			genBar(iAxis/4, -jAxis, iAxis/2, jAxis*2);
			
			//erode
			
			//generate minerals
			
			var largeClusters:int = Math.ceil(size / 6);
			var smallClusters:int = Math.ceil(size / 4);
			
			for (var i:int = 0; i < largeClusters; i++)
				genCluster(stationBlocks, FlxU.random(), 3, FlxU.random() < 1/3 ? MineralBlock.ORANGE_MINERALS : MineralBlock.PURPLE_MINERALS);
			for (i = 0; i < smallClusters; i++)
				genCluster(stationBlocks, FlxU.random(), 2, randomMineralType());
			
			for each (var block:MineralBlock in stationBlocks) {
				var rand:Number = FlxU.random();
				if (rand < 0.06 && !block.type)
					block.type = randomMineralType();
				else if (rand < 0.14)
					block.type = MineralBlock.ROCK;
			}
			
			rawMap = new Terrain(stationBlocks, new Point(Math.floor(iAxis * 2 - 1), Math.floor(jAxis * 2 - 1)));
			fullMapSize = new Point(majorAxis + 15, majorAxis + 15);
		}
		
		protected function genBar(X:int, Y:int, Width:int, Height:int):void {
			var right:int = Width + X;
			var bottom:int = Height + Y;
			
			var x:int, y:int;
			for (x = X; x < right; x++)
				for (y = Y; y < bottom; y++)
					if (!stationGrid[x + y * jAxis])
						stationBlocks.push(stationGrid[x + y * jAxis] = new MineralBlock(x, y));
		}
		
		protected function genCluster(stationBlocks:Array, randomIndex:Number, radius:int, clusterType:int):void {
			var randomBlock:MineralBlock = stationBlocks[Math.floor(randomIndex * stationBlocks.length)];			
			for (var i:int = 0; i < stationBlocks.length; i++) {
				var block:MineralBlock = stationBlocks[i];
				if (block.subtract(randomBlock).length <= radius)
					stationBlocks[i].type = clusterType;
			}
		}
		
		private function randomMineralType():int {
			var roll:Number = FlxU.random();
			if (roll < 4/7)
				return MineralBlock.PURPLE_MINERALS;
			if (roll < 6/7)
				return MineralBlock.ORANGE_MINERALS;
			return MineralBlock.TEAL_MINERALS;
		}
		
		protected static const eccentricity:Number = 0.25;
	}

}
