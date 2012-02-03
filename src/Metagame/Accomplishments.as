package Metagame {
	import org.flixel.FlxSave;
	import Scenarios.*;
	import Scenarios.Tutorials.*;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class Accomplishments {
		
		public var winsByScenario:Array;
		public var winsByDifficulty:Array;
		public var tutorialDone:Boolean;
		public var bestStats:Statblock;
		public function Accomplishments() {
			setDefaults();
		}
		
		public function load():void {
			tutorialDone = C.save.read("tutorialDone") as Boolean;
			
			if (C.DEBUG && C.FORGET_ACCOMPLISHMENTS)
				return;
			
			winsByScenario = C.save.read("winsByScenario") as Array;
			winsByDifficulty = C.save.read("winsByDifficulty") as Array;
			bestStats = Statblock.load("best");
			setDefaults();
			
			if (C.DEBUG && C.FORGET_TUTORIALS) {
				for (var i:int = C.scenarioList.FIRST_TUTORIAL_INDEX; i < C.scenarioList.LAST_TUTORIAL_INDEX; i++)
					winsByScenario[i] = 0;
				tutorialDone = false;
			}
		}
		
		protected function setDefaults():void {
			if (!winsByScenario)
				winsByScenario = new Array(C.scenarioList.all.length);
			if (!winsByDifficulty)
				winsByDifficulty = new Array(C.difficulty.MAX_DIFFICULTY);
			if (!bestStats)
				bestStats = new Statblock(0, 0, 0, 0);
		}
		
		public function registerVictory(scenario:Scenario):void {
			var index:int = C.scenarioList.index(scenario);
			var wins:int = winsByScenario[index];
			if (wins)
				winsByScenario[index] += 1;
			else
				winsByScenario[index] = 1;
			saveRecord(winsByDifficulty, "winsByDifficulty");
			
			index = Math.floor(C.difficulty.setting);
			wins = winsByDifficulty[index];
			if (wins)
				winsByDifficulty[index] += 1;
			else
				winsByDifficulty[index] = 1;
			saveRecord(winsByScenario, "winsByScenario");
			
			if (!tutorialDone && index >= C.scenarioList.LAST_TUTORIAL_INDEX)
				setTutorialsDone();
		}
		
		public function setTutorialsDone():void {
			C.save.write("tutorialDone", tutorialDone = true);
		}
		
		public function registerRecords(missionsCompleted:int, statblock:Statblock):void {
			if (statblock.missionsWon > bestStats.missionsWon)
				bestStats.missionsWon = statblock.missionsWon;
			if (statblock.blocksDropped > bestStats.blocksDropped)
				bestStats.blocksDropped = statblock.blocksDropped;
			if (statblock.mineralsLaunched > bestStats.mineralsLaunched)
				bestStats.mineralsLaunched = statblock.mineralsLaunched;
			if (statblock.meteoroidsDestroyed > bestStats.meteoroidsDestroyed)
				bestStats.meteoroidsDestroyed = statblock.meteoroidsDestroyed;
			if (canSave)
				bestStats.save("best");
		}
		
		protected function saveRecord(data:*, name:String):void {
			if (canSave) {
				C.log("Saving " + name + ": " + data);
				C.save.write(name, data);
			}
		}
		
		public function nextUnbeaten():Class {
			for (var i:int = C.scenarioList.FIRST_TUTORIAL_INDEX; i < C.scenarioList.LAST_TUTORIAL_INDEX; i++)
				if (!winsByScenario[i])
					return C.scenarioList.all[i];
			return C.scenarioList.all[0]; //?
		}
		
		protected function get canSave():Boolean {
			return !(C.DEBUG && C.FORGET_ACCOMPLISHMENTS);
		}
	}

}