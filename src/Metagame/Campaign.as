package Metagame {
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import org.flixel.*
	import Sminos.*;
	import Scenarios.*;
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
			
			statblock = new Statblock(0,0,0,0,0,0);
			
		}
		
		public function refresh():void {
			for each (var upgrade:Upgrade in upgrades)
				upgrade.used = false;
		}
		
		public function nextMission():Class {
			var allowedScenarios:Array = C.unlocks.allowedScenarios();
			do {
				var choice:Class = C.randomChoice(allowedScenarios);
			} while ((allowedScenarios.length > 1 && missionsRun.length > 0 && choice == missionsRun[missionsRun.length - 1]) ||
				   (allowedScenarios.length > 2 && missionsRun.length > 1 && choice == missionsRun[missionsRun.length - 2]));
			return choice;
		}
		
		public function chooseMission(mission:Class):void {
			missionsRun.push(mission);
		}
		
		public function winMission(missionStatblock:Statblock):void {
			takeScreenshot();
			//missionNo++; //handled in statblock.sum
			C.difficulty.increaseDifficulty();
			endMission(missionStatblock);
		}
		
		public function endMission(missionStatblock:Statblock):void {
			statblock.sum(missionStatblock);
			C.accomplishments.registerRecords(missionNo, statblock);
		}
		
		private function takeScreenshot():void {		
			var hudOn:Boolean = C.HUD_ENABLED;
			C.HUD_ENABLED = false;
			
			FlxG.state.render();
			var screenshot:BitmapData = new BitmapData(SCREENSHOT_SIZE.x, SCREENSHOT_SIZE.y);
			var scaleMatrix:Matrix = new Matrix();
			scaleMatrix.scale(SCREENSHOT_SIZE.x / FlxG.buffer.width, SCREENSHOT_SIZE.y / FlxG.buffer.height);
			screenshot.draw(FlxG.buffer, scaleMatrix);
			screenshots.push(screenshot);
			
			C.HUD_ENABLED = hudOn;
		}
		
		public function renderScreenshots(Y:int):FlxGroup {
			var ss_cols:int = 3;
			var ss_buffer:int = 15;
			var first_ss:int = Math.max(0, screenshots.length - 6);
			var ss_group:FlxGroup = new FlxGroup;
			
			C.log("Screenshots from " + first_ss + " to" + screenshots.length);
			for (var i:int = first_ss; i < screenshots.length; i++) {
				var ss:FlxSprite = new FlxSprite();
				
				var adjusted_i:int = i - first_ss;
				ss.x = (adjusted_i % ss_cols - ss_cols/2) * (SCREENSHOT_SIZE.x + ss_buffer) + FlxG.width / 2;
				ss.y = Math.floor(adjusted_i / ss_cols) * (SCREENSHOT_SIZE.y + ss_buffer) + Y + ss_buffer;
												 //120 is correct w/o play button
				ss.pixels = screenshots[i];
				ss.frame = 0;
				ss_group.add(ss);
			}
			
			return ss_group;
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
		
		public static const MISSION_ABORTED:int = 0;
		public static const MISSION_TIMEOUT:int = 1;
		public static const MISSION_MINEDOUT:int = 2;
		public static const MISSION_EXPLODED:int = 3;
		
		public static const SCREENSHOT_SIZE:Point = new Point(120, 120);
	}

}