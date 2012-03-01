package MainMenu {
	import Globals.Timelock;
	import org.flixel.*;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class WaitState extends FadeState {
		
		private var lock:Timelock;
		override public function create():void {
			lock = new Timelock;
			
			var waiting:FlxText = new FlxText(FlxG.width / 8, FlxG.height / 2, FlxG.width * 3/4, "Waiting...");
			waiting.setFormat(C.FONT, 18, 0xffffff, 'center');
			waiting.y -= waiting.height / 2;
			add(waiting);
		}
		
		override public function update():void {
			super.update();
			if (lock.loaded)
				FlxG.state = lock.locked ? new LockState(lock.lockMessage) : new MenuState;
		}
		
	}

}