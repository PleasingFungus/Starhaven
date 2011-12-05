package MainMenu {
	import flash.geom.ColorTransform;
	import org.flixel.*;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import Metagame.Campaign;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class LevelPreview extends FlxSprite {
		
		private var level:Class;
		private var scenario:Scenario;
		private var seed:Number;
		private var text:FlxText;
		public function LevelPreview(X:int, Y:int, Level:Class) {
			super(X, Y);
			
			level = Level;
			seed = FlxU.random();
			scenario = new Level(seed);
			
			var hudOn:Boolean = C.HUD_ENABLED;
			C.HUD_ENABLED = false;
			
			scenario.create();
			scenario.update();
			scenario.update();
			scenario.render();
			
			C.HUD_ENABLED = hudOn;
			
			pixels = new BitmapData(Campaign.SCREENSHOT_SIZE.x, Campaign.SCREENSHOT_SIZE.y);
			var scaleMatrix:Matrix = new Matrix();
			scaleMatrix.scale(Campaign.SCREENSHOT_SIZE.x / FlxG.buffer.width, Campaign.SCREENSHOT_SIZE.y / FlxG.buffer.height);
			pixels.draw(FlxG.buffer, scaleMatrix);
			frame = 0;
			
			text = new FlxText(x, y, width, "Play");
			text.setFormat(C.FONT, 16, 0xffffff, 'center', 0x1);
		}
		
		private var moused:Boolean;
		override public function update():void {
			super.update();
			moused = overlapsPoint(FlxG.mouse.x, FlxG.mouse.y);
			if (moused && FlxG.mouse.justPressed())
				FlxG.state = new level(seed);
		}
		
		override public function render():void {
			if (moused)
				_ct = BRIGHT;
			else
				_ct = null;
			frame = 0;
			super.render();
			
			//if (moused) {
				text.x = x;
				text.y = y + height / 2 - text.height / 2;
				text.render();
			//}
		}
		
		private const BRIGHT:ColorTransform = new ColorTransform(1, 1, 1, 1, 127, 127, 127);
	}

}