package Scenarios.Tutorials {
	import Editor.StationLoader;
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
	import Scenarios.PlanetScenario;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class HousingTutorial extends PlanetScenario {
		
		public function HousingTutorial() {
			super(NaN);
			
			goalMultiplier = 1;
			buildMusic = C.music.TUT_MUSIC;
		}
		
		override public function create():void {
			C.IN_TUTORIAL = true;
			super.create();
		}
		
		override protected function createMission():void {
			mission = new LoadedMission(_mission_image);
		}
		
		override protected function createTracker(_:Number = 0):void {
			super.createTracker(0);
		}
		
		override protected function createGCT(_:int):void {
			super.createGCT(0);
		}
		
		override protected function buildLevel():void {
			var planet:PlanetMaterial = new PlanetMaterial( -10, 0, mission.rawMap.map, mission.rawMap.center);
			station.core.center.x += 1;
			station.core.center.y -= 4;
			
			Mino.resetGrid();
			station.core.addToGrid();
			
			station.resourceSource = planet;
			station.mineralsMined = 400;
			initialMinerals = station.mineralsMined;
			
			var planet_bg:Mino = new Mino(planet.gridLoc.x, planet.gridLoc.y, mission.rawMap.map, mission.rawMap.center, 0xff23170f);
			
			minoLayer.add(planet_bg);
			minoLayer.add(planet);
			station.add(planet);
			Mino.all_minos.push(planet);
			planet.addToGrid();
			
			addDrills();
		}
		
		protected function addDrills():void {
			new StationLoader(station, ["Long Drill,4,6,3", "Long Drill,10,4,3", "Long Drill,16,3,3", "Long Drill,-6,5,3", "Long Drill,-11,4,3", "Long Drill,-17,5,3", "Long-Conduit,3,5,0", "Long-Conduit,6,4,0", "Long-Conduit,9,3,0", "Long-Conduit,12,2,0", "Long-Conduit,16,2,0", "Long-Conduit,-6,4,0", "Long-Conduit,-9,3,0", "Long-Conduit,-13,3,0", "Long-Conduit,-16,4,0"]);
		}
		
		protected function addSmino(X:int, Y:int, minoType:Class, Facing:int = FlxSprite.DOWN):void {
			var smino:Smino = new minoType(X, Y);
			while (smino.facing != Facing)
				smino.rotateClockwise(true);
			smino.stealthAnchor(station);
			minoLayer.add(smino);
		}
		
		
		
		
		override protected function getAssortment(index:int):Array {
			if (index)
				return [SmallBarracks, SmallBarracks, MediumLauncher, Conduit];
			return [SmallLauncher, SmallLauncher, MediumBarracks, Conduit];
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
	}

}