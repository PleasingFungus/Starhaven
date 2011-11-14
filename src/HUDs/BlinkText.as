package HUDs {
	import org.flixel.FlxText;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class BlinkText extends FlxText {
		
		private var blinkTimer:Number = 0;
		private var blinkPeriod:Number = 0.8;
		public function BlinkText(X:int, Y:int, Text:String, Size:int = 8, Color:uint = 0xffffff) {
			super(X, Y, FlxG.width - X * 2, Text);
			setFormat(C.FONT, Size, Color, 'center');
		}
		
		override public function update():void {
			blinkTimer += FlxG.elapsed;
			if (blinkTimer >= blinkPeriod) {
				blinkTimer -= blinkPeriod;
				visible = !visible;
			}
		}
	}

}