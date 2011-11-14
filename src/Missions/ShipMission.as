package Missions {
	import org.flixel.FlxU;
	import Mining.MineralBlock;
	import Mining.Terrain;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class ShipMission extends Mission {
		
		private var totalMinerals:int;
		public function ShipMission(Seed:Number) {
			super(Seed);
			
			mapBlocks = [];
			
			var size:int = convertSize(FlxU.random());
			
			var majorAxis:int = size * (1 + VAR_ECCENTRICITY * FlxU.random() + MIN_ECCENTRICITY);
			var minorAxis:int = size;
			
			var iAxis:int, jAxis:int, horizontal:Boolean;
			if (FlxU.random() > 0.5) {
				iAxis = majorAxis;
				jAxis = minorAxis;
				horizontal = true;
			} else {
				iAxis = minorAxis;
				jAxis = majorAxis;
				horizontal = false;
			}
			C.log("Axes: "+iAxis, jAxis);
			
			//gen heightmap
			
			var chunkSize:int = 3;
			var minimumWidth:int = 1;
			var heightmap:Array = new Array(Math.floor(majorAxis*2 / chunkSize));
			for (var I:int = 0; I < heightmap.length; I++) {
				var realI:Number = (I + .5) * chunkSize - majorAxis;
				var J:int = (1 - Math.abs(realI / majorAxis)) * minorAxis + minimumWidth;
				C.log(I, realI, J);
				
				var bonusHeightFraction:Number = FlxU.random();
				bonusHeightFraction *= bonusHeightFraction;
				
				J += bonusHeightFraction * (minorAxis - J); //omit the square for more randomness
				heightmap[I] = J;
			}
			
			//fill ship
			var erodeChance:Number = 0.1;
			for (I = -majorAxis; I < majorAxis; I++) {
				var heightmapValue:int = heightmap[Math.floor((I + majorAxis) / chunkSize)];
				for (J = 0; J < heightmapValue; J++) {
					var onEdge:Boolean = J == heightmapValue - 1 || I == -majorAxis || I == majorAxis - 1;
					if (!onEdge || FlxU.random() > erodeChance)
						addBlock(I, J, horizontal, mapBlocks);
					if (J && (!onEdge || FlxU.random() > erodeChance))
						addBlock(I, -J, horizontal, mapBlocks);
				}
			}
			
			//gen minerals
			
			var largeClusters:int = Math.ceil(2);
			var smallClusters:int = Math.ceil(3);
			
			while (totalMinerals < 600) {
				for (var i:int = 0; i < largeClusters; i++)
					genCluster(3, FlxU.random() < 1/3 ? MineralBlock.ORANGE_MINERALS : MineralBlock.PURPLE_MINERALS);
				for (i = 0; i < smallClusters; i++)
					genCluster(2);
			}
			
			genNoise(0.03, 0.07);
			
			rawMap = new Terrain(mapBlocks, new Point(Math.floor(iAxis * 2 - 1), Math.floor(jAxis * 2 - 1)));
			rawMap.center = new Point;
			fullMapSize = new Point(majorAxis*2, majorAxis*2);
		}
		
		protected function convertSize(sizeFraction:Number):int {
			return 12 + sizeFraction * 4;
		}
		
		protected function addBlock(I:int, J:int, Horizontal:Boolean, mapBlocks:Array):void {
			if (Horizontal)
				mapBlocks.push(new MineralBlock(I, J));
			else
				mapBlocks.push(new MineralBlock(J, I));
		}
		
		override protected function genCluster(radius:int, clusterType:int = -1):void {
			var randomIndex:Number = Math.floor(FlxU.random() * mapBlocks.length / 2) * 2;
			var randomBlock:MineralBlock = mapBlocks[randomIndex];
			var mirrorBlock:MineralBlock = mapBlocks[randomIndex + 1];
			if (clusterType == -1)
				clusterType = randomMineralType();
			
			for (var i:int = 0; i < mapBlocks.length; i++) {
				var block:MineralBlock = mapBlocks[i];
				if ((Math.abs(block.x - randomBlock.x) <= radius &&
					 Math.abs(block.y - randomBlock.y) <= radius) ||
					(Math.abs(block.x - mirrorBlock.x) <= radius &&
					 Math.abs(block.y - mirrorBlock.y) <= radius)) {
					mapBlocks[i].type = clusterType;
					totalMinerals += 5;
				}
			}
		}
		
		protected static const VAR_ECCENTRICITY:Number = 0.25;
		protected static const MIN_ECCENTRICITY:Number = 0.25;
	}

}