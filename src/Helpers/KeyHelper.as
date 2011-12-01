package Helpers {
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class KeyHelper extends FlxSprite {
		
		public function KeyHelper(key:String) {
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
		
	}

}