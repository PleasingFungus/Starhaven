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
		
		protected var mission:AsteroidMission;
		public function AsteroidScenario(Seed:Number = NaN) {
			super(Seed);
			
			if (C.difficulty.hard) {
				goal = 0.75;
				bombs = 3;
			}
			bg_sprites = _bgs;
			mapBuffer = 20;
		}
		
		override public function create():void {
			prepAsteroid();
			super.create();
		}
		
		protected function prepAsteroid():void {
			mission = new AsteroidMission(seed);
			mapDim = mission.fullMapSize;
			C.log("Full Map Size: "+mission.fullMapSize);
		}
		
		override protected function createGCT(miningTime:Number = 55):void {
			super.createGCT(miningTime);
		}
		
		override protected function createStation():void {
			resourceSource = new BaseAsteroid( -1, -1, mission.rawMap.map, mission.rawMap.center);
			super.createStation();
			buildAsteroid();
		}
		
		protected function buildAsteroid():void {
			var asteroid:BaseAsteroid = resourceSource as BaseAsteroid;
			var closestLocation:Point = findClosestFreeSpot();
			//shift asteroid
			//asteroid.gridLoc.x = station.core.gridLoc.x - closestLocation.x;
			//asteroid.gridLoc.y = station.core.gridLoc.y - closestLocation.y;
			station.core.gridLoc.x = closestLocation.x;
			station.core.gridLoc.y = closestLocation.y;
			station.centroidOffset.x = -closestLocation.x;
			station.centroidOffset.y = -closestLocation.y;
			//erase overlapping asteroid blocks
			for (var i:int = 0; i < mission.rawMap.map.length; i++) {
				var aBlock:MineralBlock = mission.rawMap.map[i];
				var adjustedAsteroidBlock:Point = new Point(aBlock.x + asteroid.absoluteCenter.x,
															aBlock.y + asteroid.absoluteCenter.y);
				if (station.core.bounds.containsPoint(adjustedAsteroidBlock)) {
					mission.rawMap.map.splice(i, 1);
					i--;
				}
			}
			asteroid.forceSpriteReset();
			
			station.add(asteroid);
			station.resourceSource = asteroid;
			initialMinerals = station.mineralsAvailable;
			
			minoLayer.add(asteroid);
			Mino.all_minos.push(asteroid);
			asteroid.addToGrid();
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