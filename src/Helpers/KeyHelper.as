package Helpers {
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import Controls.Key;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class KeyHelper extends FlxSprite {
		
		public var key:Key;
		public function KeyHelper(key:Key) {
			super();
			this.key = key;
			generate();
		}
		
		public function generate():void {
			if (key.key == "SPACE") {
				loadGraphic(spaceKey);
				//scale.x = scale.y = 2;
				return;
			}
			
			loadGraphic(keyBase, false, false, 16, 16, true);
			var keySpr:FlxSprite;
			var off:int;
			
			var dir:int = ARROWS_BY_NAME.indexOf(key.key);
			if (dir != -1) {
				keySpr = new FlxSprite().loadGraphic(arrow_pngs[dir]);
				off = 4;
			} else {
				keySpr = new FlxText(0, 0, 1000, key.toString()).setFormat(null, 8, 0x0);//.setFormat(C.FONT, 10, 0x0);
				off = 2;
			}
			
			draw(keySpr, off, off);
			scale.x = scale.y = 2;
		}
		
		override public function update():void {
			super.update();
			alpha = key.pressed() ? 1 : 0.5;
		}
		
		override public function render():void {
			if (C.HUD_ENABLED)
				super.render();
		}
		
		
		public static const ARROWS_BY_NAME:Array = ["LEFT", "UP", "RIGHT", "DOWN"];
		
		[Embed(source = "../../lib/art/help/key.png")] private static const keyBase:Class;
		[Embed(source = "../../lib/art/help/spacekey.png")] private static const spaceKey:Class;
		
		[Embed(source = "../../lib/art/help/leftarrow.png")] private static const _key_left:Class;
		[Embed(source = "../../lib/art/help/uparrow.png")] private static const _key_up:Class;
		[Embed(source = "../../lib/art/help/rightarrow.png")] private static const _key_right:Class;
		[Embed(source = "../../lib/art/help/downarrow.png")] private static const _key_down:Class;
		private static const arrow_pngs:Array = [_key_left, _key_up, _key_right, _key_down];
	}

}