package SFX {
	import org.flixel.FlxObject;
	import org.flixel.FlxSound;
	import org.flixel.FlxU;
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
			upNoise = new FlxSound().loadEmbedded(POWERUP_NOISE);
			downNoise = new FlxSound;
			upNoise.volume = downNoise.volume = C.sound.volume * 0.25;
		}
		
		override public function update():void {
			if (newPowerup && !upNoise.playing) {
				//upNoise.loadEmbedded(POWERUP_NOISES[int(FlxU.random() * POWERUP_NOISES.length)]);
				//upNoise.volume = 0.25;
				upNoise.play();
			}
			if (newPowerdown && !downNoise.playing)
				downNoise.play();
			newPowerup = newPowerdown = false;
			
			upNoise.update();
			downNoise.update();
		}
		
		[Embed(source = "../../lib/sound/game/powerup_2.mp3")] protected const POWERUP_NOISE:Class;
		//[Embed(source = "../../lib/sound/game/powerup_1.mp3")] protected const _POWERUP_NOISE_1:Class;
		//[Embed(source = "../../lib/sound/game/powerup_2.mp3")] protected const _POWERUP_NOISE_2:Class;
		//protected const POWERUP_NOISES:Array = [_POWERUP_NOISE_1, _POWERUP_NOISE_2];
	}

}