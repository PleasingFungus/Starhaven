package MainMenu {
	import org.flixel.*;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class LockState extends FadeState {
		
		private var message:String;
		public function LockState(Message:String) {
			message = Message;
			super();
		}
		
		override public function create():void {
			C.setPrintReady();
			
			super.create();
			loadBackground(BG);
			
			var title:FlxText = new FlxText(0, 20, FlxG.width, "Starhaven");
			title.setFormat(C.TITLEFONT, 64, 0xffffff, 'center');
			add(title);
			
			var sorry:FlxText = new FlxText(FlxG.width / 8, FlxG.height / 2, FlxG.width * 3/4, message);
			sorry.setFormat(C.FONT, 18, 0xffffff, 'center');
			sorry.y -= sorry.height / 2;
			add(sorry);
			
			C.music.intendedMusic = C.music.MENU_MUSIC;
			bgColor = 0x0;
		}
		
		[Embed(source = "../../lib/art/backgrounds/menu/menu_bg_7s.jpg")] private const BG:Class;
		
	}

}