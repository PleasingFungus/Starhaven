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
			add(new StateThing("Conduit Tutorial", ConduitTutorial));
			add(new StateThing("Drill Tutorial", DrillTutorial));
			if (!C.accomplishments.tutorialDone)
				add(new StateThing("Skip Remaining Tutorials", SkipTutorialState));
			MenuThing.menuThings[0].select();
			
			var cancelButton:StateThing = new StateThing("Back", MenuState);
			cancelButton.setY(FlxG.height - 60);
			add(cancelButton);
			
			C.IN_TUTORIAL = false;
		}
		
		override public function update():void {
			super.update();
			
			if (ControlSet.CANCEL_KEY.justPressed()) {
				fadeBackTo(MenuState);
			}
		}
		
		[Embed(source = "../../lib/art/backgrounds/menu/tutorial_select_bg_s.jpg")] private const BG:Class;
		
	}

}