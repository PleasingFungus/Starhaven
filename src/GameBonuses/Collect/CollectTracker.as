package GameBonuses.Collect {
	import Meteoroids.MeteoroidTracker;
	import Meteoroids.Spawner;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class CollectTracker extends MeteoroidTracker {
		
		public function CollectTracker(spawner:Spawner, Duration:Number, Warning:Number, WaveMeteos:Number, WaveSpacing:int) {
			super(spawner, Duration, Warning, WaveMeteos, WaveSpacing);
			
			waveMeteos = WaveMeteos; //ignore difficulty
			
			(spawner as CollectSpawner).setWave(waveMeteos);
			startWave();
		}
		
		override protected function endWave():void {
			if (waveMeteos < 6) {
				waveMeteos += 1;
				duration += 5 / 3;
			}
			
			(spawner as CollectSpawner).setWave(waveMeteos);
			timer = 0;
			nextWave = getNextWave();
		}
		
		override protected function getNextWave():int {
			return waveSpacing;
		}
	}

}