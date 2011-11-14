package HUDs {
	import org.flixel.FlxGroup;
	import org.flixel.FlxText;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class FlashText extends FlxText {
		
		public function FlashText(Text:String, Color:uint, Size:int = 1) {
			super(FlxG.width / 8, 0, FlxG.width * 3 / 4, Text);
			setFormat(C.FONT, 24 * Size, Color, "center", 0x1);
			activeTexts.push(this);
			adjustPositioning();
		}
		
		private var fadeInTimer:Number = 0;
		private const FADE_IN_TIME:Number = 0.15;
		private var holdTimer:Number = 0;
		private const HOLD_TIME:Number = 1.2;
		private const FADE_OUT_TIME:Number = 0.5;
		private var fadeOutTimer:Number = FADE_OUT_TIME;
		override public function update():void {
			super.update();
			
			if (fadeInTimer < FADE_IN_TIME) {
				fadeInTimer += FlxG.elapsed;
				alpha = fadeInTimer / FADE_IN_TIME;
			} else if (holdTimer < HOLD_TIME)
				holdTimer += FlxG.elapsed;
			else if (fadeOutTimer > 0) {
				fadeOutTimer -= FlxG.elapsed;
				alpha = fadeOutTimer / FADE_OUT_TIME;
			} else {
				exists = false;
				activeTexts.splice(activeTexts.indexOf(this), 1);
			}
		}

		public static var activeTexts:Array;
		public static var layer:FlxGroup;
		private static var SPACING:int = 5;
		private static function adjustPositioning():void {
			var totalHeight:int = -SPACING;
			for each (var text:FlashText in activeTexts)
				totalHeight += text.height; 
			
			var Y:int = FlxG.height / 2 - totalHeight / 2;
			for (var i:int = 0; i < activeTexts.length; i++) {
				text = activeTexts[i];
				text.y = Y;
				Y += text.height + SPACING;
			}
		}
	}

}