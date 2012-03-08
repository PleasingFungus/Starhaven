package InfoScreens {
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class InfoScreen extends FlxGroup {
		
		protected var setInfopauseState:Function;
		protected var bg:FlxSprite;
		protected var continueText:FlxText;
		public function InfoScreen(SetInfopauseState:Function) {
			setInfopauseState = SetInfopauseState;
			create();
		}
		
		protected function create():void {
			add(bg = new FlxSprite().createGraphic(FlxG.width, FlxG.height, 0xff000000)); //darken playfield
			bg.alpha = .75;
			
			add(continueText = new FlxText(0, FlxG.height - 20, FlxG.width, "press ENTER to unpause").setFormat(C.FONT, 12, 0xffffff, 'center'));
			
			FlxG.timeScale = 0;
			setInfopauseState(true);
		}
		
		override public function update():void {
			super.update();
			if (FlxG.keys.justPressed("ENTER")) {
				FlxG.timeScale = 1;
				exists = false;
				setInfopauseState(false);
			}
		}
	}

}