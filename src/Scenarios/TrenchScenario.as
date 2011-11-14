package Scenarios {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import Mining.BaseAsteroid;
	import Mining.MineralBlock;
	import Mining.Terrain;
	import Missions.TrenchMission;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	import Asteroids.TrenchSpawner;
	import Sminos.FoldingDrill;
	/**
	 * ...
	 * @author ...
	 */
	public class TrenchScenario extends DefaultScenario {
		
		protected var mission:TrenchMission;
		protected var mineralBackground:FlxSprite;
		public function TrenchScenario(Seed:Number = NaN) {
			super(Seed);
			
			mapBuffer = 0;
			bombs = 3;
			spawner = TrenchSpawner;
			miningTool = FoldingDrill;
			//bg_sprite = _bg;
			rotateable = false;
		}
		
		override public function create():void {
			prepPlanet();
			super.create();
		}
		
		override protected function createBG():void {
			super.createBG();
			
			//mineralBackground = new FlxSprite().createGraphic(mission.fullMapSize.x * C.BLOCK_SIZE * 2, mission.fullMapSize.y * C.BLOCK_SIZE * 2, 0xff454545);
			mineralBackground = new FlxSprite(0, 0, _bg);
			mineralBackground.x -= mineralBackground.width / 2;
			mineralBackground.y -= mineralBackground.height / 2;
			//randomly generate BG minerals...?
			minoLayer.add(mineralBackground); 
		}
		
		protected function prepPlanet():void {
			mission = new TrenchMission(seed);
			mapDim = mission.fullMapSize;
			C.log("Full Map Size: "+mission.fullMapSize.y);
		}
		
		override protected function createGCT(miningTime:Number = 50):void {
			super.createGCT(miningTime);
		}
		
		override protected function createStation():void {
			resourceSource = new BaseAsteroid( -1, -1, mission.rawMap.map, mission.rawMap.center);
			super.createStation();
			buildPlanet();
		}
		
		protected function buildPlanet():void {
			var planet:BaseAsteroid = resourceSource as BaseAsteroid;
			//shift planet
			station.core.gridLoc.y = mission.fullMapSize.y - 9;
			Mino.resetGrid();
			station.core.addToGrid();
			planet.gridLoc.x = Math.floor(-mission.fullMapSize.x/2);
			planet.gridLoc.y = Math.floor(-mission.fullMapSize.y/2) - 1;
			//erase overlapping planet blocks
			for (var i:int = 0; i < mission.rawMap.map.length; i++) {
				var aBlock:MineralBlock = mission.rawMap.map[i];
				var adjustedplanetBlock:Point = new Point(aBlock.x + planet.absoluteCenter.x,
															aBlock.y + planet.absoluteCenter.y);
				if (station.core.bounds.containsPoint(adjustedplanetBlock)) {
					mission.rawMap.map.splice(i, 1);
					i--;
				}
			}
			planet.forceSpriteReset();
			
			station.resourceSource = planet;
			initialMinerals = station.mineralsAvailable;
			
			minoLayer.add(planet);
			station.add(planet);
			Mino.all_minos.push(planet);
			planet.addToGrid();
		}
		
		override public function update():void {
			super.update();
			mineralBackground.offset.x = -C.B.drawShift.x;
			mineralBackground.offset.y = -C.B.drawShift.y;
		}
		
		[Embed(source = "../../lib/art/backgrounds/trench.png")] private static const _bg:Class;
	}

}