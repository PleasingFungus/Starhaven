package SFX {
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class Fader extends FlxObject {
		
		private var smino:Smino;
		private var timer:Number;
		private var fadeFactor:Number;
		public function Fader(smino:Smino, FadeFactor:Number = 1) {
			super();
			this.smino = smino;
			fadeFactor = FadeFactor;
			timer = FADE_TIME;
			layer.add(this);
		}
		
		override public function update():void {
			timer -= FlxG.elapsed * fadeFactor;
			if (timer <= 0)
				exists = false;
		}
		
		override public function render():void {
			smino.alpha = timer / FADE_TIME;
			smino.render();
		}
		
		public static var layer:FlxGroup;
		private const FADE_TIME:Number = 3;
	}

}