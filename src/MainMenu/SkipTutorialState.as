package MainMenu {
	import Controls.ControlSet;
	import org.flixel.*
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class SkipTutorialState extends FadeState {
		
		override public function create():void {
			super.create();
			
			var title:FlxText = new FlxText(0, 15, FlxG.width, "Skip Remaining Tutorials");
			title.setFormat(C.TITLEFONT, 48, 0xffffff, 'center');
			add(title);
			
			var explanatoryText:FlxText = new FlxText(60, title.y + title.height + 30, FlxG.width - 120, "");
			explanatoryText.setFormat(C.BLOCKFONT, 16);
			explanatoryText.text += "Are you sure you want to skip the remaining tutorials? ";
			explanatoryText.text += "The game can be somewhat difficult to figure out on your own.\n\n";
			explanatoryText.text += "(If skipped, you can always access the tutorials from the main menu.)";
			add(explanatoryText);
			
			MenuThing.resetThings();
			var cancel:MenuThing, confirm:MenuThing;
			add(cancel = new StateThing("Never Mind", TutorialSelectState));
			add(confirm = new MenuThing("Skip Tutorials", skipTutorials));
			cancel.setY(explanatoryText.y + explanatoryText.height + 20);
			confirm.setY(explanatoryText.y + explanatoryText.height + 60);
			confirm.setFormat(C.FONT, 20);
			MenuThing.menuThings[0].select();
		}
		
		protected function skipTutorials():void {
			C.accomplishments.setTutorialsDone();
			FlxG.state = new MenuState;
		}
		
		override public function update():void {
			super.update();
			if (ControlSet.CANCEL_KEY.justPressed())
				fadeTo(TutorialSelectState);
		}
	}

}