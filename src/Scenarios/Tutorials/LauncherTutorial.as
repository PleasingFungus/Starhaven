package Scenarios.Tutorials
{
	import GrabBags.BagType;
	import Sminos.SmallLauncher;
	import Missions.LoadedMission;
	import Sminos.Drill;
	import Sminos.Conduit;
	
	public class LauncherTutorial extends Tutorial
	{
		[Embed(source = "../../../lib/missions/launcher_tutorial2.png")] protected static const _map_image:Class;
		
		protected const STORED_MINERALS:int = 100;
		
		public function LauncherTutorial()
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
			bagType = new BagType([Conduit]);
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
		
		override protected function addSminos():void
		{
			for each (var smino:Smino in (mission as LoadedMission).loadPieces(levelImage))
			{
				smino.stealthAnchor(station);
				Mino.layer.add(smino);
				Mino.all_minos.push(smino);
				if (smino is Drill && !smino.powered)
					smino.storedMinerals = 25;
			}
		}
		
		override protected function get goalPercent():int
		{
			return station.mineralsLaunched * 100 / (STORED_MINERALS * goalMultiplier + 50);
		}
	}
}