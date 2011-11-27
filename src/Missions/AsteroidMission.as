package Missions {
	import org.flixel.FlxU;
	import Mining.MineralBlock;
	import Mining.Terrain;
	import flash.geom.Point;
	/**
	 * ...
	 * @author ...
	 */
	public class AsteroidMission extends Mission {
		
		public function AsteroidMission(Seed:Number, Scale:Number = 1) {
			super(Seed);
			
			var size:int = convertSize(FlxU.random()) * Scale;
			
			var majorAxis:int = size * (1 + eccentricity * FlxU.random());
			var minorAxis:int = size * (1 - eccentricity * FlxU.random());
			
			var iAxis:int, jAxis:int;
			if (FlxU.random() > 0.5) {
				iAxis = majorAxis;
				jAxis = minorAxis;
			} else {
				iAxis = minorAxis;
				jAxis = majorAxis;
			}
			C.log("Axes: "+iAxis, jAxis);
			
			mapBlocks = [];
			
			var sqiaxis:int = iAxis * iAxis;
			var sqjaxis:int = jAxis * jAxis;
			
			for (var x:int = -iAxis; x < iAxis; x++)
				for (var y:int = -jAxis; y < jAxis; y++) {
					var ellipticalDistance:Number = x*x/sqiaxis + y*y/sqjaxis;
					if (ellipticalDistance <= 1 && (ellipticalDistance <= 0.9 || FlxU.random() > 0.7))
						mapBlocks.push(new MineralBlock(x + iAxis, y + jAxis, 5,
														ellipticalDistance <= 0.07 ? MineralBlock.BEDROCK : MineralBlock.ROCK));
						
				}
			
			var largeClusters:int = Math.ceil(size / 6);
			var smallClusters:int = Math.ceil(size / 4);
			
			for (var i:int = 0; i < largeClusters; i++)
				genCluster(3, FlxU.random() < 1/3 ? MineralBlock.ORANGE_MINERALS : MineralBlock.PURPLE_MINERALS);
			for (i = 0; i < smallClusters; i++)
				genCluster(2);
			genNoise();
			
			rawMap = new Terrain(mapBlocks, new Point(Math.floor(iAxis * 2 - 1), Math.floor(jAxis * 2 - 1)));
			fullMapSize = new Point(majorAxis + 15, majorAxis + 15);
		}
		
		protected function convertSize(sizeFraction:Number):int {
			return 12;
		}
		
		protected static const eccentricity:Number = 0.25;
	}

}