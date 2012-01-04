package HUDs {
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class HUDText extends FlxText {
		
		private var icon:FlxSprite;
		public function HUDText(X:int = 0, Y:int = 0, Width:int = 0, Text:String = " ", Icon:Class = null) {
			super(X, Y, Width, Text);
			setFormat(C.FONT, 12);
			
			if (Icon)
				loadIcon(Icon);
		}
		
		public function loadIcon(Icon:Class):HUDText {
			icon = new FlxSprite();
			icon.loadGraphic(Icon);
			x += icon.width + 4;
			return this;
		}
		
		override public function render():void {
			super.render();
			if (icon) {
				//icon.x = x + width / 2 - icon.width / 2;
				//icon.y = y - (icon.height + 2);
				icon.x = x - icon.width - 4;
				if (alignment == 'right')
					icon.x += width - textWidth;
				icon.y = y + height / 2 - icon.height / 2 - 2;
				icon.render();
			}
		}
		
		override public function set alpha(a:Number):void {
			super.alpha = a;
			if (icon)
				icon.alpha = a;
		}
	}

}