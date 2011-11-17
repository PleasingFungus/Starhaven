package Missions {
	import flash.geom.Rectangle;
	import org.flixel.FlxU;
	import Mining.MineralBlock;
	import Mining.Terrain;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class BeltMission extends Mission {
		
		public var belt:Array;
		public function BeltMission(Seed:Number) {
			super(Seed);
			
			rawMap = generateAsteroid(8 + FlxU.random() * 3, true);
			//var currentBounds:Rectangle = new Rectangle(int.MAX_VALUE, int.MAX_VALUE, int.MIN_VALUE, int.MIN_VALUE);
			//currentBounds = setDim(currentBounds, rawMap.mapDim, new Point);
			
			belt = new Array(C.difficulty.hard ? 2 : 1);
			//var angularDelta:Number = Math.PI * 2 / belt.length;
			//var thetaOff:Number = angularDelta * FlxU.random();
			var station_core_radius:int = 3;
			var R:Point = new Point(rawMap.mapDim.x / 2 + station_core_radius, rawMap.mapDim.y / 2 + station_core_radius);
			var lastAsteroid:Terrain = rawMap;
			for (var i:int = 0; i < belt.length; i++) {
				var newAsteroid:Terrain = generateAsteroid(8 + FlxU.random() * 2);
				
				var minDX:Number = newAsteroid.mapDim.x / 2;
				var dX:Number = minDX + 10 //+ 3 * FlxU.random();
				var minDY:Number = newAsteroid.mapDim.y / 2;
				var dY:Number = minDY + 10// + 3 * FlxU.random();
				if (i) {
					dX += 2;
					dY += 2;
				} else {
					C.log(R, dX, dY, rawMap.mapDim, newAsteroid.mapDim);
				}
				R.x += dX //+ minDX;
				R.y += dY// + minDY;
				
				//var theta:Number = angularDelta * i + thetaOff;
				var theta:Number = -Math.PI * 1 / 4 + FlxU.random() * Math.PI * 6 / 4;
				newAsteroid.center.x = -Math.floor(Math.cos(theta) * R.x);
				newAsteroid.center.y = -Math.floor(Math.sin(theta) * R.y);
				belt[i] = newAsteroid;
				C.log("Asteroid angle: " + theta/Math.PI, newAsteroid.center);
				//currentBounds = setDim(currentBounds, newAsteroid.mapDim, newAsteroid.center);
				
				if (i && i < belt.length - 1) {
					newAsteroid = generateAsteroid(8 + FlxU.random() * 2);
					theta += Math.floor(FlxU.random() * 4) * Math.PI / 2 + Math.PI / 4;
					while (theta > Math.PI * 2)
						theta -= Math.PI * 2;
					if (theta > Math.PI * 5 / 4 && theta < Math.PI * 7 / 4)
						theta += (Math.PI / 2) * Math.ceil(FlxU.random() * 3);
					newAsteroid.center.x = -Math.floor(Math.cos(theta) * R.x);
					newAsteroid.center.y = -Math.floor(Math.sin(theta) * R.y);
					C.log("Asteroid angle: " + theta/Math.PI, newAsteroid.center);
					
					i++
					belt[i] = newAsteroid;
				}
				
			}
			
			var Rm:int = Math.max(R.x, R.y);
			fullMapSize = new Point(Rm + 25, Rm + 25);
		}
		
		//private function setDim(currentBounds:Rectangle, mapDim:Point, offset:Point):Rectangle {
			//if (offset.x - mapDim.x / 2 < currentBounds.left)
				//currentBounds.x = offset.x - mapDim.x;
			//if (offset.y - mapDim.y < currentBounds.top)
				//currentBounds.y = offset.y - mapDim.y;
			//if (offset.x + mapDim.x > currentBounds.right)
				//currentBounds.width = offset.x + mapDim.x - currentBounds.x;
			//if (offset.y + mapDim.y > currentBounds.bottom)
				//currentBounds.height = offset.y + mapDim.y - currentBounds.y;
			//return currentBounds;
		//}
		
		private function generateAsteroid(size:Number, poor:Boolean = false):Terrain {
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
						mapBlocks.push(new MineralBlock(x + iAxis, y + jAxis));
				}
			
			var largeClusters:int = Math.ceil(size / 6);
			var smallClusters:int = Math.ceil(size / 4);
			
			for (var i:int = 0; i < largeClusters; i++)
				genCluster(3, poor ? MineralBlock.PURPLE_MINERALS : FlxU.random() < 1/3 ? MineralBlock.ORANGE_MINERALS : MineralBlock.PURPLE_MINERALS);
			for (i = 0; i < smallClusters; i++)
				genCluster(2, poor ? MineralBlock.PURPLE_MINERALS : -1);
			genNoise();
			
			return new Terrain(mapBlocks, new Point(iAxis * 2 - 1, jAxis * 2 - 1));
		}
		
		protected static const eccentricity:Number = 0.25;
	}

}