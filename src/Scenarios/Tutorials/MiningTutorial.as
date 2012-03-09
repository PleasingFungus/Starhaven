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
	import Scenarios.PlanetScenario;
	import Sminos.LongDrill;
	import Sminos.Conduit;
	import InfoScreens.NewPlayerEvent;
	import Mining.PlanetMaterial;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class MiningTutorial extends PlanetScenario {
		
		public function MiningTutorial() {
			super(NaN);
			
			mapBuffer = 0;
			spawner = PlanetSpawner;
			goalMultiplier = 0.5;
			rotateable = false;
		}
		
		override public function create():void {
			C.IN_TUTORIAL = true;
			super.create();
			
			hud.goalName = "Collected";
			hud.updateGoal(0);
		}
		
		override protected function createTracker(_:Number = 0):void {
			super.createTracker(0);
		}
		
		override protected function createGCT(_:int):void {
			super.createGCT(0);
		}
		
		override protected function createMission():void {
			mission = new LoadedMission(_mission_image);
		}
	
		override protected function setupBags():void {
			bagType = new BagType([LongDrill, Conduit, Conduit]);
			C.difficulty.bagSize = bagType.length;
		}
		
		override protected function buildLevel():void {
			var planet:PlanetMaterial = new PlanetMaterial( -10, 0, mission.rawMap.map, mission.rawMap.center);
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
			return station.mineralsMined * 100 / (initialMinerals * goalMultiplier);
		}
		
		override protected function checkEndConditions():void {
			super.checkEndConditions();
			if (!missionOver && insufficientMineralsRemain())
				beginEndgame();
		}
		
		protected function insufficientMineralsRemain():Boolean {
			var inField:int = station.mineralsAvailable;
			var mined:int = 0;
			for each (var mino:Mino in Mino.all_minos)
				if (mino.exists)
					mined += mino.storedMinerals;
			var goalMin:int = initialMinerals * goalMultiplier;
			return inField + mined < goalMin;
		}
		
		override protected function getEndText():String {
			if (won() || station.core.damaged)
				return super.getEndText();
			return "Insufficient minerals remain!";
		}
		
		[Embed(source = "../../../lib/missions/tutorial_mining.png")] private static const _mission_image:Class;
	}

}