package SFX {
	import org.flixel.FlxG;
	import org.flixel.FlxSound;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class EffectSound {
		
		public var volume:Number;
		public function EffectSound() {
			volume = 0.5;
		}
		
		public function load():void {
			volume = C.save.read("effectVolume") as Number;
			if (isNaN(volume)) volume = 0.5;
		}
		
		public function save():void {
			C.save.write("effectVolume", volume);
		}
		
		public function getVolume():Number {
			return volume;
		}
		
		public function setVolume(n:Number):Number {
			volume = n;
			save();
			return volume;
		}
		
		public function play(sound:Class, Volume:Number = 1):void {
			FlxG.play(sound, Volume * volume);
		}
		
		public function playPersistent(sound:Class, Volume:Number = 1):void {
			var s:FlxSound = new FlxSound();
			s.loadEmbedded(sound);
			s.volume = Volume * volume;
			s.survive = true;
			s.play();
		}
		
		public function back():void {
			playPersistent(BACK_SOUND, 0.5);
		}
		
		[Embed(source = "../../lib/sound/menu/unchoose.mp3")] public const BACK_SOUND:Class;
	}

}