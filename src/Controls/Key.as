package Controls {
	import Helpers.KeyHelper;
	import org.flixel.*;
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class Key {
		
		
		public var key:String;
		public var modified:Boolean;
		public function Key(key:String, modified:Boolean = false) {
			this.key = key;
			this.modified = modified;
		}
		
		public function pressed():Boolean {
			return FlxG.keys.pressed(key) && (!modified || FlxG.keys.pressed("SHIFT"));
		}
		
		public function justPressed():Boolean {
			return FlxG.keys.justPressed(key) && (!modified || FlxG.keys.pressed("SHIFT"));
		}
		
		public function justReleased():Boolean {
			return FlxG.keys.justReleased(key) //&& (!modified || FlxG.keys.pressed("SHIFT")); //TODO: support justReleased for modified key
		}
		
		public function toString():String {
			var num:int = DIGITS_BY_NAME.indexOf(key);
			if (num == -1)
				return key;
			return num.toString();
		}
		
		public function generateKeySprite():FlxSprite {
			return new KeyHelper(key);
		}
		
		
		
		public static const DIGITS_BY_NAME:Array = ["ZERO", "ONE", "TWO", "THREE", "FOUR",
													"FIVE", "SIX", "SEVEN", "EIGHT", "NINE"];
		public static const ARROWS_BY_NAME:Array = ["LEFT", "UP", "RIGHT", "DOWN"];
	}

}