package Icons {
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class FloatingIconText extends Icontext {
		
		private var floatTime:Number = 0;
		private const TOTAL_FLOAT_TIME:Number = 3;
		private const RISE_SPEED:Number = 10;
		public function FloatingIconText(X:int = 0, Y:int = 0, Width:int = 0, Text:String = " ", Icon:Class = null) {
			super(X, Y, Width, Text, Icon);
		}
		
		override public function update():void {
			y -= FlxG.elapsed * RISE_SPEED;
			floatTime += FlxG.elapsed;
			if (floatTime >= TOTAL_FLOAT_TIME)
				exists = false;
			else {
				alpha = 1 - floatTime / TOTAL_FLOAT_TIME;
				if (icon)
					icon.alpha = 1 - floatTime / TOTAL_FLOAT_TIME;
			}
			
			super.update();
		}
		
	}

}