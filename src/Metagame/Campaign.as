package Metagame {
	import Sminos.*;
	import Scenarios.*;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class Campaign {
		
		public var missionNo:int;
		public var upgrades:Array;
		public function Campaign() {
			upgrades = [/*new Upgrade(SmallBarracks, LargeBarracks),
						new Upgrade(SmallFab, LargeFactory),
						new Upgrade(Conduit, SecondaryReactor) */ ];
			missionNo = 0;
		}
		
		public function refresh():void {
			for each (var upgrade:Upgrade in upgrades)
				upgrade.used = false;
		}
		
		public function get nextMission():Class {
			return SCENARIO_TYPES[missionNo];
		}
		
		public function endMission():void {
			missionNo++;
			
		}
		
		public function upgradeFor(original:Class):Upgrade {
			for each (var upgrade:Upgrade in upgrades)
				if (!upgrade.used && upgrade.original == original)
					return upgrade;
			return null;
		}
		
		protected const SCENARIO_TYPES:Array = [PlanetScenario, AsteroidScenario, WaterScenario, NebulaScenario];
		
		public static const MISSION_ABORTED:int = 0;
		public static const MISSION_TIMEOUT:int = 1;
		public static const MISSION_MINEDOUT:int = 2;
		public static const MISSION_EXPLODED:int = 3;
	}

}