package SFX {
	import org.flixel.FlxG;
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
			if (!volume) volume = 0.5;
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
	}

}