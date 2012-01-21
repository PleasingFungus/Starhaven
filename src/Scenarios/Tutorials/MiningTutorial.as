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
	import InfoScreens.NewPlayerEvent;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class MiningTutorial extends Scenarios.DefaultScenario {
		
		public function MiningTutorial() {
			super(NaN);
			
			mapBuffer = 0;
			spawner = PlanetSpawner;
			goal = 0.75;
			bg_sprite = _bg;
			rotateable = false;
		}
		
		override public function create():void {
			super.create();
			
			hud.goalName = "Collected";
			hud.updateGoal(0);
		}
		
		override protected function createTracker(_:Number = 0, __:int = 16):void {
			super.createTracker(0, 16);
		}
		
		override protected function createGCT(_:int):void {
			super.createGCT(0);
		}
		
		override protected function createMission():void {
			mission = new LoadedMission(_mission_image);
		}
	
		override protected function setupBags():void {
			BagType.all = [new BagType("Assorted Bag", 1, [LongDrill, Conduit, Conduit])];
		}
		
		override protected function buildLevel():void {
			var planet:BaseAsteroid = new BaseAsteroid( -10, 0, mission.rawMap.map, mission.rawMap.center);
			station.core.center.x += 1;
			station.core.center.y -= 4;
			
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
		
		
		
		
		private var seenIntro:Boolean;
		override protected function checkPlayerEvents():void {
			super.checkPlayerEvents();
			if (!seenIntro) {
				hudLayer.add(NewPlayerEvent.miningTutorial());
				seenIntro = true;
			}
		}
		
		override protected function get goalPercent():int {
			return station.mineralsMined * 100 / (initialMinerals * goal);
		}
		
		[Embed(source = "../../../lib/missions/tutorial_mining.png")] private static const _mission_image:Class;
		[Embed(source = "../../../lib/art/backgrounds/planetside.png")] private static const _bg:Class;
	}

}