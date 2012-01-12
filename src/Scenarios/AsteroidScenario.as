package Scenarios {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import Mining.BaseAsteroid
	import Mining.MineralBlock;
	import Mining.Terrain;
	import Missions.AsteroidMission;
	import org.flixel.FlxU;
	import Meteoroids.MeteoroidTracker;
	import org.flixel.FlxU;
	/**
	 * ...
	 * @author ...
	 */
	public class AsteroidScenario extends DefaultScenario {
		
		public function AsteroidScenario(Seed:Number = NaN) {
			super(Seed);
			
			goal = 0.75;
			bg_sprites = _bgs;
			mapBuffer = 20;
			missionType = AsteroidMission;
		}
		
		override protected function blockLimitToFullyMine():int {
			return 80;
		}
		
		override protected function repositionLevel():void {
			var closestLocation:Point = findClosestFreeSpot();
			
			station.core.gridLoc.x = closestLocation.x;
			station.core.gridLoc.y = closestLocation.y;
			station.centroidOffset.x = -closestLocation.x;
			station.centroidOffset.y = -closestLocation.y;
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
		
		
		[Embed(source = "../../lib/art/backgrounds/garradd_3.jpg")] private static const _bg1:Class;
		[Embed(source = "../../lib/art/backgrounds/garradd_4.jpg")] private static const _bg2:Class;
		[Embed(source = "../../lib/art/backgrounds/garradd_5.jpg")] private static const _bg3:Class;
		[Embed(source = "../../lib/art/backgrounds/garradd_6.jpg")] private static const _bg4:Class;
		[Embed(source = "../../lib/art/backgrounds/garradd_7.jpg")] private static const _bg5:Class;
		private static const _bgs:Array = [_bg1, _bg2, _bg3, _bg4, _bg5];
	}
	

}