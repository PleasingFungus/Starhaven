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
		
		public function DefenseTutorial() {
			super(NaN);
			
			mapBuffer = 20;
			victoryText = "Survived all waves!";
		}
		
		override public function create():void {
			super.create();
			
			hud.goalName = "Survived";
			hud.updateGoal(0);
		}
		
		override protected function createGCT(_:int):void {
			super.createGCT(0);
		}
		
		override protected function createTracker(waveMeteos:Number = 2, WaveSpacing:int = 4):void {
			super.createTracker(waveMeteos, WaveSpacing);
		}
		
		override protected function createMission():void {
			mission = new LoadedMission(_mission_image);
		}
	
		override protected function setupBags():void {
			if (C.BEAM_DEFENSE)
				BagType.all = [new BagType("Assorted Bag", 1, [makeBag(SmallBarracks), makeBag(AsteroidGun)])];
			else
				BagType.all = [new BagType("Assorted Bag", 1, [makeBag(SmallBarracks), makeBag(SmallLauncher)])];
		}
		
		override protected function buildLevel():void {
			var planet:BaseAsteroid = new BaseAsteroid( -5, 0, mission.rawMap.map, mission.rawMap.center);
			station.core.center.x += 3;
			station.core.center.y += 7;
			planet.forceSpriteReset();
			
			Mino.resetGrid();
			station.core.addToGrid();
			
			station.resourceSource = planet;
			initialMinerals = station.mineralsAvailable;
			
			minoLayer.add(planet);
			station.add(planet);
			Mino.all_minos.push(planet);
			planet.addToGrid();
			
			mapDim = mission.fullMapSize.add(new Point(15,15));
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