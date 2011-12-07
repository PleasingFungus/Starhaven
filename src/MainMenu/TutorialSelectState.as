package MainMenu {
	import org.flixel.*;
	import Controls.ControlSet;
	import InfoScreens.HelpState;
	import Scenarios.Tutorials.*;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class TutorialSelectState extends FlxState {
		
		override public function create():void {
			var title:FlxText = new FlxText(10, 20, FlxG.width - 20, "Tutorials");
			title.setFormat(C.TITLEFONT, 48, 0xffffff, 'center');
			add(title);
			
			MenuThing.menuThings = [];
			add(new StateThing("README", HelpState));
			add(new StateThing("1 - Mining & Power", MiningTutorial));
			add(new StateThing("2 - Housing & Launching", HousingTutorial));
			add(new StateThing("3 - Asteroids & Meteoroids", DefenseTutorial));
			MenuThing.menuThings[0].select();
			
			var cancelButton:StateThing = new StateThing("Cancel", MenuState);
			cancelButton.setY(FlxG.height - 60);
			add(cancelButton);
			
			C.IN_TUTORIAL = true;
		}
		
		override public function update():void {
			super.update();
			
			if (ControlSet.CANCEL_KEY.justPressed())
				FlxG.state = new MenuState;
			//C.music.update();
		}
		
	}

}