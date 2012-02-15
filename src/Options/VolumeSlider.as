package Options {
	import Controls.ControlSet;
	import Controls.Key;
	import Helpers.KeyHelper;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class VolumeSlider extends FlxGroup {
		
		public var selected:Boolean;
		protected var volNumber:FlxText;
		protected var bars:Array;
		protected var leftArrow:KeyHelper;
		protected var rightArrow:KeyHelper;
		private var name:String;
		private var getter:Function;
		private var setter:Function;
		private var deltaSound:Class;
		public function VolumeSlider(Y:int, Name:String, Getter:Function, Setter:Function, DeltaSound:Class = null) {
			y = Y;
			name = Name;
			getter = Getter;
			setter = Setter;
			deltaSound = DeltaSound;
			create();
			update();
		}
		
		protected function create():void {
			var title:FlxText = new FlxText(10, 0, FlxG.width - 20, name);
			title.setFormat(C.FONT, 16, 0xffffff, 'center');
			add(title);
			
			volNumber = new FlxText(FlxG.width / 2 - 14, title.height + 5, 28, volume + "");
			volNumber.setFormat(C.FONT, 16, 0xffffff, 'center');
			add(volNumber);
			
			bars = [];
			for (var i:int = -5; i <= 5; i++) {
				if (!i) continue;
				
				var x:int = FlxG.width / 2 - BAR_WIDTH / 2 + i * (BAR_WIDTH + BAR_SPACING);
				var bar:FlxSprite = new FlxSprite(x, title.height + 5).createGraphic(BAR_WIDTH, BAR_HEIGHT);
				bar.alpha = 0.5;
				bars.push(add(bar));
			}
			
			leftArrow = new KeyHelper(ControlSet.LEFT_KEY);
			rightArrow = new KeyHelper(ControlSet.RIGHT_KEY);
			leftArrow.x = bars[0].x - 20 - leftArrow.width;
			rightArrow.x = bars[bars.length - 1].x + bars[bars.length - 1].width + 20;
			leftArrow.y = rightArrow.y = bars[0].y + 9;
			add(leftArrow);
			add(rightArrow);
		}
		
		protected function get volume():int {
			return getter() * 10;
		}
		
		protected function set volume(v:int):void {
			setter(v / 10.0);
		}
		
		override public function update():void {
			if (selected)
				checkKeys();
			leftArrow.visible = rightArrow.visible = selected;
			checkVolume();
			super.update();
		}
		
		protected function checkKeys():void {
			if (leftArrow.key.justPressed() && volume > 0) {
				volume--;
				if (deltaSound)
					C.sound.play(deltaSound)
			}
			if (rightArrow.key.justPressed() && volume < 10) {
				volume++;
				if (deltaSound)
					C.sound.play(deltaSound)
			}
		}
		
		protected function checkVolume():void {
			var vol:int = volume;
			volNumber.text = vol + "";
			for (var i:int = 0; i < vol; i++)
				bars[i].alpha = 0.9;
			for (i = vol; i < bars.length; i++)
				bars[i].alpha = 0.5;
		}
		
		private const BAR_SPACING:int = 10;
		private const BAR_WIDTH:int = 20;
		private const BAR_HEIGHT:int = 35;
	}

}