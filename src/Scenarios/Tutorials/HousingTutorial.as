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
			
			addSminos();
		}
		
		protected function addSminos():void {
			for each (var smino:Smino in (mission as LoadedMission).loadPieces(_mission_image))
			{
				smino.stealthAnchor(station);
				Mino.layer.add(smino);
				Mino.all_minos.push(smino);
			}
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
		
		override protected function shouldZoomOut():Boolean
		{
			return true;
		}
		
		[Embed(source = "../../../lib/missions/tutorial_housing.png")] private static const _mission_image:Class;
	}

}