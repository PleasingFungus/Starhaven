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
		
		protected var mission:LoadedMission;
		public function HousingTutorial() {
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
		}
		override protected function createGCT(_:Number = 0):void {
			super.createGCT(0);
		}
		
		protected function prepPlanet():void {
			mission = new LoadedMission(_mission_image);
			mapDim = mission.fullMapSize;
		}
		
		override protected function createStation():void {
			resourceSource = new BaseAsteroid( -1, -1, mission.rawMap.map, mission.rawMap.center);
			super.createStation();
			buildPlanet();
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
			addSmino(35 - 20, 17 - 14, LongConduit, FlxSprite.RIGHT);

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
			//var assortment:Array = [makeBag(SmallFab), makeBag(SmallBarracks)];
			//if (index)
				//assortment.push(makeBag(Fabricator));
			//else
				//assortment.push(makeBag(MediumBarracks));
			//return assortment;
			if (index)
				return [SmallBarracks, SmallBarracks, Fabricator, Conduit];
			return [SmallFab, SmallFab, MediumBarracks];
		}
		
		
		private var seenIntro:Boolean;
		override protected function checkPlayerEvents():void {
			if (!seenIntro) {
				hudLayer.add(NewPlayerEvent.housingTutorial());
				seenIntro = true;
			}
		}
		
		[Embed(source = "../../../lib/missions/tutorial_housing.png")] private static const _mission_image:Class;
		[Embed(source = "../../../lib/art/backgrounds/planetside.png")] private static const _bg:Class;
	}

}