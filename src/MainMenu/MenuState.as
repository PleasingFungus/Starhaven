package MainMenu {
	import Controls.ControlSet;
	import Controls.ControlsState;
	import Metagame.MapState;
	import org.flixel.*;
	import Scenarios.AsteroidScenario;
	import Scenarios.DefaultScenario;
	import Scenarios.PlanetScenario;
	import Scenarios.NebulaScenario;
	import InfoScreens.HelpState;
	import Metagame.MissionSelectState;

	public class MenuState extends FlxState
	{
		
		override public function create():void
		{
			C.setPrintReady();
			C.campaign = null;
			
			var t:FlxText;
			
			t = new FlxText(0, 20, FlxG.width, "Starhaven");
			t.setFormat(C.TITLEFONT, 64, 0xffffff, 'center');
			add(t);
			
			MenuThing.menuThings = [];
			add(new MainMenuThing("README", HelpState));
			add(new MainMenuThing("Quick Play", QuickPlayState));
			//add(new MainMenuThing("Campaign", MissionSelectState));
			add(new MainMenuThing("Controls", ControlsState));
			add(new MainMenuThing("Credits", CreditsState));
			
			//t = new FlxText(0, FlxG.height - 25, FlxG.width, "Use arrow keys to navigate and enter to select.");
			//t.setFormat(C.FONT, 12, 0xffffff, 'center');
			//add(t);
			
			
			t = new FlxText(0, 7, FlxG.width - 5, C.VERSION + (C.DEBUG ? "-DEBUG" : ""));
			t.setFormat(C.FONT, 12, 0xffffff, 'right');
			add(t);
			
			//C.music.intendedMusic = Music.MENU_MUSIC;
			FlxG.mouse.show();
		}
		
		//override public function update():void {
			//super.update();
			//C.music.update();
		//}
	}
}
