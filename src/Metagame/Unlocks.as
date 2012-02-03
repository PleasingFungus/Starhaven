package Metagame {
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class Unlocks {
		
		protected var scenarios:Array;
		public function Unlocks() {
			setDefaults();
		}
		
		protected function setDefaults():void {
			if (!scenarios)
				scenarios = [];
			for (var i:int = 0; i <= C.scenarioList.LAST_TUTORIAL_INDEX; i++)
				scenarios[i] = true;
		}
		
		public function load():void {
			if (C.DEBUG && C.FORGET_UNLOCKS) return;
			
			scenarios = C.save.read("unlockedScenarios") as Array;
			setDefaults();
		}
		
		public function unlocked(scenario:Class):Boolean {
			if (C.DEBUG && C.ALL_UNLOCKED)
				return true;
			
			return scenarios[C.scenarioList.all.indexOf(scenario)];
		}
	}

}