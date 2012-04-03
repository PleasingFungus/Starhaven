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
		
		private var _intendedMusic:MusicTrack;
		public function set intendedMusic(m:MusicTrack):void { _intendedMusic = m; C.log('intent = ' + m); }
		public function get intendedMusic():MusicTrack { return _intendedMusic }
		
		private var track:MusicTrack; //todo
		private var music:String;
		private var player:NetStream;
		private var altPlayer:NetStream;
		private var paused:Boolean;
		private var looping:Boolean;
		private var _done:Boolean;
		private var swapTimer:int;
		public function get done():Boolean { return _done }
		
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
			player = makePlayer();
			altPlayer = makePlayer();
		}
		
		protected function makePlayer():NetStream {
			var connect_nc:NetConnection = new NetConnection();
			connect_nc.connect(null);
			
			var player:NetStream = new NetStream(connect_nc);
			player.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			player.client = new Object;
			player.inBufferSeek = true;
			
			var video:Video = new Video;
			video.attachNetStream(player);
			FlxG.stage.addChild(video);
			
			return player;
		}
		
		override public function update():void {
			if (!player)
				firstTimeInit();
			
			updateNormalMusic();
			if (C.DEBUG && FlxG.keys.justPressed("T"))
				C.log("Intended=" + intendedMusic + ", track=" + track);
		}
		
		protected function updateNormalMusic():void {
			
			if (!music) {
				if (intendedMusic)
					loadTrack();
			} else if (!checkPause()) {
				checkVolume();
				checkLoop();
				if (C.DEBUG && FlxG.keys.justPressed("M") && track.loopTime != -1) {
					if (looping)
						swapPlayers();
					player.seek(track.loopTime - 5);
				}
			}
		}
		
		protected function checkPause():Boolean {
			if (FlxG.mute || !MUSIC_VOLUME) {
				if (!paused) {
					player.pause();
					if (looping) altPlayer.pause();
					paused = true;
				}
				return true;
			} else if (paused) {
				player.resume();
				if (looping) altPlayer.resume();
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
			} else if (Math.abs(player.soundTransform.volume - MUSIC_VOLUME) > 0.01) {
				if (track.intro != -1) {
					if (swapTimer)
						swapTimer--;
					else
						setVolume(MUSIC_VOLUME);
				}
				else if (player.soundTransform.volume < MUSIC_VOLUME)
					incrementVolume(MUSIC_VOLUME * FlxG.elapsed / FADE_TIME);
				else if (player.soundTransform.volume > MUSIC_VOLUME)
					incrementVolume(-MUSIC_VOLUME * FlxG.elapsed / FADE_TIME);
			}
		}
		
		protected function checkLoop():void {
			if (track && track.loopTime != -1 && !looping) {
				var toEOT:Number = track.loopTime - player.time;
				if (toEOT < LOOP_GAP) {
					altPlayer.resume(); //implictly set to roughly the right place...?
					looping = true;
					C.log("Looping to " + altPlayer.time +" from "+player.time);
				}
			}
		}
		
		protected function swapPlayers():void {
			if (track.loopTime == -1) {
				_done = true;
				return;
			}
			
			if (!looping) { //emergency loop
				setToBody(player);
				C.log("E-looping to " + player.time);
				return;
			}
			
			var temp:NetStream = player;
			player = altPlayer;
			altPlayer = temp;
			
			setToBody(altPlayer);
			altPlayer.pause();
			
			C.log("looped at " + player.time+'; alt at ' + altPlayer.time);
			
			looping = false;
		}
		
		protected function setToBody(player:NetStream):void {
			if (track.intro == -1) {
				player.seek(0);
				C.log("Sought 0; player at " + player.time);
			} else {
				player.seek(track.intro - LOOP_GAP);
				C.log("Sought intro; player at " + player.time);
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
			C.log("Loading track " + newTrack);
			if (!track && newTrack.intro != -1)
				loadMusic(MUSIC_VOLUME, newTrack.body);
			else {
				loadMusic(0, newTrack.body);
				swapTimer = 15; //prevent the stupid piece of scheiss from playing before it's actually loaded
			}
			
			track = newTrack;
			_done = false;
			
			loadMusic(MUSIC_VOLUME, track.body, altPlayer);
			setToBody(altPlayer);
			altPlayer.pause();
		}
		
		protected function loadMusic(volume:Number = -1, newMusic:String = null, player:NetStream = null):void {
			if (!player) player = this.player;
			if (volume == -1) volume = player.soundTransform.volume;
			if (!newMusic) newMusic = intendedMusic.body;
			
			player.play(newMusic);
			if (!music)
				player.resume();
			setVolume(volume, player);
			
			music = newMusic;
			C.log(music + " loaded into " + (player == this.player ? "primary" : "alternate"));
		}
		
		protected function killMusic():void {
			player.pause();
			if (looping) altPlayer.pause();
			looping = false;
			music = null;
			track = null;
		}
		
		protected function incrementVolume(amount:Number):void {
			setVolume(player.soundTransform.volume + amount);
		}
		
		protected function setVolume(level:Number, player:NetStream = null):void {
			if (!player) player = this.player;
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
					swapPlayers();
					break;
				default: if (p_evt.info.level == "error")
					C.log("There was some sort of error with the NetStream", p_evt);
					break;
			}
		} 
		
		private const STUTTER:Number = 0.25;
		public const MUSIC_PREFIX:String = "http://pleasingfungus.com/starhaven/music/";
		public const OLD_PLAY_MUSIC:MusicTrack = new MusicTrack("UNUSED", MUSIC_PREFIX + "2-4-2012_2.m4a");
		
		
		public const MENU_MUSIC:MusicTrack = new MusicTrack("Starhaven", MUSIC_PREFIX + "starhaven.m4a",
															42.667 + STUTTER, 170.667 + STUTTER);
		public const TUT_MUSIC:MusicTrack = new MusicTrack("Resonance", MUSIC_PREFIX + "resonance.m4a",
															41.739/* + STUTTER*/, 146.087 + STUTTER);
		public const MOON_MUSIC:MusicTrack = new MusicTrack("Surface Tension", MUSIC_PREFIX + "st.m4a",
															12.307692307692 + STUTTER, 160 + STUTTER);
		public const SEA_MUSIC:MusicTrack = new MusicTrack("Surface Tension (Azure Depths)", MUSIC_PREFIX + "st_ad.m4a",
															12.307692307692 + STUTTER, 160 + STUTTER);
		public const AST_MUSIC:MusicTrack = new MusicTrack("Lucid Void", MUSIC_PREFIX + "lv.m4a",
														   17.615/* + STUTTER*/, 158.532 + STUTTER);
		public const DUST_MUSIC:MusicTrack = new MusicTrack("Lucid Void (Forgotten Sector)", MUSIC_PREFIX + "lv_fs.m4a",
															17.615/* + STUTTER*/, 158.532 + STUTTER);
		public const SPACE_COMBAT_MUSIC:MusicTrack = new MusicTrack("Lucid Void (Hull Breach)", MUSIC_PREFIX + "lv_hb.m4a",
																	18.783 + STUTTER, 152.369 + STUTTER);
		public const LAND_COMBAT_MUSIC:MusicTrack = new MusicTrack("Surface Tension (Red Alert)", MUSIC_PREFIX + "st_ra.m4a",
																	33.684 /*+ STUTTER*/, 123.509 + STUTTER);
		public const DEFEAT_MUSIC:MusicTrack = new MusicTrack("Collapse", MUSIC_PREFIX + "defeat.m4a");
		public const VICTORY_MUSIC:MusicTrack = new MusicTrack("I Am The Greatest (VGTG)", MUSIC_PREFIX + "victory.m4a");
		
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
		
		private const FADE_TIME:Number = 1;
		private const LOOP_GAP:Number = 5.0 / 60;
		
	}

}