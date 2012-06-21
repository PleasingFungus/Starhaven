package Scenarios.Tutorials
{
	import GrabBags.BagType;
	import Sminos.SmallLauncher;
	import Missions.LoadedMission;
	
	public class LauncherTutorial extends Tutorial
	{
		protected const STORED_MINERALS:int = 400;
		
		public function LauncherTutorial()
		{
			super(2);
			
			goalMultiplier = .85;
			
			spawnTimer = 1;
		}
		
		override public function create():void
		{
			super.create();
			
			//hud.goalName = "Collected";
			hud.updateGoal(0);
		}
	
		override protected function setupBags():void
		{
			bagType = new BagType([SmallLauncher]);
			super.setupBags();
		}
		
		override protected function buildLevel():void
		{
			super.buildLevel();
			station.mineralsMined = STORED_MINERALS;
		}
		
		override protected function get goalPercent():int
		{
			return station.mineralsLaunched * 100 / (STORED_MINERALS * goalMultiplier);
		}
	}
}