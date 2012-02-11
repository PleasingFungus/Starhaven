package Scenarios {
	import Missions.DCrescentMission;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class DCrescentScenario extends SpaceScenario {
		
		public function DCrescentScenario(Seed:Number = NaN) {
			super(Seed);
			
			goal = 0.75;
			missionType = DCrescentMission;
		}
		
		override protected function blockLimitToFullyMine():int {
			return 100;
		}
		
		override protected function repositionLevel():void { }
	}

}