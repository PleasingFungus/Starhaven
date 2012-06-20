package Scenarios.Tutorials
{
	import GrabBags.BagType;
	import Sminos.Conduit;
	import Sminos.Drill;
	import Sminos.LongDrill;
	import Missions.LoadedMission;
	
	public class DrillTutorial extends Tutorial
	{
		public function DrillTutorial()
		{
			super(1);
			
			goalMultiplier = .85;
			
			spawnTimer = 1;
		}
		
		override public function create():void
		{
			super.create();
			
			hud.goalName = "Collected";
			hud.updateGoal(0);
		}
	
		override protected function setupBags():void
		{
			bagType = new BagType([Conduit, Conduit, Conduit, LongDrill, LongDrill]);
			C.difficulty.bagSize = bagType.length;
		}
		
		override protected function buildLevel():void
		{
			super.buildLevel();
			initialMinerals = station.mineralsAvailable;
		}
		
		override protected function addSminos():void
		{
			for each (var smino:Smino in (mission as LoadedMission).loadPieces(levelImage))
			{
				smino.stealthAnchor(station);
				Mino.layer.add(smino);
				Mino.all_minos.push(smino);
				if (smino is Drill && !smino.powered)
					smino.storedMinerals = 50;
			}
		}
		
		override protected function get goalPercent():int
		{
			return station.mineralsMined * 100 / (initialMinerals * goalMultiplier);
		}
	}
}