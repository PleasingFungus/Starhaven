package Metagame {
	import org.flixel.FlxGroup;
	import Scenarios.*;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class Unlocks {
		
		protected var scenarios:Array;
		protected var difficulties:Array;
		protected var newUnlocks:Array;
		public function Unlocks() {
			setDefaults();
		}
		
		protected function setDefaults():void {
			if (!scenarios) {
				scenarios = [];
				for (var i:int = 0; i <= C.scenarioList.LAST_TUTORIAL_INDEX + 1; i++)
					scenarios[i] = true;
			}
			
			if (!difficulties) {
				difficulties = [];
				for (i = C.difficulty.V_EASY; i <= C.difficulty.NORMAL; i++)
					difficulties[i] = true;
			}
		}
		
		public function load():void {
			if (C.DEBUG && C.FORGET_UNLOCKS) return;
			
			scenarios = C.save.read("unlockedScenarios") as Array;
			difficulties = C.save.read("unlockedDifficulties") as Array;
			setDefaults();
		}
		
		public function checkUnlocks():void {
			//missions won
			checkUnlock(C.accomplishments.bestStats.missionsWon >= 1, scenarios,
						C.scenarioList.cIndex(AsteroidScenario), "Asteroid Mission");
			
			//blocks dropped
			//minerals collected
			//meteoroids destroyed
			
			if (newUnlocks)
				save();
		}
		
		protected function save():void {
			if (C.DEBUG && C.FORGET_UNLOCKS) return;
			
			C.save.write("unlockedScenarios", scenarios);
			C.save.write("unlockedDifficulties", difficulties);
		}
		
		protected function checkUnlock(shouldBeUnlocked:Boolean, list:Array, index:int, name:String):void {
			if (!shouldBeUnlocked)
				return; //nothin' to do
			
			if (list[index])
				return; //already unlocked
			
			list[index] = true;
			newUnlocks.push(name);
		}
		
		public function createDisplay(Y:int):FlxGroup {
			if (!newUnlocks)
				return null;
			
			newUnlocks = null;
			return null;
		}
		
		public function scenarioUnlocked(scenario:Class):Boolean {
			if (C.DEBUG && C.ALL_UNLOCKED)
				return true;
			
			return scenarios[C.scenarioList.all.indexOf(scenario)];
		}
		
		public function difficultyUnlocked(setting:int):Boolean {
			if (C.DEBUG && C.ALL_UNLOCKED)
				return true;
			
			return difficulties[setting];
		}
		
		public function allowedScenarios():Array {
			var scenarios:Array = [];
			for (var i:int = C.scenarioList.LAST_TUTORIAL_INDEX + 1; i < C.scenarioList.all.length; i++)
				if (scenarioUnlocked(C.scenarioList.all[i]))
					scenarios.push(C.scenarioList.all[i]);
			return scenarios;
		}
	}

}