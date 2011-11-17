package HUDs {
	import Meteoroids.MeteoroidTracker;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class HUD extends FlxGroup {
		private var minimap:Minimap;
		
		private var mineralText:HUDText;
		private var lifeText:FlxText;
		private var bombText:FlxText;
		
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
			
			minimap = new Minimap(0, 0, station);
			add(minimap);
			
			mineralText = new HUDText(5, 220, 100).loadIcon(C.ICONS[C.MINERALS]);
			lifeText = new HUDText(FlxG.width - 90, 20, 85, "TIME: 0:00");
			bombText = new HUDText(FlxG.width - 90, 90, 85, "BOMBS: ");
			
			if (C.DEBUG) {
				add(mineralText);
				add(lifeText);
				add(bombText);
			}
			
			var hbarheight:int = 22;
			var HUDBar:FlxSprite = new FlxSprite(0, FlxG.height - hbarheight).createGraphic(FlxG.width, hbarheight, 0xff000000);
			HUDBar.alpha = 0.4;
			add(HUDBar);
			
			goalText = new HUDText(10, FlxG.height - 18, 160, "Goal: 0%");
			goalText.color = 0xffd000;
			blockText = new HUDText(FlxG.width / 2, FlxG.height - 18, 160);
			trackerText = new HUDText(FlxG.width - 170, FlxG.height - 18, 160);
			trackerText.color = 0xdf0000;
			trackerText.alignment = "right";
			
			add(goalText);
			add(blockText);
			add(trackerText);
		}
		
		public function updateBombs(bombs:int):void {
			if (bombs >= 0)
				bombText.text = "BOMBS: " + bombs;
			else
				bombText.visible = false;
		}
		
		public function updateGoal(percent:int):void {
			goalText.text = "Goal: "+percent + "%";
		}
		
		override public function update():void {
			
			mineralText.text = station.mineralsMined + " ORE";
			mineralText.text += "\n" + station.mineralsLaunched + " SENT";
			mineralText.text += "\n"+station.mineralsAvailable+" LEFT";
			mineralText.text += "\n"+goal+" GOAL";
			
			lifeText.text = "TIME: " + C.renderTime(station.lifespan);
			
			blockText.text = "Blocks: " + GlobalCycleTimer.minosDropped + "/" + GlobalCycleTimer.miningTime;
			blockText.x = FlxG.width / 2 - blockText.textWidth / 2;
			
			trackerText.text = tracker.dangerText;
			
			super.update();
		}
	}

}