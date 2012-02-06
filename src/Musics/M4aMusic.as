package Musics {
	import flash.media.Video;
	import org.flixel.FlxObject;
	import org.flixel.FlxG;
	import flash.media.SoundTransform;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.events.NetStatusEvent;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class M4aMusic extends FlxObject {
		
		public var intendedMusic:String;
		private var music:String;
		private var player:NetStream;
		private var paused:Boolean;
		public function M4aMusic() {
			
		}
		
		protected function firstTimeInit():void {
			var connect_nc:NetConnection = new NetConnection();
			connect_nc.connect(null);
			
			player = new NetStream(connect_nc);
			player.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			player.client = new Object; 
			
			var video:Video = new Video;
			video.attachNetStream(player);
			FlxG.stage.addChild(video);
		}
		
		override public function update():void {
			if (!player)
				firstTimeInit();
			
			if (!music) {
				if (intendedMusic)
					loadMusic(0);
			} else if (FlxG.mute) {
				if (!paused) {
					player.pause();
					paused = true;
				}
			} else if (paused) {
				player.resume();
				paused = false;
			} else if (music != intendedMusic) {
				incrementVolume(-MUSIC_VOLUME * FlxG.elapsed / FADE_TIME);
				if (player.soundTransform.volume <= 0) {
					if (intendedMusic)
						loadMusic(0);
					else
						killMusic();
				}
			} else if (player.soundTransform.volume < MUSIC_VOLUME) {
				incrementVolume(MUSIC_VOLUME * FlxG.elapsed / FADE_TIME);
				if (player.soundTransform.volume > MUSIC_VOLUME)
					setVolume(MUSIC_VOLUME);
			} else if (player.soundTransform.volume > MUSIC_VOLUME) {
				incrementVolume(-MUSIC_VOLUME * FlxG.elapsed / FADE_TIME);
				if (player.soundTransform.volume < MUSIC_VOLUME)
					setVolume(MUSIC_VOLUME);
			}
		}
		
		public function forceSwap(newMusic:String):void {
			intendedMusic = newMusic;
			loadMusic(MUSIC_VOLUME);
		}
		
		protected function loadMusic(volume:Number):void {
			player.play(intendedMusic);
			player.resume(); //just in case
			setVolume(volume);
			music = intendedMusic;
		}
		
		protected function killMusic():void {
			player.pause();
			music = null;
		}
		
		protected function incrementVolume(amount:Number):void {
			setVolume(player.soundTransform.volume + amount);
		}
		
		protected function setVolume(level:Number):void {
			var sound:SoundTransform = player.soundTransform;
			sound.volume = level;
			player.soundTransform = sound; //so, so dumb
		}
		
		protected function netStatusHandler(p_evt:NetStatusEvent):void {
			if (p_evt.info.code == "NetStream.Play.FileStructureInvalid") {
				C.log("The MP4's file structure is invalid.");
			} else if (p_evt.info.code == "NetStream.Play.NoSupportedTrackFound") {
				C.log("The MP4 doesn't contain any supported tracks");
			} else if (p_evt.info.level == "error") {
				C.log("There was some sort of error with the NetStream", p_evt);
			}
		} 
		
		public const PLAY_MUSIC:String = "http://dl.dropbox.com/u/4070358/Starhaven/2-4-2012_2.m4a";//"../../lib/music/2-4-2012_2.m4a";
		public const MENU_MUSIC:String = null;
		
		
		private static function get MUSIC_VOLUME():Number {
			return FlxG.getMuteValue() * _MUSIC_VOLUME * FlxG.volume;
		}
		private static const _MUSIC_VOLUME:Number = 1;
		private static const FADE_TIME:Number = 1;
		
	}

}