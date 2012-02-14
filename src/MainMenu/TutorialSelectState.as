package MainMenu {
	import org.flixel.*;
	import Controls.ControlSet;
	import InfoScreens.HelpState;
	import Scenarios.Tutorials.*;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class TutorialSelectState extends FadeState {
		
		override public function create():void {
			super.create();
			loadBackground(BG, 0.65);
			
			var title:FlxText = new FlxText(10, 20, FlxG.width - 20, "Tutorials");
			title.setFormat(C.TITLEFONT, 48, 0xffffff, 'center');
			add(title);
			
			MenuThing.resetThings();
			//add(new StateThing("README", HelpState));
			add(new StateThing("1 - Mining & Power", MiningTutorial));
			add(new StateThing("2 - Housing & Launching", HousingTutorial));
			add(new StateThing("3 - Asteroids & Meteoroids", DefenseTutorial));
			if (!C.accomplishments.tutorialDone)
				add(new StateThing("Skip Remaining Tutorials", SkipTutorialState));
			MenuThing.menuThings[0].select();
			
			var cancelButton:StateThing = new StateThing("Back", MenuState);
			cancelButton.setY(FlxG.height - 60);
			add(cancelButton);
			
			C.music.intendedMusic = C.music.MENU_MUSIC;
		}
		
		override public function update():void {
			super.update();
			
			if (ControlSet.CANCEL_KEY.justPressed()) {
				fadeBackTo(MenuState);
			}
		}
		
		[Embed(source = "../../lib/art/backgrounds/menu/tutorial_select_bg.jpg")] private const BG:Class;
		
	}

}