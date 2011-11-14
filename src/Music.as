package 
{
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	/**
	 * ...
	 * @author ...
	 */
	public class Music extends FlxObject
	{
		private var music:Class;
		public var intendedMusic:Class;
		
		public function Music() {
			//intendedMusic = MENU_MUSIC;
		}
		
		override public function update():void {
			if (!music) {
				FlxG.playMusic(intendedMusic, 0);
				music = intendedMusic;
				return;
			}
			
			if (music != intendedMusic) {
				FlxG.music.volume -= MUSIC_VOLUME * FlxG.elapsed / FADE_TIME;
				if (FlxG.music.volume <= 0) {
					FlxG.playMusic(intendedMusic, 0);
					music = intendedMusic;
				}
			} else if (FlxG.music.volume < MUSIC_VOLUME) {
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
		
		//[Embed(source = "../lib/music/temp_menu_l.mp3")] public static const MENU_MUSIC:Class;
		//[Embed(source = "../lib/music/temp_game_l.mp3")] public static const PLAY_MUSIC:Class;
		
		private static const MUSIC_VOLUME:Number = .4;
		private static const FADE_TIME:Number = 1;
	}

}