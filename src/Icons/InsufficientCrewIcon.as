package Icons {
	import flash.geom.Rectangle;
	import org.flixel.FlxSprite;
	import flash.geom.ColorTransform;
	
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class InsufficientCrewIcon extends Icontext {
		
		public function InsufficientCrewIcon() {
			super(0, 0, 80, " ", C.ICONS[C.PEOPLE]);
			shadow = 0x1;
			icon.pixels.colorTransform(new Rectangle(0, 0, width, height), TURN_RED);
			icon.unsafeBind(icon.pixels);
		}
		
		private static const TURN_RED:ColorTransform = new ColorTransform(0.1, 0.05, 0.05, 1, 127);
		
		private static var _instance:InsufficientCrewIcon;
		public static function get instance():InsufficientCrewIcon {
			if (!_instance)
				_instance = new InsufficientCrewIcon();
			return _instance;
		}
	}

}