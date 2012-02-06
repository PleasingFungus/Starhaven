package  {
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class FadeState extends FlxState {
		
		override public function create():void {
			FlxG.flash.start(0xff000000, 0.4); 
			C.resetMouse();
		}
		
		override public function update():void {
			if (!FlxG.fade.exists && !FlxG.flash.exists) {
				super.update();
				C.music.update();
			}
		}
		
		private var fadeTarget:Class;
		protected function fadeTo(state:Class):void {
			fadeTarget = state;
			FlxG.fade.start(0xff000000, 0.4, finishFade);
		}
		
		protected function finishFade():void {
			FlxG.state = new fadeTarget;
		}
	}

}