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
			
			startWave();
		}
		
		override protected function getNextWave():int {
			return waveSpacing;
		}
	}

}