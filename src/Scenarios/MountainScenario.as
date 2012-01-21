package Scenarios {
	import Missions.MountainMission;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class MountainScenario extends PlanetScenario {
		
		public function MountainScenario(Seed:Number = NaN) {
			super(Seed);
			missionType = MountainMission;
		}
		
		override protected function blockLimitToFullyMine():int {
			return 100;
		}
		
	}

}