package Meteoroids {
	import HUDs.FlashText;
	import org.flixel.*;
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class MeteoroidTracker extends FlxObject {
		
		public var timer:int;
		public var nextWave:int;
		public var waveIndex:int;
		
		public var warning:Number;
		public var duration:Number;
		public var waveMeteos:Number;
		private var spawnTimer:Number;
		public var waveTime:Number;
		
		public var waveSpacing:int;
		
		public var meteoroids:FlxGroup;
		private var minoLayer:FlxGroup;
		protected var spawner:Spawner;
		protected var next:Meteoroid;
		protected var spawnCount:int;
		
		public static var kills:int;
		
		public function MeteoroidTracker(MinoLayer:FlxGroup, spawnerType:Class, MeteoroidTarget:Mino,
										Duration:Number, Warning:Number, WaveMeteos:Number, WaveSpacing:int) {
			minoLayer = MinoLayer;
			this.spawner = new spawnerType(Warning, MeteoroidTarget);
			
			waveSpacing = WaveSpacing;
			nextWave = getNextWave();
			
			warning = Warning;
			duration = Duration;
			waveMeteos = WaveMeteos;
			if (!C.IN_TUTORIAL)
				waveMeteos = Math.round(waveMeteos * C.difficulty.meteoroidMultiplier);
			C.log("Intial meteos: " + waveMeteos);
			C.log("Wave spacing: " + waveSpacing);
			waveTime = 0;
			kills = 0;
			
			meteoroids = new FlxGroup();
			
			if (!waveMeteos)
				active = false;
		}
		
		protected function getNextWave():int {
			if (waveIndex)
				return waveSpacing * C.difficulty.laterWaveSpacing();
			return waveSpacing * C.difficulty.initialWaveSpacing();
		}
		
		override public function update():void {
			if (waveTime > 0) {
				waveTime -= FlxG.elapsed;
				if (waveTime <= 0)
					endWave();
				else if (waveTime >= warning) {
					spawnTimer += FlxG.elapsed;
					if (spawnTimer >= duration / (waveMeteos + 1)) {
						popMeteoroid();
						spawnTimer -= duration / (waveMeteos + 1);
					}
				}
			}
		}
		
		public function registerDrop():void {
			if (!active)
				return;
			
			timer++;
			C.log("Timer incremented to " + timer + " out of " + nextWave);
			if (timer >= nextWave)
				startWave();
			else if (nextWave == timer + 2)
				FlxG.state.add(new FlashText("Meteors Inbound!", 0xff2020, 2));
		}
		
		protected function popMeteoroid():void {
			if (next)
				next.active = next.visible = next.solid = true;
			spawnCount++;
			if (spawnCount <= waveMeteos) {
				next = spawner.spawnMeteoroid();
				next.active = next.visible = next.solid = false;
				meteoroids.add(next);
			}
		}
		
		protected function endWave():void {
			waveMeteos *= 1.5; //more Meteoroids in each wave
			duration += 2; //slightly longer
			
			timer = 0;
			nextWave = getNextWave();
		}
		
		public function startWave():void {
			waveTime = duration + warning;
			spawnTimer = 0;
			minoLayer.add(meteoroids = new FlxGroup());
			
			C.log("Starting wave. waveMeteos: " + waveMeteos);
			
			spawnCount = 0;
			popMeteoroid();
			waveIndex++;
		}
		
		private function get waveDanger():Boolean {
			return waveTime > 0;// waveOngoing || (nextWave - timer) <= warning;
		}
		
		private function get waveOngoing():Boolean {
			return meteoroids.getFirstAlive() != null;
		}
		
		public function get safe():Boolean {
			return !waveDanger && !waveOngoing;
		}
		
		public function get dangerText():String {
			if (!active)
				return null;
			if (waveOngoing)
				return "METEORS!";
			else if (waveDanger)
				return "INCOMING!";
			else if (C.DEBUG && C.ALWAYS_SHOW_METEOROIDS)
				//TODO?
				return Math.floor(nextWave - timer) + "s";
			else 
				return "Danger: " + dangerFraction();
			//return "ERROR";
		}
		
		protected function dangerFraction():String {
			var fraction:Number = 1 - (nextWave - timer) / nextWave;
			return dangerFor(fraction);
		}
		
		public function debugForceWave(_in:int):void {
			startWave();
			active = true;
		}
		
		protected function dangerFor(fraction:Number):String {
			if (!active)
				return "None";
			
			if (fraction < 0)
				fraction = 0;
			else if (fraction > 1)
				fraction = 1;
			
			var levels:Array = ["Low", "Med.", "High"];
			return levels[Math.floor(fraction * levels.length)];
			//return fraction*100+"%";
		}
	}

}