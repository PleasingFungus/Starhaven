package SFX {
	import org.flixel.FlxObject;
	import org.flixel.FlxSound;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class PickupSound extends FlxObject {
		
		protected var smallChime:FlxSound;
		protected var largeChime:FlxSound;
		protected var largeChimeQueued:Boolean;
		public function PickupSound() {
			super();
			
			smallChime = new FlxSound().loadEmbedded(COLLECT_NOISE);
			largeChime = new FlxSound().loadEmbedded(BIG_COLLECT_NOISE);
			smallChime.volume = largeChime.volume = C.sound.volume;
		}
		
		override public function update():void {
			if (largeChimeQueued && !smallChime.playing) {
				largeChime.play();
				largeChimeQueued = false;
			}
			smallChime.update();
			largeChime.update();
		}
		
		public function playSmallChime():void {
			if (!largeChime.playing)
				smallChime.play();
		}
		
		public function playLargeChime():void {
			if (!smallChime.playing)
				largeChime.play();
			else
				largeChimeQueued = true;
		}
		
		public function get playing():Boolean {
			return largeChime.playing || smallChime.playing;
		}
		
		[Embed(source = "../../lib/sound/game/pickup2.mp3")] protected const COLLECT_NOISE:Class;
		[Embed(source = "../../lib/sound/game/bigpickup.mp3")] protected const BIG_COLLECT_NOISE:Class;
	}

}