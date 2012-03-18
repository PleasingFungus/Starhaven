package Metagame {
	import GameBonuses.Attack.AttackLevelOne;
	import GameBonuses.Collect.CollectScenario;
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
		public const LAST_SCENARIO_INDEX:int = 8;
		public function ScenarioList() {
			all = [MiningTutorial, HousingTutorial, DefenseTutorial,
				   PlanetScenario, AsteroidScenario, MountainScenario, NebulaScenario,
				   WaterScenario, DustScenario,
				   AttackLevelOne,
				   CollectScenario];
			names = ["Mining & Power", "Housing & Launching", "Asteroids & Meteoroids",
					 "Moon", "Asteroid", "Mountain", "Nebula",
					 "Sea", "Dust",
					 "Attack-1!",
					 "Collect!"];
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