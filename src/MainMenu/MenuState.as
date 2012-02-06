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
				add(new MemoryThing("Tutorials", TutorialSelectState));
				add(new MemoryThing("Full Game", FullGameState));
				add(new MemoryThing("Single Levels", QuickPlayState));
			} else
				add(new MemoryThing("Play", C.accomplishments.nextUnbeaten()));
			add(new MemoryThing("Controls", ControlsState));
			add(new MemoryThing("Credits", CreditsState));
			
			//t = new FlxText(0, FlxG.height - 25, FlxG.width, "Use arrow keys to navigate and enter to select.");
			//t.setFormat(C.FONT, 12, 0xffffff, 'center');
			//add(t);
			
			
			t = new FlxText(0, 4, FlxG.width - 5, C.VERSION + (C.DEBUG ? "-DEBUG" : ""));
			t.setFormat(C.FONT, 12, 0xffffff, 'right');
			add(t);
			
			C.music.intendedMusic = C.music.MENU_MUSIC;
			bgColor = 0x0;
		}
	}
}
