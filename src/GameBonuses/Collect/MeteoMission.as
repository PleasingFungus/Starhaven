package GameBonuses.Collect {
	import Missions.AsteroidMission;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class MeteoMission extends AsteroidMission {
		
		public function MeteoMission(Seed:Number, Scale:Number) {
			super(Seed, Scale);
		}
		
		override protected function getBedrockDepth():Number {
			return 0;
		}
		
		//override protected function randomMineralType():int {
			//return super.randomMineralType() + 1;
		//}
		
		override protected function genMinerals():void {
			for (var i:int = 0; i < 3; i++)
				genCluster(randomClusterSize());
			genNoise();
		}
	}

}