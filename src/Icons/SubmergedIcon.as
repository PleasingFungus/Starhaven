package Icons {
	import flash.geom.ColorTransform;
	import org.flixel.FlxSprite;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class SubmergedIcon extends ErrorIcon {
		
		public function SubmergedIcon() {
			super(C.WATER, TURN_RED);
		}
		
		private static const TURN_RED:ColorTransform = new ColorTransform(0.1, 0.1, 0.1, 1, 191);
		
		private static var _instance:SubmergedIcon;
		public static function get instance():SubmergedIcon {
			if (!_instance)
				_instance = new SubmergedIcon();
			return _instance;
		}
		
	}

}