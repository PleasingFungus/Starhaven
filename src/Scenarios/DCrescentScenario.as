package Scenarios {
	import Missions.DCrescentMission;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class DCrescentScenario extends SpaceScenario {
		
		public function DCrescentScenario(Seed:Number = NaN) {
			super(Seed);
			
			goal = 0.6;
			missionType = DCrescentMission;
		}
		
		override protected function blockLimitToFullyMine():int {
			return 85;
		}
		
		override protected function repositionLevel():void { }
	}

}