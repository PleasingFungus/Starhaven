package Scenarios {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import Mining.BaseAsteroid;
	import Mining.MineralBlock;
	import Mining.Terrain;
	import Mining.Water;
	import Missions.WaterMission;
	import org.flixel.FlxU;
	import Meteoroids.PlanetSpawner;
	import Sminos.Scoop;
	import GrabBags.BagType;
	import Sminos.SmallBarracks;
	import Sminos.SmallFab;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class WaterScenario extends DefaultScenario {
		
		protected var mission:WaterMission;
		public function WaterScenario(Seed:Number = NaN) {
			super(Seed);
			
			mapBuffer = 0;
			bombs = 3;
			miningTool = Scoop;
			spawner = PlanetSpawner;
			bg_sprite = _bg;
			rotateable = false;
		}
		
		override public function create():void {
			prepPlanet();
			super.create();
		}
		
		protected function prepPlanet():void {
			mission = new WaterMission(seed);
			mapDim = mission.fullMapSize;
			C.log("Full Map Size: "+mission.fullMapSize.y);
		}
		
		override protected function createGCT(miningTime:Number = 60):void {
			super.createGCT(miningTime);
		}
		
		override protected function createBG():void {
			super.createBG();
		}
		
		override protected function createStation():void {
			resourceSource = new BaseAsteroid( -1, -1, mission.rawMap.map, mission.rawMap.center);
			super.createStation();
			buildPlanet();
		}
		
		protected function buildPlanet():void {
			var planet:BaseAsteroid = resourceSource as BaseAsteroid;
			//shift planet
			station.core.gridLoc.y = WaterMission.atmosphere - mission.fullMapSize.y - 3;
			Mino.resetGrid();
			station.core.addToGrid();
			planet.gridLoc.x = station.core.gridLoc.x;
			planet.gridLoc.y = Math.ceil(WaterMission.atmosphere / 2);
			//erase overlapping planet blocks
			for (var i:int = 0; i < mission.rawMap.map.length; i++) {
				var aBlock:MineralBlock = mission.rawMap.map[i];
				var adjustedplanetBlock:Point = new Point(aBlock.x + planet.absoluteCenter.x,
															aBlock.y + planet.absoluteCenter.y);
				if (station.core.bounds.containsPoint(adjustedplanetBlock)) {
					mission.rawMap.map.splice(i, 1);
					i--;
				}
			}
			planet.forceSpriteReset();
			
			station.resourceSource = planet;
			initialMinerals = station.mineralsAvailable;
			
			minoLayer.add(planet);
			station.add(planet);
			Mino.all_minos.push(planet);
			planet.addToGrid();
			
			minoLayer.members.splice(0, 0, new Water());
		}
		
		protected var conduits:int;
		override protected function getAssortment():Array {
			var assortment:Array = super.getAssortment();
			conduits++;
			//if (conduits < 
			assortment.push(new BagType(null, 1, [SmallBarracks, SmallFab]));
			return assortment;
		}
		
		[Embed(source = "../../lib/art/backgrounds/planetside.png")] private static const _bg:Class;
		
	}

}