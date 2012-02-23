package SFX {
	import org.flixel.FlxObject;
	import org.flixel.FlxSound;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class PowerSound extends FlxObject {
		
		protected var upNoise:FlxSound;
		protected var downNoise:FlxSound;
		public var newPowerup:Boolean;
		public var newPowerdown:Boolean;
		public function PowerSound() {
			super();
			//upNoise = new FlxSound().loadEmbedded(POWERUP_NOISE);
			downNoise = new FlxSound;
			upNoise.volume = downNoise.volume = C.sound.volume;
		}
		
		override public function update():void {
			if (newPowerup && !upNoise.playing)
				upNoise.play();
			if (newPowerdown && !downNoise.playing)
				downNoise.play();
			newPowerup = newPowerdown = false;
			
			upNoise.update();
			downNoise.update();
		}
		
		//[Embed(source = "../../lib/sound/game/powerup2.mp3")] protected const POWERUP_NOISE:Class;
	}

}