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
		public var bestStats:Vector.<Statblock>;
		public var grindPoints:int;
		public var bonusHighScores:Array;
		public function Accomplishments() {
			setDefaults();
		}
		
		public function load():void {
			var i:int;
			
			tutorialDone = C.save.read("tutorialDone") as Boolean;
			
			if (C.DEBUG && C.FORGET_ACCOMPLISHMENTS)
				return;
			
			winsByScenario = C.save.read("winsByScenario") as Array;
			winsByDifficulty = C.save.read("winsByDifficulty") as Array;
			
			bestStats = new Vector.<Statblock>;
			for (i = C.difficulty.V_EASY; i < C.difficulty.MAX_DIFFICULTY; i++)
				bestStats.push(Statblock.load(i+"best"));
			
			bonusHighScores = C.save.read("bonusHighscores") as Array;
			grindPoints = C.save.read('grindPoints') as int;
			setDefaults();
			
			if (C.DEBUG && C.FORGET_TUTORIALS) {
				for (i = C.scenarioList.FIRST_TUTORIAL_INDEX; i <= C.scenarioList.LAST_TUTORIAL_INDEX; i++)
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
				bestStats = new Vector.<Statblock>;
			for (var i:int = C.difficulty.V_EASY; i < C.difficulty.MAX_DIFFICULTY; i++)
				if (i >= bestStats.length)
					bestStats.push(new Statblock(0, 0, 0, 0, 0, 0));
				else if (!bestStats[i])
					bestStats[i] = new Statblock(0, 0, 0, 0, 0, 0);
			
			if (!bonusHighScores)
				bonusHighScores = [-1, -1, -1, -1, -1];
			//grindPoints defaults to 0
		}
		
		public function registerVictory(scenario:Scenario):void {
			var index:int = C.scenarioList.index(scenario);
			var wins:int = winsByScenario[index];
			if (wins)
				winsByScenario[index] += 1;
			else
				winsByScenario[index] = 1;
			saveRecord(winsByDifficulty, "winsByDifficulty");
			
			var difIndex:int = Math.floor(C.difficulty.setting);
			wins = winsByDifficulty[difIndex];
			if (wins)
				winsByDifficulty[difIndex] += 1;
			else
				winsByDifficulty[difIndex] = 1;
			saveRecord(winsByScenario, "winsByScenario");
			
			var indexOK:Boolean = index >= C.scenarioList.LAST_TUTORIAL_INDEX;
			if (!indexOK)
				C.log(index +" vs " + C.scenarioList.LAST_TUTORIAL_INDEX);
			if (!tutorialDone && indexOK)
				setTutorialDone();
		}
		
		public function setTutorialDone():void {
			C.log("Tutorial over!");
			tutorialDone = true;
			C.save.write("tutorialDone", tutorialDone);
			C.netStats.finishTutorial(totalTutorialsBeaten()); 
			C.IN_TUTORIAL = false;
		}
		
		private function totalTutorialsBeaten():int {
			var total:int = 0;
			for (var i:int = C.scenarioList.FIRST_TUTORIAL_INDEX; i <= C.scenarioList.LAST_TUTORIAL_INDEX; i++)
				if (winsByScenario[i])
					total++;
			return total;
		}
		
		public function registerRecords(missionsCompleted:int, statblock:Statblock):void {
			var bestStat:Statblock = this.bestStat;
			if (statblock.missionsWon > bestStat.missionsWon)
				bestStat.missionsWon = statblock.missionsWon;
			if (statblock.blocksDropped > bestStat.blocksDropped)
				bestStat.blocksDropped = statblock.blocksDropped;
			if (statblock.mineralsLaunched > bestStat.mineralsLaunched)
				bestStat.mineralsLaunched = statblock.mineralsLaunched;
			if (statblock.meteoroidsDestroyed > bestStat.meteoroidsDestroyed)
				bestStat.meteoroidsDestroyed = statblock.meteoroidsDestroyed;
			
			if (canSave)
				bestStat.save(C.difficulty.initialSetting + "best");
			
			grindPoints += statblock.mineralsLaunched;
			if (canSave)
				C.save.write('grindPoints', grindPoints);
			
			C.unlocks.checkUnlocks();
		}
		
		public function get bestStat():Statblock {
			return bestStats[C.difficulty.initialSetting];
		}
		
		public function registerBonusReverseScore(livesLeft:int):void {
			var curScore:int = bonusHighScores[BONUS_REVERSE];
			if (livesLeft > curScore) {
				bonusHighScores[BONUS_REVERSE] = livesLeft;
				C.save.write("bonusHighscores", bonusHighScores);
			}
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
			return !((C.DEBUG && C.FORGET_ACCOMPLISHMENTS) || C.ALL_UNLOCKED);
		}
		
		public const BONUS_REVERSE:int = 0;
		public const BONUS_COLLECT:int = 1;
	}

}