package Scenarios.Tutorials
{
	import GrabBags.BagType;
	import Sminos.SmallLauncher;
	import Missions.LoadedMission;
	import Sminos.Drill;
	import Sminos.Conduit;
	import Sminos.SmallBarracks;
	
	public class BarracksTutorial extends Tutorial
	{
		[Embed(source = "../../../lib/missions/barracks_tutorial.png")] protected static const _map_image:Class;
		
		protected const STORED_MINERALS:int = 300;
		
		public function BarracksTutorial()
		{
			super(_map_image);
			
			goalMultiplier = 1;
			
			spawnTimer = 1;
		}
		
		override public function create():void
		{
			super.create();
			
			hud.updateGoal(0);
		}
	
		override protected function setupBags():void
		{
			bagType = new BagType([SmallBarracks]);
			super.setupBags();
		}
		
		override protected function createTracker(_:Number = 0):void {
			super.createTracker(0);
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