package Metagame {
	import Scenarios.*;
	import Scenarios.Tutorials.*;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class ScenarioList {
		
		public var all:Array;
		public var names:Array;
		public const FIRST_TUTORIAL_INDEX:int = 0;
		public const LAST_TUTORIAL_INDEX:int = 2;
		public const FIRST_SCENARIO_INDEX:int = 3;
		public function ScenarioList() {
			all = [MiningTutorial, HousingTutorial, DefenseTutorial,
				   PlanetScenario, AsteroidScenario, MountainScenario, NebulaScenario,
				   WaterScenario, DustScenario];
			names = ["1 - Mining & Power", "2 - Housing & Launching", "3 - Asteroids & Meteoroids",
					 "Moon", "Asteroid", "Mountain", "Nebula",
					 "Sea", "Dust"];
		}
		
		public function index(scenario:Scenario):int {
			return cIndex(getDefinitionByName(getQualifiedClassName(scenario)) as Class);
		}
		
		public function cIndex(scenario:Class):int {
			return all.indexOf(scenario);
		}
		
		public function nameOf(scenario:Class):String {
			return names[cIndex(scenario)];
		}
	}

}