package Scenarios.Tutorials
{
	import GrabBags.BagType;
	import Sminos.Conduit;
	import Sminos.Drill;
	import Sminos.LongDrill;
	import Missions.LoadedMission;
	import Globals.GlobalCycleTimer;
	
	public class DrillTutorial extends Tutorial
	{
		[Embed(source = "../../../lib/missions/drill_tutorial.png")] protected static const _map_image:Class;
		
		public function DrillTutorial()
		{
			super(_map_image);
			
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
		
		override protected function getMinoChoice():Class
		{
			if (GlobalCycleTimer.minosDropped < 1)
				return LongDrill;
			else
				return super.getMinoChoice();
		}
		
		override protected function createTracker(_:Number = 0):void {
			super.createTracker(0);
		}
		
		override protected function get goalPercent():int
		{
			return (station.mineralsMined + station.mineralsLaunched) * 100 / (initialMinerals * goalMultiplier);
		}
	}
}