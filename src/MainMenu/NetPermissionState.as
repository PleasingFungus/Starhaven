package MainMenu {
	import org.flixel.*;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class NetPermissionState extends FadeState {
		
		override public function create():void {
			var question:FlxText = new FlxText(FlxG.width / 8, FlxG.height / 2, FlxG.width * 3 / 4, "Are you OK with anonymized gameplay information (level win stats, crash reports, etc) being sent to the developer?" +
																									"\n\nThey're very helpful for improving the game.");
			question.setFormat(C.FONT, 18, 0xffffff, 'center');
			question.y -= question.height / 2;
			add(question);
			
			MenuThing.resetThings();
			
			var ok:MenuThing = new MenuThing("Yes", accept, false);
			ok.setX(FlxG.width / 4 - ok.fullWidth / 2);
			ok.setY(FlxG.height - 40);
			ok.select();
			add(ok);
			
			var no:MenuThing = new MenuThing("No", reject, false);
			no.setX(FlxG.width * 3/4 - no.fullWidth / 2);
			no.setY(FlxG.height - 40);
			add(no);
			
			FlxG.mouse.show();
		}
		
		protected function accept(_:String = null):void {
			C.netStats.setAllowed(1);
			fadeTo(MenuState);
		}
		
		protected function reject(_:String = null):void {
			C.netStats.setAllowed(0);
			fadeTo(MenuState);
		}
	}

}