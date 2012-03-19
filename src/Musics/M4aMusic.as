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
		
		public var intendedMusic:MusicTrack;
		public var combatMusic:MusicTrack;
		
		private var track:MusicTrack; //todo
		private var music:String;
		private var player:NetStream;
		private var paused:Boolean;
		private var trackTime:Number;
		
		public var musicVolume:Number;
		public function M4aMusic() {
			musicVolume = 0.5;
		}
		
		public function load():void {
			musicVolume = C.save.read("musicVolume") as Number;
			if (!musicVolume) musicVolume = 0.5;
			else musicVolume -= 0.1;
		}
		
		public function save():void {
			C.save.write("musicVolume", musicVolume+0.1);
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
			
			updateNormalMusic();
		}
		
		protected function updateNormalMusic():void {
			
			if (!music) {
				if (intendedMusic)
					loadTrack();
			} else if (!checkPause())
				checkVolume();
		}
		
		protected function checkPause():Boolean {
			if (FlxG.mute || !MUSIC_VOLUME) {
				if (!paused) {
					player.pause();
					paused = true;
				}
				return true;
			} else if (paused) {
				player.resume();
				paused = false;
			} 
			return false;
		}
		
		protected function checkVolume():void {
			if (track != intendedMusic) {
				incrementVolume(-MUSIC_VOLUME * FlxG.elapsed / FADE_TIME);
				if (player.soundTransform.volume <= 0) {
					if (intendedMusic) 
						loadTrack();
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
		
		protected function checkLoop():void {
			if (track.loops) {
				if (track.intro == -1)
					player.seek(0);
				else
					player.seek(track.intro);
			}
		}
		
		
		
		public function forceSwap(newMusic:MusicTrack):void {
			intendedMusic = newMusic;
			if (intendedMusic)
				loadTrack();
			else
				killMusic();
		}
		
		protected function loadTrack(newTrack:MusicTrack = null):void {
			if (!newTrack) newTrack = intendedMusic;
			track = newTrack;
			if (track.intro)
				loadMusic(MUSIC_VOLUME, track.body);
			else
				loadMusic(0, track.body);
		}
		
		protected function loadMusic(volume:Number = -1, newMusic:String = null):void {
			if (volume == -1) volume = player.soundTransform.volume;
			if (!newMusic) newMusic = intendedMusic.body;
			player.play(newMusic);
			player.resume(); //just in case
			setVolume(volume);
			music = newMusic;
			trackTime = 0;
		}
		
		protected function killMusic():void {
			player.pause();
			music = null;
			track = null;
		}
		
		protected function incrementVolume(amount:Number):void {
			setVolume(player.soundTransform.volume + amount);
		}
		
		protected function setVolume(level:Number):void {
			//if (level == player.soundTransform.volume) return; //premature optimization
			
			var sound:SoundTransform = player.soundTransform;
			sound.volume = level;
			player.soundTransform = sound; //so, so dumb
		}
		
		protected function netStatusHandler(p_evt:NetStatusEvent):void {
			switch (p_evt.info.code) {
				case "NetStream.Play.FileStructureInvalid":
					C.log("The MP4's file structure is invalid.");
					break;
				case "NetStream.Play.NoSupportedTrackFound":
					C.log("The MP4 doesn't contain any supported tracks");
					break;
				case "NetStream.Play.Stop":
					C.log("DEBUG: MP4 stopped");
					checkLoop();
					break;
				default: if (p_evt.info.level == "error")
					C.log("There was some sort of error with the NetStream", p_evt);
					break;
			}
		} 
		
		public const OLD_PLAY_MUSIC:MusicTrack = new MusicTrack("http://pleasingfungus.com/starhaven/music/2-4-2012_2.m4a");
		public const MENU_MUSIC:MusicTrack = new MusicTrack("http://pleasingfungus.com/starhaven/music/Menu_rough.m4a", -1, false);
		public const MUSIC_PREFIX:String = "http://pleasingfungus.com/starhaven/music/";
		
		private function get MUSIC_VOLUME():Number {
			return FlxG.getMuteValue() * musicVolume * FlxG.volume * 2;
		}
		
		public function getMusicVolume():Number {
			return musicVolume;
		}
		public function setMusicVolume(v:Number):Number {
			musicVolume = v;
			save();
			return musicVolume;
		}
		
		private static const FADE_TIME:Number = 1;
		
	}

}