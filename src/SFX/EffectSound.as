package SFX {
	import org.flixel.FlxG;
	import org.flixel.FlxSound;
	import org.flixel.FlxU;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class EffectSound {
		
		public var volume:Number;
		private var crewSound:FlxSound;
		public function EffectSound() {
			volume = 0.5;
			crewSound = new FlxSound()
		}
		
		public function load():void {
			volume = C.save.read("effectVolume") as Number;
			if (!volume) volume = 0.5;
			else volume -= 0.1;
		}
		
		public function save():void {
			C.save.write("effectVolume", volume+0.1);
		}
		
		public function getVolume():Number {
			return volume;
		}
		
		public function setVolume(n:Number):Number {
			volume = n;
			save();
			return volume;
		}
		
		public function play(sound:Class, Volume:Number = 0.5):void {
			FlxG.play(sound, Volume * volume);
		}
		
		public function playPersistent(sound:Class, Volume:Number = 0.5):void {
			var s:FlxSound = new FlxSound();
			s.loadEmbedded(sound);
			s.volume = Volume * volume;
			s.survive = true;
			s.play();
		}
		
		public function back():void {
			playPersistent(BACK_SOUND, 0.25);
		}
		
		public function crew():void {
			crewSound.loadEmbedded(CREW_SOUNDS[int(FlxU.random() * CREW_SOUNDS.length)]);
			crewSound.volume = volume * 0.2;
			crewSound.play();
		}
		
		
		[Embed(source = "../../lib/sound/menu/unchoose.mp3")] public const BACK_SOUND:Class;
		[Embed(source = "../../lib/sound/error.mp3")] public const ERROR_SOUND:Class;
		[Embed(source = "../../lib/sound/game/crew_1.mp3")] private const _CREW_SOUND_1:Class;
		[Embed(source = "../../lib/sound/game/crew_2.mp3")] private const _CREW_SOUND_2:Class;
		[Embed(source = "../../lib/sound/game/crew_3.mp3")] private const _CREW_SOUND_3:Class;
		private const CREW_SOUNDS:Array = [_CREW_SOUND_1, _CREW_SOUND_2, _CREW_SOUND_3];
	}

}