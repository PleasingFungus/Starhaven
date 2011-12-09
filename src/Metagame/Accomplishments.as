package Metagame {
	import org.flixel.FlxSave;
	import Scenarios.*;
	import Scenarios.Tutorials.*;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class Accomplishments {
		
		
		public const scenarios:Array = [MiningTutorial, HousingTutorial, DefenseTutorial,
										PlanetScenario, AsteroidScenario, WaterScenario,
										NebulaScenario, ShoreScenario, DustScenario];
		
		public var scenariosSeen:Array;
		public var scenariosWon:Array;
		public var campaignsWon:Array;
		public var tutorialDone:Boolean;
		public function Accomplishments() {
			setDefaults();
		}
		
		public function load():void {
			scenariosSeen = C.save.read("scenariosSeen") as Array;
			scenariosWon = C.save.read("scenariosWon") as Array;
			campaignsWon = C.save.read("campaignsWon") as Array;
			tutorialDone = C.save.read("tutorialDone") as Boolean;
			setDefaults();
			if (C.FORGET_TUTORIALS) {
				scenariosSeen[0] = scenariosSeen[1] = scenariosSeen[2] = 0;
				campaignsWon[0] = campaignsWon[1] = campaignsWon[2] = 0;
				tutorialDone = false;
			}
		}
		
		protected function setDefaults():void {
			if (!scenariosSeen)
				scenariosSeen = new Array(scenarios.length);
			if (!scenariosWon)
				scenariosWon = new Array(scenarios.length);
			if (!campaignsWon)
				campaignsWon = new Array(2);
		}
		
		public function registerPlay(scenario:Scenario):void {
			var index:int = scenarioIndex(scenario);
			var plays:int = scenariosSeen[index];
			if (plays)
				scenariosSeen[index] += 1;
			else
				scenariosSeen[index] = 1;
			C.save.write("scenariosSeen", scenariosSeen);
		}
		
		public function registerVictory(scenario:Scenario):void {
			var index:int = scenarioIndex(scenario);
			var wins:int = scenariosWon[index];
			if (wins)
				scenariosWon[index] += 1;
			else
				scenariosWon[index] = 1;
			C.save.write("scenariosWon", scenariosWon);
			
			if (C.campaign)
				registerCampaignVictory();
			if (!tutorialDone && scenario is DefenseTutorial)
				setTutorialsDone();
		}
		
		public function setTutorialsDone():void {
			C.save.write("tutorialDone", tutorialDone = true);
		}
		
		public function registerCampaignVictory():void {
			var wins:int = campaignsWon[C.difficulty.setting];
			if (wins)
				campaignsWon[C.difficulty.setting] += 1;
			else
				campaignsWon[C.difficulty.setting] = 1;
			C.save.write("campaignsWon", campaignsWon);
		}
		
		public function scenarioIndex(scenario:Scenario):int {
			for (var i:int = 0; i < scenarios.length; i++)
				if (scenario is scenarios[i])
					return i;
			return -1;
		}
	}

}