package Scenarios {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import Mining.BaseAsteroid
	import Mining.MineralBlock;
	import Mining.Terrain;
	import Missions.ShipMission;
	import org.flixel.FlxU;
	import Asteroids.AsteroidTracker;
	import org.flixel.FlxU;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class ShipScenario extends DefaultScenario {
		
		protected var mission:ShipMission;
		public function ShipScenario(Seed:Number = NaN) {
			super(Seed);
		}
		
		override public function create():void {
			prepStation();
			super.create();
		}
		
		protected function prepStation():void {
			mission = new ShipMission(seed);
			mapDim = mission.fullMapSize;
		}
		
		override protected function createGCT(miningTime:Number = 65):void {
			super.createGCT(miningTime);
		}
		
		override protected function createStation():void {
			resourceSource = new BaseAsteroid(0,0, mission.rawMap.map, mission.rawMap.center);
			super.createStation();
			buildstation();
		}
		
		protected function buildstation():void {
			var derelict:BaseAsteroid = resourceSource as BaseAsteroid;
			//shift station
			var Y:int = mission.rawMap.mapDim.y;
			station.core.gridLoc.y -= Math.floor(Y / 2);
			station.centroidOffset.y += Math.floor(Y / 2);
			//erase overlapping station blocks
			for (var i:int = 0; i < mission.rawMap.map.length; i++) {
				var aBlock:MineralBlock = mission.rawMap.map[i];
				var adjustedstationBlock:Point = new Point(aBlock.x + derelict.absoluteCenter.x,
															aBlock.y + derelict.absoluteCenter.y);
				if (station.core.bounds.containsPoint(adjustedstationBlock)) {
					mission.rawMap.map.splice(i, 1);
					i--;
				}
			}
			derelict.forceSpriteReset();
			
			station.add(derelict);
			station.resourceSource = derelict;
			initialMinerals = station.mineralsAvailable;
			
			minoLayer.add(derelict);
			Mino.all_minos.push(derelict);
			derelict.addToGrid();
		}
		
	}

}