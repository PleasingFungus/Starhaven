package Metagame {
	import org.flixel.*;
	import Scenarios.*;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class Unlocks {
		
		protected var conditions:Array;
		protected var scenarios:Array;
		protected var difficulties:Array;
		protected var newUnlocks:Array;
		public function Unlocks() {
			setupUnlockConditions();
			setDefaults();
		}
		
		protected function setupUnlockConditions():void {
			//asteroid	--	mw1		//1 mission
			//mountain	--	mw3		//3 missions
			//hard		--	md40	//~4 missions?
			//nebula	--	bd150	//~5 missions?
			//water		--	mc2000	//~6 missions?
			//trench	--	mw9		//9 missions
			//v hard	--	mw12	//12 missions
			//dust		--	mw20	//20 missions
			
			conditions = [new UnlockCondition(scLst, C.scenarioList.cIndex(AsteroidScenario), Statblock.MISSIONS_WON, 1, "Asteroid", C.difficulty.EASY),
						  new UnlockCondition(scLst, C.scenarioList.cIndex(MountainScenario), Statblock.MISSIONS_WON, 3, "Mountain", C.difficulty.EASY),
						  new UnlockCondition(dfLst, C.difficulty.HARD, Statblock.METEOROIDS_DESTROYED, 40, C.difficulty.name(C.difficulty.HARD)),
						  new UnlockCondition(scLst, C.scenarioList.cIndex(NebulaScenario), Statblock.BLOCKS_DROPPED, 150, "Nebula"),
						  new UnlockCondition(scLst, C.scenarioList.cIndex(WaterScenario), Statblock.MINERALS_LAUNCHED, 2000, "Sea"),
						  new UnlockCondition(scLst, C.scenarioList.cIndex(TrenchScenario), Statblock.MISSIONS_WON, 150, "Pit"),
						  new UnlockCondition(dfLst, C.difficulty.V_HARD, Statblock.MISSIONS_WON, 8, C.difficulty.name(C.difficulty.V_HARD), C.difficulty.HARD),
						  new UnlockCondition(scLst, C.scenarioList.cIndex(DustScenario), Statblock.MISSIONS_WON, 12, "Dust", C.difficulty.HARD)];
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
			for each (var condition:UnlockCondition in conditions)
				checkUnlock(condition);
			
			if (newUnlocks)
				save();
		}
		
		protected function save():void {
			if (C.DEBUG && C.FORGET_UNLOCKS) return;
			
			C.save.write("unlockedScenarios", scenarios);
			C.save.write("unlockedDifficulties", difficulties);
		}
		
		protected function checkUnlock(condition:UnlockCondition):void {
			if (!condition.holds())
				return; //nothin' to do
			
			if (condition.getAssocList()[condition.listIndex])
				return; //already unlocked
			
			condition.getAssocList()[condition.listIndex] = true;
			if (!newUnlocks)
				newUnlocks = [];
			
			var unlockText:String = condition.name;
			if (condition.getAssocList == scLst)
				unlockText += " Mission";
			else if (condition.getAssocList == dfLst)
				unlockText += " Difficulty";
			unlockText += " [<- " + condition.reqStatValue;
			switch (condition.reqStat) {
				case Statblock.MISSIONS_WON:
					if (condition.reqStatValue == 1)
						unlockText += " mission won";
					else
						unlockText += " missions won";
					break;
				case Statblock.BLOCKS_DROPPED:
					unlockText += " blocks dropped"; break;
				case Statblock.MINERALS_LAUNCHED:
					unlockText += " minerals launched"; break;
				case Statblock.METEOROIDS_DESTROYED:
					unlockText += " meteoroids destroyed"; break;
			}
			unlockText += "]";
			newUnlocks.push(unlockText);
		}
		
		public function createDisplay(Y:int):FlxGroup {
			if (!newUnlocks)
				return null;
			
			var display:FlxGroup = new FlxGroup;
			
			var title:FlxText = new FlxText(10, Y, FlxG.width - 20, "Unlocked:");
			title.setFormat(C.FONT, 24, 0xffffff, 'center');
			display.add(title);
			Y += title.height + 10;
			
			var i:int = 0;
			for each (var unlock:String in newUnlocks) {
				var unlockText:FlxText = new FlxText(10, Y, FlxG.width - 20, unlock);
				unlockText.setFormat(C.FONT, 16, 0xffffff, 'center');
				display.add(unlockText);
				
				if (i & 1) Y += unlockText.height + 5;
				i++;
			}
			
			newUnlocks = null;
			return display;
		}
		
		public function nextUnlockFor(category:int):int {
			for each (var unlock:UnlockCondition in conditions)
				if (!unlock.holds() && unlock.reqStat == category && C.difficulty.initialSetting >= unlock.reqDiff)
					return unlock.reqStatValue;
			return -1;
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
		
		
		protected function scLst():Array {
			return scenarios;
		}
		
		protected function dfLst():Array {
			return difficulties;
		}
	}

}