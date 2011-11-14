package InfoScreens {
	import org.flixel.*;
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class MissionIntro extends InfoScreen {
		
		public function MissionIntro(Name:String, Descr:String) {
			super();
			
			var title:FlxText = new FlxText(0, 10, FlxG.width, Name);
			title.setFormat(C.TITLEFONT, 32, 0xffffff, 'center');
			add(title);
			
			
			var description:FlxText = new FlxText(40, title.y + title.height + 15, FlxG.width - 80, Descr);
			description.setFormat(C.BLOCKFONT, 16, 0xffffff);
			add(description);
			
		}
		
	}

}