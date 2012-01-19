package MainMenu {
	import Controls.ControlSet;
	import Controls.ControlsState;
	import org.flixel.*;
	import InfoScreens.HelpState;
	import Metagame.CampaignState;
	import Credits.CreditsState;

	public class MenuState extends FadeState
	{
		
		override public function create():void
		{
			C.setPrintReady();
			if (C.campaign) {
				C.campaign.die(); //dispose of heavy bitmaps
				C.campaign = null;
			}
			C.IN_TUTORIAL = false;
			
			
			super.create();
			
			var t:FlxText;
			
			t = new FlxText(0, 20, FlxG.width, "Starhaven");
			t.setFormat(C.TITLEFONT, 64, 0xffffff, 'center');
			add(t);
			
			MenuThing.resetThings();
			if (C.accomplishments.tutorialDone) {
				add(new MainMenuThing("Tutorials", TutorialSelectState));
				add(new MainMenuThing("Full Game", FullGameState));
				if (C.accomplishments.quickPlayUnlocked() || C.ALL_UNLOCKED)
					add(new MainMenuThing("Single Levels", QuickPlayState));
			} else
				add(new MainMenuThing("Play", C.accomplishments.scenarios[0]));
			add(new MainMenuThing("Controls", ControlsState));
			add(new MainMenuThing("Credits", CreditsState));
			
			//t = new FlxText(0, FlxG.height - 25, FlxG.width, "Use arrow keys to navigate and enter to select.");
			//t.setFormat(C.FONT, 12, 0xffffff, 'center');
			//add(t);
			
			
			t = new FlxText(0, 4, FlxG.width - 5, C.VERSION + (C.DEBUG ? "-DEBUG" : ""));
			t.setFormat(C.FONT, 12, 0xffffff, 'right');
			add(t);
			
			//C.music.intendedMusic = Music.MENU_MUSIC;
			bgColor = 0x0;
			FlxG.mouse.show();
		}
		
		//override public function update():void {
			//super.update();
			//C.music.update();
		//}
	}
}
