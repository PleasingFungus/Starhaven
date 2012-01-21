package Scenarios.Tutorials {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import Mining.*
	import Missions.LoadedMission;
	import org.flixel.*
	import Meteoroids.PlanetSpawner;
	import Scenarios.DefaultScenario;
	import GrabBags.BagType;
	import Sminos.*
	import InfoScreens.NewPlayerEvent;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class HousingTutorial extends Scenarios.DefaultScenario {
		
		public function HousingTutorial() {
			super(NaN);
			
			mapBuffer = 0;
			spawner = PlanetSpawner;
			goal = 0.6;
			bg_sprite = _bg;
			rotateable = false;
		}
		
		override protected function createMission():void {
			mission = new LoadedMission(_mission_image);
		}
		
		override protected function createTracker(_:Number = 0, __:int = 16):void {
			super.createTracker(0, 16);
		}
		
		override protected function createGCT(_:int):void {
			super.createGCT(0);
		}
		
		override protected function buildLevel():void {
			var planet:BaseAsteroid = new BaseAsteroid( -10, 0, mission.rawMap.map, mission.rawMap.center);
			station.core.center.x += 1;
			station.core.center.y -= 4;
			
			Mino.resetGrid();
			station.core.addToGrid();
			
			station.resourceSource = planet;
			station.mineralsMined = 600;
			initialMinerals = station.mineralsMined;
			
			var planet_bg:Mino = new Mino(planet.gridLoc.x, planet.gridLoc.y, mission.rawMap.map, mission.rawMap.center, 0xff303030);
			
			minoLayer.add(planet_bg);
			minoLayer.add(planet);
			station.add(planet);
			Mino.all_minos.push(planet);
			planet.addToGrid();
			
			addDrills();
		}
		
		protected function addDrills():void {
			addSmino(3-20,19-14, LongDrill);
			addSmino(9-20,18-14, LongDrill);
			addSmino(14 - 20, 19 - 14, LongDrill);
			addSmino(24 - 20, 19 - 14, LongDrill);
			addSmino(30-20,18-14, LongDrill);
			addSmino(36-20,17-14, LongDrill);

			addSmino(24 - 20, 18 - 14, LongConduit, FlxSprite.RIGHT);
			addSmino(27 - 20, 17 - 14, LongConduit, FlxSprite.RIGHT);
			addSmino(31 - 20, 17 - 14, LongConduit, FlxSprite.RIGHT);
			addSmino(34 - 20, 16 - 14, LongConduit, FlxSprite.RIGHT);

			addSmino(15 - 20, 18 - 14, LongConduit, FlxSprite.RIGHT);
			addSmino(12 - 20, 17 - 14, LongConduit, FlxSprite.RIGHT);
			addSmino(8 - 20, 17 - 14, LongConduit, FlxSprite.RIGHT);
			addSmino(5 - 20, 18 - 14, LongConduit, FlxSprite.RIGHT);
		}
		
		protected function addSmino(X:int, Y:int, minoType:Class, Facing:int = FlxSprite.DOWN):void {
			var smino:Smino = new minoType(X, Y);
			while (smino.facing != Facing)
				smino.rotateClockwise(true);
			smino.setTutorial(station);
			minoLayer.add(smino);
		}
		
		
		
		
		override protected function getAssortment(index:int):Array {
			if (C.BEAM_DEFENSE) {
				if (index)
					return [SmallBarracks, SmallBarracks, MediumLauncher, Conduit];
				return [SmallLauncher, SmallLauncher, MediumBarracks];
			} else {
				if (index)
					return [SmallBarracks, SmallBarracks, MediumLauncher];
				return [SmallLauncher, MediumBarracks, Conduit];
			}
		}
		
		
		private var seenIntro:Boolean;
		override protected function checkPlayerEvents():void {
			super.checkPlayerEvents();
			if (!seenIntro) {
				hudLayer.add(NewPlayerEvent.housingTutorial());
				seenIntro = true;
			}
		}
		
		[Embed(source = "../../../lib/missions/tutorial_housing.png")] private static const _mission_image:Class;
		[Embed(source = "../../../lib/art/backgrounds/planetside.png")] private static const _bg:Class;
	}

}