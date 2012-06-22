package Scenarios.Tutorials
{
	import GrabBags.BagType;
	import Sminos.Conduit;
	import Sminos.Drill;
	import Missions.LoadedMission;
	
	public class ConduitTutorial extends Tutorial
	{
		[Embed(source = "../../../lib/missions/conduit_tutorial.png")] protected static const _map_image:Class;
		
		public function ConduitTutorial()
		{
			super(_map_image);
			
			goalMultiplier = 1;
			
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
			bagType = new BagType([Conduit]);
			super.setupBags();
		}
		
		override protected function createTracker(_:Number = 0):void {
			super.createTracker(0);
		}
		
		override protected function buildLevel():void
		{
			super.buildLevel();
			station.mineralsMined = 50;
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
			return station.mineralsMined * 100 / 200;
		}
	}
}