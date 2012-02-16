package Scenarios {
	import Missions.DCrescentMission;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class DCrescentScenario extends SpaceScenario {
		
		public function DCrescentScenario(Seed:Number = NaN) {
			super(Seed);
			
			goalMultiplier = 0.6;
			missionType = DCrescentMission;
		}
		
		override protected function repositionLevel():void { }
	}

}