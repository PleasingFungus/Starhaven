package HUDs {
	import org.flixel.*;
	import Asteroids.AsteroidTracker;
	
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class HUD extends FlxGroup {
		
		private var mineralText:HUDText;
		private var lifeText:FlxText;
		private var bombText:FlxText;
		private var trackerText:FlxText;
		
		private var station:Station;
		private var goal:int;
		private var tracker:AsteroidTracker;
		public function HUD(station:Station, goalFraction:Number, tracker:AsteroidTracker) {
			super();
			
			this.station = station;
			goal = goalFraction * station.mineralsAvailable;
			this.tracker = tracker;
			
			mineralText = new HUDText(5, 220, 100).loadIcon(C.ICONS[C.MINERALS]);
			add(mineralText);
			
			lifeText = new HUDText(FlxG.width - 90, 20, 85, "TIME: 0:00");
			bombText = new HUDText(FlxG.width - 90, 90, 85, "BOMBS: ");
			trackerText = new HUDText(FlxG.width - 90, 130, 85);
			trackerText.color = 0xdf0000;
			
			add(lifeText);
			add(trackerText);
			add(bombText);
		}
		
		public function updateBombs(bombs:int):void {
			if (bombs >= 0)
				bombText.text = "BOMBS: " + bombs;
			else
				bombText.visible = false;
		}
		
		override public function update():void {
			
			mineralText.text = station.mineralsMined + " ORE";
			mineralText.text += "\n" + station.mineralsLaunched + " SENT";
			mineralText.text += "\n"+station.mineralsAvailable+" LEFT";
			mineralText.text += "\n"+goal+" GOAL";
			
			lifeText.text = "TIME: " + C.renderTime(station.lifespan);
			lifeText.text += "\n\nBLOCKS: " + GlobalCycleTimer.minosDropped + "/"+GlobalCycleTimer.miningTime;
			
			trackerText.text = tracker.dangerText;
			
			super.update();
		}
	}

}