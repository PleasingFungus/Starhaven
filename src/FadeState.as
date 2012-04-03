package  {
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class FadeState extends FlxState {
		
		protected var background:FlxSprite;
		override public function create():void {
			FlxG.flash.start(0xff000000, FADE_TIME); 
			C.resetMouse();
			
			add(background = new FlxSprite());
			loadBackground(DEFAULT_BG);
			
			if (C.newMusicOK)
				C.music.intendedMusic = C.music.MENU_MUSIC;
			else
				C.music.intendedMusic = null;
		}
		
		protected function loadBackground(rawSpr:Class, Color:Number = 0.5):void {
			background.loadGraphic(rawSpr);
			background.color = 0x0; //force reset
			var colorComp:int = Color * 255;
			background.color = (colorComp << 16) | (colorComp << 8) | colorComp;
			
		}
		
		override public function update():void {
			if (!FlxG.fade.exists && !FlxG.flash.exists) {
				super.update();
				C.music.update();
			}
		}
		
		private var fadeTarget:Class;
		protected function fadeTo(state:Class):void {
			fadeTarget = state;
			FlxG.fade.start(0xff000000, FADE_TIME, finishFade);
		}
		
		protected function fadeBackTo(state:Class):void {
			C.sound.back();
			fadeTo(state);
		}
		
		protected function finishFade():void {
			FlxG.state = new fadeTarget;
		}
		
		public static const FADE_TIME:Number = 0.27;
		
		[Embed(source = "../lib/art/backgrounds/garradd_3.jpg")] private const DEFAULT_BG:Class;
	}

}