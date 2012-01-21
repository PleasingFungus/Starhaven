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
	import Sminos.AsteroidGun;
	import Sminos.SmallLauncher;
	import Sminos.SmallBarracks;
	import Sminos.MediumLauncher;
	import Sminos.MediumBarracks;
	import Sminos.Conduit;
	import InfoScreens.NewPlayerEvent;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class DefenseTutorial extends Scenarios.DefaultScenario {
		
		public function DefenseTutorial() {
			super(NaN);
			
			mapBuffer = C.BEAM_DEFENSE ? 20 : 0;
			spawner = C.BEAM_DEFENSE ? EggSpawner : PlanetSpawner;
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
			mission = new LoadedMission(C.BEAM_DEFENSE ? _mission_image : _mission_image_b);
		}
	
		override protected function setupBags():void {
			if (C.BEAM_DEFENSE)
				BagType.all = [new BagType("Assorted Bag", 1, [makeBag(SmallBarracks), makeBag(AsteroidGun)])];
			else 
				super.setupBags();
		}
		
		override protected function getAssortment(index:int):Array {
			if (index)
				return [SmallBarracks, SmallBarracks, MediumLauncher];
			return [SmallLauncher, MediumBarracks, Conduit];
		}
		
		override protected function buildLevel():void {
			var planet:BaseAsteroid;
			if (C.BEAM_DEFENSE) {
				planet = new BaseAsteroid( -5, 0, mission.rawMap.map, mission.rawMap.center);
				station.core.center.x += 3;
				station.core.center.y += 7;
				planet.forceSpriteReset();
			} else {
				planet = new BaseAsteroid( -10, 0, mission.rawMap.map, mission.rawMap.center);
				station.core.center.x += 1;
				station.core.center.y -= 4;
			}
			
			Mino.resetGrid();
			station.core.addToGrid();
			
			station.resourceSource = planet;
			initialMinerals = station.mineralsAvailable;
			
			if (C.BEAM_DEFENSE)	
				minoLayer.add(new Mino(planet.gridLoc.x, planet.gridLoc.y, mission.rawMap.map, mission.rawMap.center, 0xff303030));

			
			minoLayer.add(planet);
			station.add(planet);
			Mino.all_minos.push(planet);
			planet.addToGrid();
			
			mapDim = C.BEAM_DEFENSE ? mission.fullMapSize.add(new Point(15,15)) : mission.fullMapSize;
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