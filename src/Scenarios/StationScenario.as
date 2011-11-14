package Scenarios {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import Mining.BaseAsteroid
	import Mining.MineralBlock;
	import Mining.Terrain;
	import Missions.StationMission;
	import org.flixel.FlxU;
	import Asteroids.AsteroidTracker;
	import org.flixel.FlxU;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class StationScenario extends DefaultScenario {
		
		protected var seed:Number;
		protected var mission:StationMission;
		public function StationScenario(Seed:Number = NaN) {
			super();
			seed = Seed;
		}
		
		override public function create():void {
			prepStation();
			super.create();
		}
		
		protected function prepStation():void {
			mission = new StationMission(seed);
			mapDim = mission.fullMapSize;
			C.log("Full Map Size: "+mission.fullMapSize);
		}
		
		override protected function createGCT(miningTime:Number = 65):void {
			super.createGCT(miningTime);
		}
		
		override protected function createStation():void {
			resourceSource = new BaseAsteroid( -1, -1, mission.rawMap.map, mission.rawMap.center);
			super.createStation();
			buildstation();
		}
		
		protected function buildstation():void {
			var derelictStation:BaseAsteroid = resourceSource as BaseAsteroid;
			var closestLocation:Point = findClosestFreeSpot();
			//shift station
			derelictStation.gridLoc.x = station.core.gridLoc.x - closestLocation.x;
			derelictStation.gridLoc.y = station.core.gridLoc.y - closestLocation.y;
			//erase overlapping station blocks
			for (var i:int = 0; i < mission.rawMap.map.length; i++) {
				var aBlock:MineralBlock = mission.rawMap.map[i];
				var adjustedstationBlock:Point = new Point(aBlock.x + derelictStation.absoluteCenter.x,
															aBlock.y + derelictStation.absoluteCenter.y);
				if (station.core.bounds.containsPoint(adjustedstationBlock)) {
					mission.rawMap.map.splice(i, 1);
					i--;
				}
			}
			derelictStation.forceSpriteReset();
			
			station.add(derelictStation);
			station.resourceSource = derelictStation;
			initialMinerals = station.mineralsAvailable;
			
			minoLayer.add(derelictStation);
			Mino.all_minos.push(derelictStation);
			derelictStation.addToGrid();
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
							options.push(new Point(x - bounds.width / 2, y - bounds.height / 2));
					}
			
			if (options.length)
				return options[Math.floor(FlxU.random() * options.length)];
			
			return new Point( -1, -1); //amusing, valid
		}
		
	}

}