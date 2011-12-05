package Scenarios.Tutorials {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import Mining.BaseAsteroid;
	import Mining.MineralBlock;
	import Mining.Terrain;
	import Missions.LoadedMission;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	import Meteoroids.PlanetSpawner;
	import org.flixel.FlxG;
	import Scenarios.DefaultScenario;
	import GrabBags.BagType;
	import Sminos.LongDrill;
	import Sminos.Conduit;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class MiningTutorial extends Scenarios.DefaultScenario {
		
		protected var mission:LoadedMission;
		public function MiningTutorial() {
			super(NaN);
			
			mapBuffer = 0;
			spawner = PlanetSpawner;
			goal = 0.75;
			bg_sprite = _bg;
			rotateable = false;
		}
		
		override public function create():void {
			prepPlanet();
			super.create();
			
			tracker.active = false;
			hud.goalName = "Collected";
			hud.updateGoal(0);
		}
		override protected function createGCT(_:Number = 0):void {
			super.createGCT(0);
		}
		
		protected function prepPlanet():void {
			mission = new LoadedMission(_mission_image);
			mapDim = mission.fullMapSize;
			C.log("Full Map Size: "+mission.fullMapSize.y);
		}
		
		override protected function createStation():void {
			resourceSource = new BaseAsteroid( -1, -1, mission.rawMap.map, mission.rawMap.center);
			super.createStation();
			buildPlanet();
		}
	
		override protected function setupBags():void {
			BagType.all = [new BagType("Assorted Bag", 1, [LongDrill, Conduit, Conduit])];
		}
		
		override protected function get goalPercent():int {
			return station.mineralsMined * 100 / (initialMinerals * goal);
		}
		
		protected function buildPlanet():void {
			var planet:BaseAsteroid = resourceSource as BaseAsteroid;
			//shift planet
			
			station.core.center.x += 1;
			station.core.center.y -= 4;
			planet.gridLoc.x = -10;
			planet.gridLoc.y = 0;
			
			Mino.resetGrid();
			station.core.addToGrid();
			
			station.resourceSource = planet;
			initialMinerals = station.mineralsAvailable;
			
			var planet_bg:Mino = new Mino(planet.gridLoc.x, planet.gridLoc.y, mission.rawMap.map, mission.rawMap.center, 0xff303030);
			
			minoLayer.add(planet_bg);
			minoLayer.add(planet);
			station.add(planet);
			Mino.all_minos.push(planet);
			planet.addToGrid();
		}
		
		[Embed(source = "../../../lib/missions/tutorial_mining.png")] private static const _mission_image:Class;
		[Embed(source = "../../../lib/art/backgrounds/planetside.png")] private static const _bg:Class;
	}

}