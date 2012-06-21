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
			super.setupBags();
		}
		
		override protected function get goalPercent():int
		{
			return station.mineralsMined * 100 / (initialMinerals * goalMultiplier);
		}
	}
}