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
			add(new StateThing("Conduits", ConduitTutorial));
			add(new StateThing("Drills", DrillTutorial));
			add(new StateThing("Launchers", LauncherTutorial));
			add(new StateThing("Barracks", BarracksTutorial));
			add(new StateThing("Missiles", MissileTutorial));
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