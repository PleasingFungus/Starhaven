package Icons {
	import flash.geom.ColorTransform;
	import org.flixel.FlxSprite;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class NoPowerIcon extends ErrorIcon {
		
		public function NoPowerIcon() {
			super(C.POWER, TURN_RED);
		}
		
		private static const TURN_RED:ColorTransform = new ColorTransform(0.1, 0.1, 0.1, 1, 191);
		
		private static var _instance:NoPowerIcon;
		public static function get instance():NoPowerIcon {
			if (!_instance)
				_instance = new NoPowerIcon();
			return _instance;
		}
	}

}