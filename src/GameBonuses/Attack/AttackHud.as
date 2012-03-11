package GameBonuses.Attack {
	import HUDs.HUD;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class AttackHud extends HUD {
		
		private var livesDisplay:MeteoDisplay;
		public function AttackHud() {
			super();
			
			members = [];
			
			livesDisplay = new MeteoDisplay(FlxG.width - 8, 8, 3);
			livesDisplay.x -= livesDisplay.width;
			add(livesDisplay);
			
			var lives:FlxText = new FlxText(livesDisplay.x - 120, livesDisplay.y, 120, "LIVES: ");
			lives.setFormat(C.FONT, 16, 0xffffff, 'right');
			lives.y += livesDisplay.height / 2 - lives.height / 2;
			add(lives);
			
			//TODO
		}
		
		override public function update():void {
			//TODO
			if (C.HUD_FLICKERS)
				updateFlicker();
			updateMembers();
		}
		
		override public function updateGoal(goalPercent:int):void {	}
		
		public function updateLives(amount:int):void {
			livesDisplay.updateTo(amount);
		}
	}

}