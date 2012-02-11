package Scenarios {
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import InfoScreens.HelpState;
	import Mining.BaseAsteroid
	import Mining.MineralBlock;
	import Mining.Terrain;
	import Missions.AsteroidMission;
	import org.flixel.*;
	import Meteoroids.MeteoroidTracker;
	/**
	 * ...
	 * @author ...
	 */
	public class AsteroidScenario extends SpaceScenario {
		
		public function AsteroidScenario(Seed:Number = NaN) {
			super(Seed);
			
			goal = 0.75;
			missionType = AsteroidMission;
		}
		
		override protected function blockLimitToFullyMine():int {
			return 50;
		}
		
		override protected function repositionLevel():void {
			var closestLocation:Point = findClosestFreeSpot();
			
			station.core.gridLoc.x = closestLocation.x;
			station.core.gridLoc.y = closestLocation.y;
			station.centroidOffset.x = -closestLocation.x;
			station.centroidOffset.y = -closestLocation.y;
			
			//cleanMinerals();
		}
		
		protected function findClosestFreeSpot():Point {
			var bounds:Rectangle = new Rectangle(0, 0, mission.rawMap.mapDim.x, mission.rawMap.mapDim.y);
			
			var minoGrid:Array = new Array(bounds.height * bounds.width);
			for each (var block:Block in mission.rawMap.map)
				minoGrid[block.x + block.y * bounds.width] = true;
			
			var closest:Number = int.MAX_VALUE;
			var options:Array = [];
			for (var x:int = 0; x < bounds.width; x++)
				for (var y:int = 0; y < bounds.height; y++)
					if (!minoGrid[x + y * bounds.width]) {
						var dx:int = x - bounds.width / 2;
						var dy:int = y - bounds.height / 2;
						var dist:Number = dx * dx + dy * dy;
						if (dist <= closest)
							closest = dist;
					}
			
			
			for (x = 0; x < bounds.width; x++)
				for (y = 0; y < bounds.height; y++)
					if (!minoGrid[x + y * bounds.width]) {
						dx = x - bounds.width / 2;
						dy = y - bounds.height / 2;
						dist = dx * dx + dy * dy;
						if (dist <= closest)
							options.push(new Point(Math.floor(x - bounds.width / 2), Math.floor(y - bounds.height / 2)));
					}
			
			if (options.length)
				return options[Math.floor(FlxU.random() * options.length)];
			
			return new Point( -1, -1); //amusing, valid
		}
	}
	

}