package Missions {
	import org.flixel.FlxU;
	import Mining.MineralBlock;
	import Mining.Terrain;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class DCrescentMission extends Mission {
		
		public function DCrescentMission(Seed:Number, Scale:Number) {
			super(Seed, Scale);
			
			var size:int = convertSize(FlxU.random()) * Scale;
			
			var majorAxis:int = size * (1 + eccentricity * FlxU.random());
			var minorAxis:int = size * (1 - eccentricity * FlxU.random());
			
			var xAxis:int, yAxis:int, secAxes:Point;
			var leftCut:Point, rightCut:Point;
			if (FlxU.random() > 0.5) {
				xAxis = majorAxis;
				yAxis = minorAxis;
				leftCut = new Point(0, yAxis + 2);
				rightCut = new Point(0, -yAxis - 2);
				secAxes = new Point(xAxis / 2, yAxis);
			} else {
				xAxis = minorAxis;
				yAxis = majorAxis;
				leftCut = new Point(xAxis + 2, 0);
				rightCut = new Point(-xAxis - 2, 0);
				secAxes = new Point(xAxis, yAxis / 2);
			}
			
			mapBlocks = [];
			
			var sqxAxis:int = xAxis * xAxis;
			var sqyAxis:int = yAxis * yAxis;
			var secSqxs:Point = new Point(secAxes.x * secAxes.x, secAxes.y * secAxes.y);
			
			for (var x:int = -xAxis; x < xAxis; x++)
				for (var y:int = -yAxis; y < yAxis; y++) {
					var ellipticalDistance:Number = x * x / sqxAxis + y * y / sqyAxis;
					var leftDistance:Number = (x - leftCut.x) * (x - leftCut.x) / secSqxs.x + (y - leftCut.y) * (y - leftCut.y) / secSqxs.y;
					var rightDistance:Number = (x - rightCut.x) * (x - rightCut.x) / secSqxs.x + (y - rightCut.y) * (y - rightCut.y) / secSqxs.y;
					if (ellipticalDistance <= 1 && leftDistance > 1 && rightDistance > 1) //TODO: re-randomize
						mapBlocks.push(new MineralBlock(x + xAxis, y + yAxis, 5));
						
				}
			
			genMinerals();
			
			rawMap = new Terrain(mapBlocks, new Point(Math.floor(xAxis * 2 - 1), Math.floor(yAxis * 2 - 1)));
			fullMapSize = new Point(majorAxis + 15, majorAxis + 15);
		}
		
		protected function convertSize(sizeFraction:Number):int {
			return 16;
		}
		
		protected static const eccentricity:Number = 0.25;
		
	}

}