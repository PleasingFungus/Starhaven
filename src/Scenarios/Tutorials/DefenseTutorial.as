package Scenarios.Tutorials {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import Mining.*
	import org.flixel.*
	import Missions.LoadedMission;
	import Meteoroids.PlanetSpawner;
	import Scenarios.DefaultScenario;
	import GrabBags.BagType;
	import Sminos.AsteroidGun;
	import Sminos.SmallLauncher;
	import Sminos.SmallBarracks;
	import Sminos.Conduit;
	import InfoScreens.NewPlayerEvent;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class DefenseTutorial extends Scenarios.DefaultScenario {
		
		protected var mission:LoadedMission;
		public function DefenseTutorial() {
			super(NaN);
			
			mapBuffer = 20;
			victoryText = "Survived all waves!";
		}
		
		override public function create():void {
			prepPlanet();
			super.create();
			
			hud.goalName = "Survived";
			hud.updateGoal(0);
		}
		override protected function createGCT(_:Number = 0):void {
			super.createGCT(0);
		}
		
		override protected function createTracker(waveMeteos:Number = 2, WaveSpacing:int = 4):void {
			super.createTracker(waveMeteos, WaveSpacing);
		}
		
		protected function prepPlanet():void {
			mission = new LoadedMission(_mission_image);
			mapDim = mission.fullMapSize.add(new Point(15,15));
		}
		
		override protected function createStation():void {
			resourceSource = new BaseAsteroid( -1, -1, mission.rawMap.map, mission.rawMap.center);
			super.createStation();
			buildPlanet();
		}
	
		override protected function setupBags():void {
			if (C.BEAM_DEFENSE)
				BagType.all = [new BagType("Assorted Bag", 1, [makeBag(SmallBarracks), makeBag(AsteroidGun)])];
			else
				BagType.all = [new BagType("Assorted Bag", 1, [makeBag(SmallBarracks), makeBag(SmallLauncher)])];
		}
		
		protected function buildPlanet():void {
			var planet:BaseAsteroid = resourceSource as BaseAsteroid;
			//shift planet
			
			station.core.center.x += 3;
			station.core.center.y += 7;
			planet.gridLoc.x = -5;
			planet.gridLoc.y = 0;
			planet.forceSpriteReset();
			
			Mino.resetGrid();
			station.core.addToGrid();
			
			station.resourceSource = planet;
			initialMinerals = station.mineralsAvailable;
			
			minoLayer.add(planet);
			station.add(planet);
			Mino.all_minos.push(planet);
			planet.addToGrid();
		}
		
		
		
		
		private var seenIntro:Boolean;
		override protected function checkPlayerEvents():void {
			if (!seenIntro) {
				hudLayer.add(NewPlayerEvent.defenseTutorial());
				seenIntro = true;
			}
		}
		
		override protected function get goalPercent():int {
			var waveIndex:int = tracker.waveIndex;
			if (!tracker.safe)
				waveIndex -= 1;
			return waveIndex * 100 / TOTAL_WAVES;
		}
		
		protected const TOTAL_WAVES:int = 3;
		
		[Embed(source = "../../../lib/missions/tutorial_defense.png")] private static const _mission_image:Class;
	}

}