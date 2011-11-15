package Metagame {
	import org.flixel.*;
	import MainMenu.StateThing;
	import MainMenu.MenuState;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class CampaignVictoryState extends FlxState {
		
		private var winText:FlxText;
		override public function create():void {
			var title:FlxText = new FlxText(10, 10, FlxG.width - 20, "Victory!");
			title.setFormat(C.TITLEFONT, 48, 0xffffff, 'center', 0x1);
			add(title);
			
			winText = new FlxText(10, title.y + title.height + 5,
												FlxG.width - 20, "You win!");
			winText.setFormat(C.FONT, 24, 0xffffff, 'center');
			add(winText);
			
			MenuThing.menuThings = [];
			add(new StateThing("End", MenuState));
		}
		
		private var H:Number = 0;
		private var cyclePeriod:Number = 0.4;
		override public function update():void {
			super.update();
			
			winText.color = C.HSVToRGB(H, 0.9, 0.9);
			
			var H2:Number = H >= 0.5 ? H - 0.5 : H + 0.5;
			FlxState.bgColor = C.HSVToRGB(H2, 1, 0.5);
			
			H += FlxG.elapsed / cyclePeriod;
			if (H >= 1)
				H -= 1;
		}
	}

}