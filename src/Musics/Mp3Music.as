package Musics
{
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	/**
	 * ...
	 * @author ...
	 */
	public class Mp3Music extends FlxObject
	{
		private var music:Class;
		public var intendedMusic:Class;
		
		//NOTE: will need load, save, getMusicVolume, setMusicVolume to work again!
		public function Mp3Music() {
			
		}
		
		override public function update():void {
			if (!music && intendedMusic) {
				FlxG.playMusic(intendedMusic, 0);
				music = intendedMusic;
				return;
			}
			
			if (music != intendedMusic) {
				FlxG.music.volume -= MUSIC_VOLUME * FlxG.elapsed / FADE_TIME;
				if (FlxG.music.volume <= 0) {
					if (intendedMusic)
						FlxG.playMusic(intendedMusic, 0);
					else
						FlxG.music.stop();
					music = intendedMusic;
				}
			} else if (music && FlxG.music.volume < MUSIC_VOLUME) {
				FlxG.music.volume += MUSIC_VOLUME * FlxG.elapsed / FADE_TIME;
				if (FlxG.music.volume > MUSIC_VOLUME)
					FlxG.music.volume = MUSIC_VOLUME;
			}
		}
		
		public function forceSwap(newMusic:Class):void {
			intendedMusic = newMusic;
			FlxG.playMusic(intendedMusic, 0);
			music = intendedMusic;
		}
		
		//[Embed(source = "../../lib/music/temp_menu_l.mp3")] public static const MENU_MUSIC:Class;
		//[Embed(source = "../../lib/music/temp_game_l.mp3")] public static const OLD_PLAY_MUSIC:Class;
		[Embed(source = "../../lib/music/2-4-2012_2.mp3")] public const OLD_PLAY_MUSIC:Class;
		public const MENU_MUSIC:* = null;
		
		private static const MUSIC_VOLUME:Number = .6;
		private static const FADE_TIME:Number = 1;
	}

}