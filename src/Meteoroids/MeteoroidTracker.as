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
		public var density:Number;
		private var spawnTimer:Number;
		public var waveTime:Number;
		
		public var waveSpacing:int;
		
		public var meteoroids:FlxGroup;
		private var minoLayer:FlxGroup;
		protected var spawner:Spawner;
		
		public function MeteoroidTracker(MinoLayer:FlxGroup, spawnerType:Class, MeteoroidTarget:Mino,
										Duration:Number, Warning:Number, Density:Number, WaveSpacing:int) {
			minoLayer = MinoLayer;
			this.spawner = new spawnerType(Warning, MeteoroidTarget);
			
			waveSpacing = WaveSpacing;
			if (C.difficulty.hard)
				waveSpacing *= .75;
			nextWave = getNextWave();
			
			warning = Warning;
			duration = Duration;
			density = Density;
			if (C.difficulty.hard)
				density = Math.ceil(density * 1.5);
			waveTime = 0;
			
			meteoroids = new FlxGroup();
		}
		
		protected function getNextWave():int {
			if (waveIndex)
				return waveSpacing;
			return waveSpacing*2;
		}
		
		override public function update():void {
			if (waveTime > 0) {
				waveTime -= FlxG.elapsed;
				if (waveTime <= 0)
					endWave();
				else if (waveTime >= warning) {
					spawnTimer += FlxG.elapsed;
					if (spawnTimer >= duration / (density + 1)) {
						spawner.spawnMeteoroid(meteoroids);
						spawnTimer -= duration / (density + 1);
					}
				}
			} else if (GlobalCycleTimer.justDropped) {
				var oldDanger:String = dangerFraction();
				timer++;
				if (timer >= nextWave)
					startWave();
				else if (dangerFraction() == "V. High" && oldDanger != "V. High")
					FlxG.state.add(new FlashText("Meteors Inbound!", 0xff2020, 2));
			}
		}
		
		protected function endWave():void {
			density *= 1.5; //more Meteoroids in each wave
			duration += 2; //slightly longer
			
			timer = 0;
			nextWave = getNextWave();
		}
		
		public function startWave():void {
			waveTime = duration + warning;
			spawnTimer = 0;
			minoLayer.add(meteoroids = new FlxGroup());
			
			C.log("Starting wave. Density: " + density);
			
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
			if (fraction < 0)
				fraction = 0;
			
			var levels:Array = ["Low", "Med.", "High"];
			return levels[Math.floor(fraction * levels.length)];
			//return fraction*100+"%";
		}
	}

}