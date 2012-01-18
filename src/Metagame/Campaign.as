package Metagame {
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import Sminos.*;
	import Scenarios.*;
	import org.flixel.FlxG;
	import org.flixel.FlxU;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class Campaign {
		
		public var missionNo:int;
		public var statblock:Statblock;
		public var upgrades:Array;
		public var screenshots:Array;
		public var missionsRun:Array;
		
		public function Campaign() {
			upgrades = [/*new Upgrade(SmallBarracks, LargeBarracks),
						new Upgrade(SmallLauncher, LargeFactory),
						new Upgrade(Conduit, SecondaryReactor) */ ];
			missionNo = 0;
			screenshots = [];
			missionsRun = [];
			
			statblock = new Statblock(0,0,0,0);
		}
		
		public function refresh():void {
			for each (var upgrade:Upgrade in upgrades)
				upgrade.used = false;
		}
		
		public function nextMission():Class {
			var choice:Class = SCENARIO_TYPES[int(FlxU.random() * SCENARIO_TYPES.length)];
			while ((missionsRun.length && choice == missionsRun[missionsRun.length - 1]) ||
				   (missionsRun.length > 1 && choice == missionsRun[missionsRun.length-2]))
				choice = SCENARIO_TYPES[int(FlxU.random() * SCENARIO_TYPES.length)];
			return choice;
		}
		
		public function chooseMission(mission:Class):void {
			missionsRun.push(mission);
		}
		
		public function winMission(missionStatblock:Statblock):void {
			takeScreenshot();
			missionNo++;
			endMission(missionStatblock);
		}
		
		public function endMission(missionStatblock:Statblock):void {
			statblock.sum(missionStatblock);
		}
		
		private function takeScreenshot():void {		
			var hudOn:Boolean = C.HUD_ENABLED;
			C.HUD_ENABLED = false;
			
			FlxG.state.render();
			var screenshot:BitmapData = new BitmapData(SCREENSHOT_SIZE.x, SCREENSHOT_SIZE.y);
			var scaleMatrix:Matrix = new Matrix();
			scaleMatrix.scale(SCREENSHOT_SIZE.x / FlxG.buffer.width, SCREENSHOT_SIZE.y / FlxG.buffer.height);
			screenshot.draw(FlxG.buffer, scaleMatrix);
			screenshots[missionNo] = screenshot;
			
			C.HUD_ENABLED = hudOn;
		}
		
		public function upgradeFor(original:Class):Upgrade {
			for each (var upgrade:Upgrade in upgrades)
				if (!upgrade.used && upgrade.original == original)
					return upgrade;
			return null;
		}
		
		public function die():void {
			for each (var screenshot:BitmapData in screenshots)
				screenshot.dispose();
		}
		
		protected const SCENARIO_TYPES:Array = [PlanetScenario, AsteroidScenario,
												WaterScenario, NebulaScenario,
												ShoreScenario, DustScenario];
		
		public static const MISSION_ABORTED:int = 0;
		public static const MISSION_TIMEOUT:int = 1;
		public static const MISSION_MINEDOUT:int = 2;
		public static const MISSION_EXPLODED:int = 3;
		
		public static const SCREENSHOT_SIZE:Point = new Point(120, 120);
	}

}