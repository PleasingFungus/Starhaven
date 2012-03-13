package HUDs {
	import org.flixel.*;
	import MainMenu.StateThing;
	import MainMenu.SkipTutorialState;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class PauseLayer extends FlxGroup {
		
		protected var darkShroud:FlxSprite;
		public function PauseLayer(exitToMenu:Function, resetLevel:Function) {
			super();
			
			add(darkShroud = new FlxSprite().createGraphic(FlxG.width, FlxG.height, 0xff000000));
			
			var stateText:String = C.scenarioList.names[C.scenarioList.index(FlxG.state as Scenario)];
			stateText += ": "+C.difficulty.scaleName() + "-"+C.difficulty.name();
			var stateTitle:FlxText = new FlxText(0, 20, FlxG.width, stateText);
			stateTitle.setFormat(C.FONT, 20, 0xffffff, 'center');
			add(stateTitle);
			
			if (C.DEBUG)
				stateTitle.text += "\nTUT: " + C.IN_TUTORIAL;
			
			if (C.campaign) {
				var campaignText:String = "Mission: " + (C.campaign.missionsRun.length);
				campaignText += " (ED " + C.difficulty.name(C.difficulty.setting) +  ")";
				var campaignTitle:FlxText = new FlxText(0, stateTitle.y + stateTitle.height + 5, FlxG.width, campaignText);
				campaignTitle.setFormat(C.FONT, 20, 0xffffff, 'center');
				add(campaignTitle);
			}
			
			MenuThing.resetThings();
			var col:Array = [];
			var quitButton:MenuThing = new MenuThing("Quit", exitToMenu);
			quitButton.setFormat(C.FONT, 20);
			col.push(add(quitButton));
			quitButton.setY(FlxG.height / 2 - 40);
			
			if (!C.campaign) {
				var resetButton:MenuThing = new MenuThing("Restart", resetLevel);
				resetButton.setFormat(C.FONT, 20);
				col.push(add(resetButton));
				resetButton.setY(FlxG.height / 2);
			}
			
			if (!C.accomplishments.tutorialDone) {
				var skipButton:StateThing = new StateThing("Skip Tutorials", SkipTutorialState);
				col.push(add(skipButton));
				skipButton.setY(FlxG.height / 2 + 40);
			}
			
			//MenuThing.addColumn(col, FlxG.width/2 - quitButton.fullWidth/2);
			
			var pauseText:FlxText = new BlinkText(0, FlxG.height - 40, "Press any key to unpause.", 16)
			pauseText.active = false;
			add(pauseText);
		}
		
		override public function render():void {
			alpha = 1;
			darkShroud.alpha = 0.75;
			super.render();
		}
		
	}

}