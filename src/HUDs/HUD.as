package HUDs {
	import Meteoroids.MeteoroidTracker;
	import org.flixel.*;
	import Controls.ControlSet;
	import Globals.GlobalCycleTimer;
	
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
		private var goalText:HUDText;
		private var HUDBar:FlxSprite;
		
		public var minimap:Minimap;
		public var bounds:MapBounds;
		
		private var station:Station;
		private var goal:int;
		private var tracker:MeteoroidTracker;
		public function HUD() {
			super();
			
			//minimap = new Minimap(0, 0, station);
			//add(minimap);
			
			mineralText = new HUDText(5, 220, 100).loadIcon(C.ICONS[C.MINERALS]);
			lifeText = new HUDText(FlxG.width - 90, 20, 85, "TIME: 0:00");
			
			if (C.DEBUG && C.DEBUG_INFO_LAYER) {
				add(mineralText);
				add(lifeText);
			}
			
			var hbarheight:int = 22;
			HUDBar = new FlxSprite(0, FlxG.height - hbarheight).createGraphic(FlxG.width, hbarheight, 0xff000000);
			HUDBar.alpha = 0.4;
			add(HUDBar);
			
			goalText = new HUDText(10, FlxG.height - 18, 160, goalName+": 0%", C.ICONS[C.MINERALS]);
			goalText.color = 0xffd000;
			if (C.DEBUG && C.DEBUG_INFO_LAYER)
			{
				trackerText = new HUDText(FlxG.width - 190, FlxG.height - 18, 170, " ", C.ICONS[C.METEOROIDS]);
				trackerText.color = 0xdf0000;
				trackerText.alignment = "right";
			}
			
			//var menuText:FlxText = new HUDText(FlxG.width - 190, 5, 185, "ESC=MENU");
			//menuText.alignment = "right";
			//add(menuText);
			
			
			add(goalText);
			add(trackerText);
			
			if (GlobalCycleTimer.miningTime || (C.DEBUG && C.DEBUG_INFO_LAYER)) {				
				blockText = new HUDText(FlxG.width / 2, FlxG.height - 18, 160, " ", C.ICONS[C.MINOS]);
				add(blockText);
			}
		}
		
		public function setStation(station:Station):void {
			this.station = station;
			minimap.setStation(station);
		}
		
		public function setGoal(goalFraction:Number):void {
			goal = goalFraction * station.mineralsAvailable;
		}
		
		public function setTracker(tracker:MeteoroidTracker):void {
			this.tracker = tracker;
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
			
			if (trackerText)
			{
				if (trackerText.active && tracker.dangerText)
					trackerText.text = tracker.dangerText/* + " ("+tracker.waveMeteos+")"*/;
				else
					trackerText.text = " ";
			}
			
			if (C.HUD_FLICKERS)
				updateFlicker();
			super.update();
		}
		
		protected var flickerState:int = FLICKERSTATE_TO_FULL_ON;
		protected var flickerTimer:Number = 0;
		protected function updateFlicker():void {
			flickerTimer += FlxG.elapsed;
			switch (flickerState) {
				case FLICKERSTATE_TO_FIRST_ON:
					if (flickerTimer >= FIRST_FLICKER_ON_TIME) {
						flickerTimer -= FIRST_FLICKER_ON_TIME;
						flickerState = FLICKERSTATE_TO_OFF;
					}
					break;
				case FLICKERSTATE_TO_OFF:
					if (flickerTimer >= FLICKER_OFF_TIME) {
						flickerTimer -= FLICKER_OFF_TIME;
						flickerState = FLICKERSTATE_TO_FULL_ON;
					}
					break;
				case FLICKERSTATE_TO_FULL_ON:
					if (flickerTimer >= FULL_FLICKER_ON_TIME)
						flickerState = FLICKERSTATE_DONE;
					break;
				case FLICKERSTATE_DONE:
					return;
			}
		}
		
		override public function render():void {
			if (C.HUD_FLICKERS)
				renderFlicker();
			super.render();
		}
		
		protected function renderFlicker():void {
			switch (flickerState) {
				case FLICKERSTATE_TO_FIRST_ON:
					alpha = flickerTimer * FIRST_FLICKER_ON_INTENSITY / FIRST_FLICKER_ON_TIME; break;
				case FLICKERSTATE_TO_OFF:
					alpha = 1 - flickerTimer * (1 - FLICKER_OFF_INTENSITY) / FLICKER_OFF_TIME; break;
				case FLICKERSTATE_TO_FULL_ON:
					alpha = flickerTimer / FULL_FLICKER_ON_TIME; break;
				case FLICKERSTATE_DONE:
					alpha = 1; return;
			}
		}
		
		override public function set alpha(a:Number):void {
			super.alpha = a;
			bounds.alpha = a;
			HUDBar.alpha = 0.4 * a;
		}
		
		public function setGoalIcon(icon:Class):void
		{
			goalText.loadIcon(icon);
		}
		
		protected const FLICKERSTATE_TO_FIRST_ON:int = 0;
		protected const FLICKERSTATE_TO_OFF:int = 1;
		protected const FLICKERSTATE_TO_FULL_ON:int = 2;
		protected const FLICKERSTATE_DONE:int = 3;
		
		protected const FIRST_FLICKER_ON_TIME:Number = 0.4;
		protected const FIRST_FLICKER_ON_INTENSITY:Number = 0.4;
		protected const FLICKER_OFF_TIME:Number = 0.1;
		protected const FLICKER_OFF_INTENSITY:Number = 0.2;
		protected const FULL_FLICKER_ON_TIME:Number = 1.0;
	}

}