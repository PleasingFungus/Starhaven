package HUDs {
	import Controls.ControlSet;
	import Helpers.KeyHelper;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class SlowBar extends FlxGroup {
		
		private var bar:ColorBar;
		private var border:FlxSprite;
		private var icon:FlxSprite;
		private var key:KeyHelper;
		public function SlowBar() {
			var w:int = 60;
			var h:int = 8;
			bar = new ColorBar((FlxG.width - w) / 2, (FlxG.height - h) / 2 + 60, SLOW_TIME, SLOW_TIME, w, h)
			border = new FlxSprite(bar.x - 2, bar.y - 1).createGraphic(w + 4, h + 2)
			icon = new FlxSprite(bar.x, bar.y + bar.height / 2, C.ICONS[C.TIME]);
			icon.x -= icon.width + 16;
			icon.y -= icon.height / 2;
			key = new KeyHelper(ControlSet.FASTFALL_KEY);
			key.x = bar.x + bar.width + 16;
			key.y = bar.y + bar.height / 2 - key.height / 2;
			
			add(border);
			add(bar);
			add(icon);
			add(key);
			
			alpha = 0.75; //won't affect key
		}
		
		override public function update():void {
			super.update();
			if (FlxG.timeScale != 1)
				bar.quant = Math.max(0, bar.quant - FlxG.elapsed);
			if (!slowTimeRemaining)
				exists = false;
		}
		
		public function get slowTimeRemaining():Number {
			return bar.quant;
		}
		
		private const SLOW_TIME:Number = 5;
	}

}