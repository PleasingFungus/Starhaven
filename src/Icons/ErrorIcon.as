package Icons {
	import org.flixel.FlxSprite;
	import flash.geom.Rectangle;
	import flash.geom.ColorTransform;
	
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class ErrorIcon extends FlxSprite {
		
		public function ErrorIcon(icon:int, Color:ColorTransform = null) {
			super();
			loadGraphic(C.ICONS[icon], false, false, 16, 16, true);
			
			if (Color) {
				pixels.colorTransform(new Rectangle(0,0,width,height), Color);
				_framePixels.copyPixels(_pixels, _flashRect, _flashPointZero);
			}
		}
		
		//todo: blink?
		
	}

}