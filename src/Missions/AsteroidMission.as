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
		
		protected var xAxis:int;
		protected var yAxis:int;
		
		public function AsteroidMission(Seed:Number, Scale:Number) {
			super(Seed, Scale);
			
			var size:int = convertSize(FlxU.random()) * Scale;
			
			var majorAxis:int = size * (1 + eccentricity * FlxU.random());
			var minorAxis:int = size * (1 - eccentricity * FlxU.random());
			
			if (FlxU.random() > 0.5) {
				xAxis = majorAxis;
				yAxis = minorAxis;
			} else {
				xAxis = minorAxis;
				yAxis = majorAxis;
			}
			
			
			
			mapBlocks = [];
			
			var sqxAxis:int = xAxis * xAxis;
			var sqyAxis:int = yAxis * yAxis;
			
			var bedrockDepth:Number = getBedrockDepth();
			for (var x:int = -xAxis; x < xAxis; x++)
				for (var y:int = -yAxis; y < yAxis; y++) {
					var ellipticalDistance:Number = x*x/sqxAxis + y*y/sqyAxis;
					if (ellipticalDistance <= 1 && (ellipticalDistance <= 0.9 || FlxU.random() > 0.7))
						mapBlocks.push(new MineralBlock(x + xAxis, y + yAxis, 5,
														ellipticalDistance < bedrockDepth ? MineralBlock.BEDROCK : MineralBlock.ROCK));
						
				}
			
			genMinerals();
			
			rawMap = new Terrain(mapBlocks, new Point(Math.floor(xAxis * 2 - 1), Math.floor(yAxis * 2 - 1)));
			fullMapSize = new Point(majorAxis + 15, majorAxis + 15);
		}
		
		override protected function validMineralLoc(block:MineralBlock):Boolean {
			return super.validMineralLoc(block) && (block.x < xAxis-2 || block.x > xAxis+2 || block.y >= yAxis);
		}
		
		protected function convertSize(sizeFraction:Number):int {
			return 12;
		}
		
		protected function getBedrockDepth():Number {
			return 0.07;
		}
		
		protected static const eccentricity:Number = 0.25;
	}

}