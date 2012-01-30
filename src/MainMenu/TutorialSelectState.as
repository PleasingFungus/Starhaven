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
			
			var title:FlxText = new FlxText(10, 20, FlxG.width - 20, "Tutorials");
			title.setFormat(C.TITLEFONT, 48, 0xffffff, 'center');
			add(title);
			
			MenuThing.resetThings();
			add(new StateThing("README", HelpState));
			add(new StateThing("1 - Mining & Power", MiningTutorial));
			add(new StateThing("2 - Housing & Launching", HousingTutorial));
			add(new StateThing("3 - Asteroids & Meteoroids", DefenseTutorial));
			if (!C.accomplishments.tutorialDone)
				add(new StateThing("Skip Remaining Tutorials", SkipTutorialState));
			MenuThing.menuThings[0].select();
			
			if (C.accomplishments.tutorialDone) {
				var cancelButton:StateThing = new StateThing("Cancel", MenuState);
				cancelButton.setY(FlxG.height - 60);
				add(cancelButton);
			}
		}
		
		override public function update():void {
			super.update();
			
			if (C.accomplishments.tutorialDone && ControlSet.CANCEL_KEY.justPressed())
				fadeTo(MenuState);
			//C.music.update();
		}
		
	}

}