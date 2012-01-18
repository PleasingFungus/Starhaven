package Scenarios {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import Mining.BaseAsteroid;
	import Mining.MineralBlock;
	import Mining.Terrain;
	import Missions.TrenchMission;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	import Sminos.FoldingDrill;
	import Meteoroids.PlanetSpawner;
	/**
	 * ...
	 * @author ...
	 */
	public class TrenchScenario extends DefaultScenario {
		
		protected var mineralBackground:FlxSprite;
		public function TrenchScenario(Seed:Number = NaN) {
			super(Seed);
			
			mapBuffer = 0;
			spawner = PlanetSpawner;
			missionType = TrenchMission;
			//miningTool = FoldingDrill;
			//bg_sprite = _bg;
			rotateable = false;
		}
		
		override protected function blockLimitToFullyMine():int {
			return 100;
		}
		
		override protected function repositionLevel():void {
			station.core.center.x = Math.round(mission.fullMapSize.x * 0.55 * (FlxU.random() > 0.5 ? -1 : 1));
			station.core.gridLoc.y = (mission as TrenchMission).atmosphere - mission.fullMapSize.y;
			
			rock.gridLoc.x = station.core.gridLoc.x;
			rock.gridLoc.y = Math.ceil((mission as TrenchMission).atmosphere / 2);
		}
		
		override protected function createBG():void {
			super.createBG();
			
			mineralBackground = new FlxSprite().createGraphic(mission.fullMapSize.x * 2 * C.BLOCK_SIZE,
															  (mission.fullMapSize.y * 2 - (mission as TrenchMission).atmosphere) * C.BLOCK_SIZE,
															  0xff454545);
			mineralBackground.x -= mineralBackground.width / 2;
			mineralBackground.y -= mineralBackground.height / 4;
			//randomly generate BG minerals...?
			minoLayer.add(mineralBackground); 
		}
		
		override public function update():void {
			super.update();
			mineralBackground.offset.x = -C.B.drawShift.x;
			mineralBackground.offset.y = -C.B.drawShift.y;
		};
	}

}