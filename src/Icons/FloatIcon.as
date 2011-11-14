package Icons {
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class FloatIcon extends FlxSprite {
		
		private var floatTime:Number = 0;
		private const TOTAL_FLOAT_TIME:Number = 1;
		private const RISE_SPEED:Number = 10;
		public function FloatIcon(X:int, Y:int, Type:int) {
			super(X, Y, C.ICONS[Type]);
		}
		
		override public function update():void {
			super.update();
			y -= FlxG.elapsed * RISE_SPEED;
			floatTime += FlxG.elapsed;
			if (floatTime >= TOTAL_FLOAT_TIME)
				exists = false;
			else
				alpha = 1 - floatTime / TOTAL_FLOAT_TIME;
		}
	}

}