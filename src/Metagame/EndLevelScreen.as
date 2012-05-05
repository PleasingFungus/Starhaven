package Metagame 
{
	import org.flixel.*;
	import MainMenu.StateThing;
	/**
	 * ...
	 * @author ...
	 */
	public class EndLevelScreen extends FadeState 
	{
		private var won:Boolean;
		private var stats:Statblock;
		public function EndLevelScreen(Won:Boolean, Stats:Statblock) {
			super();
			won = Won;
			stats = Stats;
		}
		
		override public function create():void {
			super.create();
			loadBackground(done ? LOSE_BG : WIN_BG, 0.65);
			
			var title:FlxText = new FlxText(10, 10, FlxG.width - 20, "Stats");
			title.setFormat(C.TITLEFONT, 48, 0xffffff, 'center');
			add(title);
			
			//TODO: add screenshot
			//TODO: track/compare to best stat for mission+difficulty
			
			add(C.campaign.statblock.createDisplay(statDisplayY, C.accomplishments.bestStatForLevel, false));
			
			
			MenuThing.resetThings();
			MenuThing.addColumn([add(new StateThing("Back to Menu", MenuState))], FlxG.width * 1 / 8);
			if (!won)
				MenuThing.addColumn([add(new StateThing("Try Again", FullGameState))], FlxG.width * 5/8);
			else
				MenuThing.addColumn([add(new StateThing("Replay", mission))], FlxG.width * 5 / 8);
			
			for each (var option:MenuThing in MenuThing.menuThings)
				option.setY(FlxG.height - 40);
			MenuThing.menuThings[0].select();
		}
		
		[Embed(source = "../../lib/art/backgrounds/menu/menu_bg_x2s.jpg")] private const WIN_BG:Class;
		[Embed(source = "../../lib/art/backgrounds/menu/defeat_bg2s.jpg")] private const LOSE_BG:Class;
	}

}