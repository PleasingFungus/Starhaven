package Startup {
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class CrashState extends FlxState {
		
		override public function create():void {
			var title:FlxText = new FlxText(0, 20, FlxG.width, "Starhaven has crashed :(");
			title.setFormat(C.FONT, 24, 0xffffff, 'center');
			add(title);
			
			var description:String = "We're very sorry for the inconvenience!";
			description += " If you can report the crash details - what you were doing when the crash happened, what scenario you were in (if any), and anything else that seems relevant - along with the version number (" + C.VERSION + "), that would be *extremely helpful.*";
			description += "\n\nThe developer's email is pleasingfung@gmail.com.";
			description += "\n\nOtherwise, just refresh the page to restart the game. Hopefully it won't crash again?";
			
			var descrText:FlxText = new FlxText(20, FlxG.height / 2, FlxG.width - 40, description);
			descrText.setFormat(C.FONT, 16, 0xffffff, 'center');
			descrText.y -= descrText.height / 2;
			add(descrText);
		}
		
	}

}