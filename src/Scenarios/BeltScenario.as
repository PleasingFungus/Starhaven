package Scenarios {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import Mining.BaseAsteroid
	import Mining.MetaResource;
	import Mining.MineralBlock;
	import Mining.Terrain;
	import Missions.BeltMission;
	import org.flixel.FlxU;
	import Meteoroids.MeteoroidTracker;
	import org.flixel.FlxU;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class BeltScenario extends DefaultScenario {
		
		protected var mission:BeltMission;
		public function BeltScenario(Seed:Number = NaN) {
			super(Seed);
			mapBuffer = 20;
			//goal = C.difficulty.hard ? 0.75 : 0.6;
		}
		override public function create():void {
			prepAsteroid();
			super.create();
		}
		
		protected function prepAsteroid():void {
			mission = new BeltMission(seed);
			mapDim = mission.fullMapSize;
			C.log("Full Map Size: "+mission.fullMapSize);
		}
		
		override protected function createGCT(miningTime:Number = 90):void {
			if (C.difficulty.normal)
				miningTime = 60; //will be multiplied after this
			super.createGCT(miningTime);
		}
		
		override protected function createStation():void {
			resourceSource = new MetaResource([]);
			super.createStation();
			buildAsteroid();
		}
		
		protected function buildAsteroid():void {
			var asteroid:BaseAsteroid = new BaseAsteroid(0,0, mission.rawMap.map, mission.rawMap.center);
			//shift asteroid
			//var closestLocation:Point = findClosestFreeSpot();s
			//asteroid.gridLoc.x = station.core.gridLoc.x - closestLocation.x;
			//asteroid.gridLoc.y = station.core.gridLoc.y - closestLocation.y;
			var Y:int = mission.rawMap.mapDim.y;
			//station.core.center.y += Math.floor(Y / 2); //this breaks things!
			station.core.gridLoc.y -= Math.floor(Y / 2);
			station.centroidOffset.y += Math.floor(Y / 2);
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
			(resourceSource as MetaResource).members.push(asteroid);
			station.resourceSource = resourceSource;
			
			minoLayer.add(asteroid);
			Mino.all_minos.push(asteroid);
			asteroid.addToGrid();
			
			for each (var rawAsteroid:Terrain in mission.belt) {
				asteroid = new BaseAsteroid(0, 0, rawAsteroid.map, rawAsteroid.center);
				new Aggregate(asteroid);
				(resourceSource as MetaResource).members.push(asteroid);
				//station.add(asteroid);
				
				minoLayer.add(asteroid);
				Mino.all_minos.push(asteroid);
				asteroid.addToGrid();
			}
			
			initialMinerals = station.mineralsAvailable;
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