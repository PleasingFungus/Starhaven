package Icons {
	import org.flixel.FlxText;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class Icontext extends FlxText {
		
		protected var icon:FlxSprite;
		public function Icontext(X:int = 0, Y:int = 0, Width:int = 0, Text:String = " ", Icon:Class = null) {
			super(X, Y, Width, Text);
			setFormat(C.FONT, 16);
			
			if (Icon)
				loadIcon(Icon);
		}
		
		public function loadIcon(Icon:Class):FlxText {
			icon = new FlxSprite();
			icon.loadGraphic(Icon);
			x += icon.width + ICON_SPACE;
			return this;
		}
		
		override public function render():void {
			super.render();
			if (icon) {
				icon.x = x +textWidth + ICON_SPACE;//- (icon.width + ICON_SPACE);
				icon.y = y;
				icon.render();
			}
		}
		
		public function get realWidth():int {
			if (icon)
				return textWidth + ICON_SPACE + icon.width;
			return textWidth
		}
		
		override public function set color(Color:uint):void {
			super.color = Color;
			shadow = 0xffffff ^ color;
		}
		
		private const ICON_SPACE:int = 2;
	}

}