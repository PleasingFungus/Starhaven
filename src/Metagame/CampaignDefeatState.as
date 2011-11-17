package Metagame {
	import org.flixel.*;
	import MainMenu.StateThing;
	import MainMenu.MenuState;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class CampaignDefeatState extends FlxState {
		
		private var winText:FlxText;
		override public function create():void {
			var title:FlxText = new FlxText(10, 10, FlxG.width - 20, "Defeat!");
			title.setFormat(C.TITLEFONT, 48, 0xffffff, 'center', 0x1);
			add(title);
			
			winText = new FlxText(10, title.y + title.height + 5,
												FlxG.width - 20, "Out of chances.");
			winText.setFormat(C.FONT, 24, 0xffffff, 'center');
			add(winText);
			
			MenuThing.menuThings = [];
			add(new StateThing("End", MenuState));
			MenuThing.menuThings[0].select();
			
			bgColor = 0xff0a1834;
		}
	}

}