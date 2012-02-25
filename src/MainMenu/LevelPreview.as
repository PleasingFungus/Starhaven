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
			//scenario.update();
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
			
			var lastMoused:Boolean = moused;
			moused = overlapsPoint(FlxG.mouse.x, FlxG.mouse.y);
			if (!lastMoused && moused)
				C.sound.play(SEL_SOUND, 0.125);
			
			if (moused && FlxG.mouse.justPressed()) {
				playLevelStart();
				FlxG.state = new level(seed);
			}
		}
		
		protected function playLevelStart():void {
			C.sound.playPersistent(SEL_SOUND, 0.25);
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
		
		[Embed(source = "../../lib/sound/menu/down3.mp3")] protected const SEL_SOUND:Class;
		[Embed(source = "../../lib/sound/menu/choose2.mp3")] protected const CHOOSE_SOUND:Class;
		private const BRIGHT:ColorTransform = new ColorTransform(1, 1, 1, 1, 127, 127, 127);
	}

}