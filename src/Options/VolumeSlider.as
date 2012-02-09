package Options {
	import Controls.Key;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class VolumeSlider extends FlxGroup {
		
		protected var bars:Array;
		protected var leftArrow:Key;
		protected var rightArrow:Key;
		private var getter:Function;
		private var setter:Function;
		public function VolumeSlider(Y:int, Getter:Function, Setter:Function) {
			y = Y;
			getter = Getter;
			setter = Setter;
			create();
			update();
		}
		
		protected function create():void {
			bars = [];
			for (var i:int = -5; i < 5; i++) {
				var x:int = FlxG.width / 2 - BAR_WIDTH / 2 + i * (BAR_WIDTH + BAR_SPACING);
				var bar:FlxSprite = new FlxSprite(x, 0).createGraphic(BAR_WIDTH, BAR_HEIGHT);
				bar.alpha = 0.5;
				bars.push(add(bar));
			}
		}
		
		private const BAR_SPACING:int = 5;
		private const BAR_WIDTH:int = 15;
		private const BAR_HEIGHT:int = 30;
	}

}