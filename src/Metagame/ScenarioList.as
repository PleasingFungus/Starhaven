package Metagame {
	import Scenarios.*;
	import Scenarios.Tutorials.*;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class ScenarioList {
		
		public var all:Array;
		public const FIRST_TUTORIAL_INDEX:int = 0;
		public const LAST_TUTORIAL_INDEX:int = 2;
		public function ScenarioList() {
			all = [MiningTutorial, HousingTutorial, DefenseTutorial,
				   PlanetScenario, AsteroidScenario, MountainScenario, NebulaScenario,
				   WaterScenario, DustScenario, TrenchScenario];
		}
		
		public function index(scenario:Scenario):int {
			for (var i:int = 0; i < all.length; i++)
				if (scenario is all[i])
					return i;
			return -1;
		}
		
		public function cIndex(scenario:Class):int {
			return all.indexOf(scenario);
		}
	}

}