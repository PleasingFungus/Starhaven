package MainMenu {
	import Editor.EditorState;
	import GameBonuses.BonusState;
	import Controls.ControlSet;
	import org.flixel.*;
	import InfoScreens.HelpState;
	import Metagame.CampaignState;
	import Credits.CreditsState;
	import Options.OptionsState;

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
			
			//if (!C.music.intendedMusic && C.newMusicOK)
				//C.music.forceSwap(C.music.MENU_MUSIC);
			
			super.create();
			
			add(new AttractMode);
			loadBackground(BG);
			background.color = 0xffffff;
			
			var t:FlxText;
			
			t = new FlxText(0, 20, FlxG.width, "Starhaven");
			t.setFormat(C.TITLEFONT, 64, 0xffffff, 'center');
			add(t);
			
			MenuThing.resetThings();
			if (C.accomplishments.tutorialDone) {
				add(new MemoryThing("Tutorials", TutorialSelectState));
				add(new MemoryThing("Serial Play", FullGameState));
				add(new MemoryThing("Single Levels", QuickPlayState));
			} else
				add(new MemoryThing("Play", C.accomplishments.nextUnbeaten()));
			if (C.UNLOCKS_DISABLED || C.unlocks.unlockedBonuses())
				add(new MemoryThing("Bonuses", BonusState));
			if (C.DEBUG)
				add(new MemoryThing("Editor", EditorState));
			add(new MemoryThing("Options", OptionsState));
			add(new MemoryThing("Credits", CreditsState));
			
			//t = new FlxText(0, FlxG.height - 25, FlxG.width, "Use arrow keys to navigate and enter to select.");
			//t.setFormat(C.FONT, 12, 0xffffff, 'center');
			//add(t);
			
			t = new FlxText(0, 4, FlxG.width - 5, C.VERSION + (C.DEBUG ? "-DEBUG" : ""));
			t.setFormat(C.FONT, 12, 0xffffff, 'right');
			add(t);
			
			bgColor = 0x0;
		}
		
		[Embed(source = "../../lib/art/backgrounds/menu/menu_bg_7s.jpg")] private const BG:Class;
	}
}
