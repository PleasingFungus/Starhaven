package Controls {
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
			var base:FlxSprite = new FlxSprite().loadGraphic(keyBase, false, false, 16, 16, true);
			var keySpr:FlxSprite;
			var off:int;
			
			var dir:int = ARROWS_BY_NAME.indexOf(key);
			if (dir != -1) {
				keySpr = new FlxSprite().loadGraphic(arrow_pngs[dir]);
				off = 4;
			} else {
				keySpr = new FlxText(0, 0, 1000, toString()).setFormat(null, 8, 0x0);//.setFormat(C.FONT, 10, 0x0);
				off = 2;
			}
			
			base.draw(keySpr, off, off);
			base.scale.x = base.scale.y = 2;
			return base;
		}
		
		
		
		public static const DIGITS_BY_NAME:Array = ["ZERO", "ONE", "TWO", "THREE", "FOUR",
													"FIVE", "SIX", "SEVEN", "EIGHT", "NINE"];
		public static const ARROWS_BY_NAME:Array = ["LEFT", "UP", "RIGHT", "DOWN"];
		
		
		
		
		[Embed(source = "../../lib/art/help/key.png")] private static const keyBase:Class;
		
		[Embed(source = "../../lib/art/help/leftarrow.png")] private static const _key_left:Class;
		[Embed(source = "../../lib/art/help/uparrow.png")] private static const _key_up:Class;
		[Embed(source = "../../lib/art/help/rightarrow.png")] private static const _key_right:Class;
		[Embed(source = "../../lib/art/help/downarrow.png")] private static const _key_down:Class;
		private static const arrow_pngs:Array = [_key_left, _key_up, _key_right, _key_down];
	}

}