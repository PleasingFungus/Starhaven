package Scenarios.Tutorials {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import Mining.*
	import org.flixel.*
	import Missions.LoadedMission;
	import Meteoroids.PlanetSpawner;
	import Meteoroids.EggSpawner;
	import Scenarios.DefaultScenario;
	import GrabBags.BagType;
	import Sminos.RocketGun;
	import Sminos.SmallLauncher;
	import Sminos.SmallBarracks;
	import Sminos.MediumLauncher;
	import Sminos.MediumBarracks;
	import Sminos.Conduit;
	import InfoScreens.NewPlayerEvent;
	import Scenarios.PlanetScenario;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class DefenseTutorial extends PlanetScenario {
		
		public function DefenseTutorial() {
			super(NaN);
			
			mapBuffer = 0;
			spawner = PlanetSpawner;
			victoryText = "Survived all waves!";
		}
		
		override public function create():void {
			C.IN_TUTORIAL = true;
			super.create();
			
			hud.goalName = "Survived";
			hud.updateGoal(0);
		}
		
		override protected function createGCT(_:int):void {
			super.createGCT(0);
		}
		
		override protected function createMission():void {
			mission = new LoadedMission(_mission_image_b);
		}
	
		override protected function setupBags():void {
			bagType = new BagType([makeBag(SmallBarracks), makeBag(RocketGun), makeBag(RocketGun)]);
			C.difficulty.bagSize = bagType.length;
		}
		
		override protected function buildLevel():void {
			var planet:PlanetMaterial  = new PlanetMaterial( -10, 0, mission.rawMap.map, mission.rawMap.center);
			station.core.center.x += 1;
			station.core.center.y -= 4;
			
			Mino.resetGrid();
			station.core.addToGrid();
			
			station.resourceSource = planet;
			initialMinerals = station.mineralsAvailable;
			
			minoLayer.add(new Mino(planet.gridLoc.x, planet.gridLoc.y, mission.rawMap.map, mission.rawMap.center, 0xff23170f));
			minoLayer.add(planet);
			station.add(planet);
			Mino.all_minos.push(planet);
			planet.addToGrid();
			
			mapDim = mission.fullMapSize;
		}
		
		
		
		
		private var seenIntro:Boolean;
		override protected function checkPlayerEvents():void {
			super.checkPlayerEvents();
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
		[Embed(source = "../../../lib/missions/tutorial_housing.png")] private static const _mission_image_b:Class;
	}

}