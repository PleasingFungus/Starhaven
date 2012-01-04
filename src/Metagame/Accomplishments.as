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
		public const FIRST_TUTORIAL_INDEX:int = 0;
		public const LAST_TUTORIAL_INDEX:int = 2;
		
		public var scenariosSeen:Array;
		public var scenariosWon:Array;
		public var campaignsWon:Array;
		public var tutorialDone:Boolean;
		public function Accomplishments() {
			setDefaults();
		}
		
		public function load():void {
			tutorialDone = C.save.read("tutorialDone") as Boolean;
			
			if (C.DEBUG && C.FORGET_ACCOMPLISHMENTS)
				return;
			
			scenariosSeen = C.save.read("scenariosSeen") as Array;
			scenariosWon = C.save.read("scenariosWon") as Array;
			campaignsWon = C.save.read("campaignsWon") as Array;
			setDefaults();
			
			if (C.DEBUG && C.FORGET_TUTORIALS) {
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
			if (!(C.DEBUG && C.FORGET_ACCOMPLISHMENTS))
				C.save.write("scenariosSeen", scenariosSeen);
		}
		
		public function registerVictory(scenario:Scenario):void {
			var index:int = scenarioIndex(scenario);
			var wins:int = scenariosWon[index];
			if (wins)
				scenariosWon[index] += 1;
			else
				scenariosWon[index] = 1;
			if (!(C.DEBUG && C.FORGET_ACCOMPLISHMENTS))
				C.save.write("scenariosWon", scenariosWon);
			
			if (C.campaign)
				registerCampaignVictory();
			if (!tutorialDone && index == LAST_TUTORIAL_INDEX)
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
			if (!(C.DEBUG && C.FORGET_ACCOMPLISHMENTS))
				C.save.write("campaignsWon", campaignsWon);
		}
		
		
		
		public function quickPlayUnlocked():Boolean {
			for (var i:int = LAST_TUTORIAL_INDEX + 1; i < scenarios.length; i++)
				if (scenariosSeen[i])
					return true;
			return false;
		}
		
		public function scenarioIndex(scenario:Scenario):int {
			for (var i:int = 0; i < scenarios.length; i++)
				if (scenario is scenarios[i])
					return i;
			return -1;
		}
	}

}