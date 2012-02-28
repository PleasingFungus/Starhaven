package Metagame {
	import flash.display.Bitmap;
	import org.flixel.*;
	import Scenarios.*;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class Unlocks {
		
		protected var conditions:Array;
		
		protected var sizes:Array;
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
			//large		--	mw6		//6 missions
			//crescent	--	mw7		//7 missions
			//v hard	--	mw8		//8 missions
			//dust		--	mw12	//12 missions
			
			conditions = [new UnlockCondition(scLst, C.scenarioList.cIndex(AsteroidScenario), Statblock.MISSIONS_WON, 1, C.scenarioList.nameOf(AsteroidScenario), C.difficulty.EASY),
						  new UnlockCondition(scLst, C.scenarioList.cIndex(MountainScenario), Statblock.MISSIONS_WON, 3,  C.scenarioList.nameOf(MountainScenario), C.difficulty.EASY),
						  new UnlockCondition(dfLst, C.difficulty.HARD, Statblock.METEOROIDS_DESTROYED, 40,C.difficulty.name(C.difficulty.HARD)),
						  new UnlockCondition(scLst, C.scenarioList.cIndex(NebulaScenario), Statblock.BLOCKS_DROPPED, 150, C.scenarioList.nameOf(NebulaScenario)),
						  new UnlockCondition(scLst, C.scenarioList.cIndex(WaterScenario), Statblock.MINERALS_LAUNCHED, 2000, C.scenarioList.nameOf(WaterScenario)),
						  new UnlockCondition(szLst, C.difficulty.LARGE, Statblock.MISSIONS_WON, 6, C.difficulty.scaleName(C.difficulty.LARGE)),
						  //new UnlockCondition(scLst, C.scenarioList.cIndex(DCrescentScenario), Statblock.MISSIONS_WON, 7, C.scenarioList.nameOf(DCrescentScenario)),
						  new UnlockCondition(dfLst, C.difficulty.V_HARD, Statblock.MISSIONS_WON, 8, C.difficulty.name(C.difficulty.V_HARD)),
						  new UnlockCondition(scLst, C.scenarioList.cIndex(DustScenario), Statblock.MISSIONS_WON, 12, C.scenarioList.nameOf(DustScenario))];
		}
		
		protected function setDefaults():void {
			if (!sizes) {
				sizes = [];
				for (i = C.difficulty.SMALL; i <= C.difficulty.MEDIUM; i++)
					sizes[i] = true;
			}
			
			if (!scenarios) {
				scenarios = [];
				for (var i:int = 0; i <= C.scenarioList.FIRST_SCENARIO_INDEX; i++)
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
			
			sizes = C.save.read("unlockedSizes") as Array;
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
			if ((C.DEBUG && C.FORGET_UNLOCKS) || C.ALL_UNLOCKED) return;
			
			C.save.write("unlockedSizes", sizes);
			C.save.write("unlockedScenarios", scenarios);
			C.save.write("unlockedDifficulties", difficulties);
		}
		
		protected function checkUnlock(condition:UnlockCondition):void {
			if (!condition.holds() ||								//nothin' to do
				condition.getAssocList()[condition.listIndex] || 	//already unlocked
				C.ALL_UNLOCKED)										//all-unlock mode
				return;
			
			condition.getAssocList()[condition.listIndex] = true;
			if (!newUnlocks)
				newUnlocks = [];
			
			var unlockText:String = condition.name;
			var assocList:Function = condition.getAssocList;
			if (assocList == scLst)
				unlockText += " Mission";
			else if (assocList == dfLst)
				unlockText += " Difficulty";
			else if (assocList == szLst)
				unlockText += " Size";
			
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
			if (C.ALL_UNLOCKED)
				return true;
			
			return scenarios[C.scenarioList.all.indexOf(scenario)];
		}
		
		public function unlockedScenarios():int { //optional: rewrite to return a list of unlocks
			var unlocked:int = 0;
			for (var i:int = C.scenarioList.FIRST_SCENARIO_INDEX; i < C.scenarioList.all.length; i++)
				if (scenarios[i])
					unlocked++;
			return unlocked;
		}
		
		public function difficultyUnlocked(setting:int):Boolean {
			if (C.ALL_UNLOCKED)
				return true;
			
			return difficulties[setting];
		}
		
		public function unlockedDifficulties():int { //optional: rewrite to return a list of unlocks
			var unlocked:int = 0;
			for (var i:int = C.difficulty.V_EASY; i < C.difficulty.MAX_DIFFICULTY; i++)
				if (difficulties[i])
					unlocked++;
			return unlocked;
		}
		
		public function allowedScenarios():Array {
			var scenarios:Array = [];
			for (var i:int = C.scenarioList.FIRST_SCENARIO_INDEX; i < C.scenarioList.all.length; i++)
				if (scenarioUnlocked(C.scenarioList.all[i]))
					scenarios.push(C.scenarioList.all[i]);
			return scenarios;
		}
		
		public function sizeUnlocked(setting:int):Boolean {
			if (C.ALL_UNLOCKED)
				return true;
			
			C.log("Unlocked: " + setting, sizes[setting]);
			return sizes[setting];
		}
		
		public function unlockedSizes():int {
			var unlocked:int = 0;
			for (var i:int = C.difficulty.SMALL; i < C.difficulty.MAX_SIZE; i++)
				if (sizes[i])
					unlocked++;
			return unlocked;
		}
		
		
		protected function scLst():Array {
			return scenarios;
		}
		
		protected function dfLst():Array {
			return difficulties;
		}
		
		protected function szLst():Array {
			return sizes;
		}
	}

}