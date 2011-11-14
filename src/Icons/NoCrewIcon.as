package Icons {
	import flash.geom.Rectangle;
	import org.flixel.FlxSprite;
	import flash.geom.ColorTransform;
	
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class NoCrewIcon extends ErrorIcon {
		
		public function NoCrewIcon() {
			super(C.PEOPLE, TURN_RED);
		}
		
		private static const TURN_RED:ColorTransform = new ColorTransform(0.1, 0.05, 0.05, 1, 127);
		
		private static var _instance:NoCrewIcon;
		public static function get instance():NoCrewIcon {
			if (!_instance)
				_instance = new NoCrewIcon();
			return _instance;
		}
	}

}