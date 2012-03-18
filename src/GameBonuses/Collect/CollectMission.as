package GameBonuses.Collect {
	import Missions.AsteroidMission;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class CollectMission extends AsteroidMission {
		
		public function CollectMission(Seed:Number, _:Number) {
			super(Seed, 0.55);
		}
		
		override protected function genMinerals():void { }
	}

}