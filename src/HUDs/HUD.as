package HUDs {
	import Meteoroids.MeteoroidTracker;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class HUD extends FlxGroup {
		//private var minimap:Minimap;
		
		private var mineralText:HUDText;
		private var lifeText:FlxText;
		public var goalName:String = "Launched";
		
		private var trackerText:FlxText;
		private var blockText:FlxText;
		private var goalText:FlxText;
		
		private var station:Station;
		private var goal:int;
		private var tracker:MeteoroidTracker;
		public function HUD(station:Station, goalFraction:Number, tracker:MeteoroidTracker) {
			super();
			
			this.station = station;
			goal = goalFraction * station.mineralsAvailable;
			this.tracker = tracker;
			
			//minimap = new Minimap(0, 0, station);
			//add(minimap);
			
			mineralText = new HUDText(5, 220, 100).loadIcon(C.ICONS[C.MINERALS]);
			lifeText = new HUDText(FlxG.width - 90, 20, 85, "TIME: 0:00");
			
			if (C.DEBUG) {
				add(mineralText);
				add(lifeText);
			}
			
			var hbarheight:int = 22;
			var HUDBar:FlxSprite = new FlxSprite(0, FlxG.height - hbarheight).createGraphic(FlxG.width, hbarheight, 0xff000000);
			HUDBar.alpha = 0.4;
			add(HUDBar);
			
			goalText = new HUDText(10, FlxG.height - 18, 160, goalName+": 0%", C.ICONS[C.MINERALS]);
			goalText.color = 0xffd000;
			trackerText = new HUDText(FlxG.width - 190, FlxG.height - 18, 170, " ", C.ICONS[C.METEOROIDS]);
			trackerText.color = 0xdf0000;
			trackerText.alignment = "right";
			
			add(goalText);
			add(trackerText);
			
			if (GlobalCycleTimer.miningTime) {				
				blockText = new HUDText(FlxG.width / 2, FlxG.height - 18, 160, " ", C.ICONS[C.MINOS]);
				add(blockText);
			}
		}
		
		public function updateGoal(percent:int):void {
			goalText.text = goalName+": "+percent + "%";
		}
		
		override public function update():void {
			
			mineralText.text = station.mineralsMined + " ORE";
			mineralText.text += "\n" + station.mineralsLaunched + " SENT";
			mineralText.text += "\n"+station.mineralsAvailable+" LEFT";
			mineralText.text += "\n"+goal+" GOAL";
			
			lifeText.text = "TIME: " + C.renderTime(station.lifespan);
			
			if (blockText) {
				blockText.text = "Limit: " + GlobalCycleTimer.minosDropped + "/" + GlobalCycleTimer.miningTime;
				blockText.x = FlxG.width / 2 - blockText.textWidth / 2;
			}
			
			trackerText.text = tracker.dangerText/* + " ("+tracker.density+")"*/;
			
			super.update();
		}
	}

}