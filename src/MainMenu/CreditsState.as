package MainMenu {
	import Controls.ControlSet;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class CreditsState extends FlxState {
		
		public function CreditsState() {
			var title:FlxText = new FlxText(0, 15, FlxG.width, "Credits");
			title.setFormat(C.TITLEFONT, 48, 0xffffff, 'center');
			add(title);
			
			var creditsText:FlxText = new FlxText(80, title.y + title.height + 40, FlxG.width - 160, "");
			creditsText.setFormat(C.BLOCKFONT, 16);
			creditsText.text += "Design: Nicholas Feinberg\n\n";
			creditsText.text += "Programming: Nicholas Feinberg\n\n";
			creditsText.text += "Art: Jackson Potter?\n\n";
			creditsText.text += "Fonts: Anna Anthropy\n\n";
			creditsText.text += "Playtesting: James Murff, Ethan Feinberg, Droqen, James Higgins\n\n";
			creditsText.text += "Sound / Music: John Cage\n\n";
			add(creditsText);
			
			//var t:FlxText = new FlxText(0, FlxG.height - 25, FlxG.width, "Press ENTER to go back to the menu.");
			//t.setFormat(C.FONT, 12, 0xffffff, 'center');
			//add(t);
		}
		
		override public function update():void {
			super.update();
			if (ControlSet.CANCEL_KEY.justPressed() || ControlSet.CONFIRM_KEY.justPressed() || FlxG.mouse.justPressed())
				FlxG.state = new MenuState();
		}
	}

}