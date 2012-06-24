package Scenarios.Tutorials
{
	import GrabBags.BagType;
	import Missions.LoadedMission;
	import Meteoroids.PlanetSpawner;
	import Sminos.RocketGun;
	import Sminos.SmallBarracks;
	import Globals.GlobalCycleTimer;
	import Meteoroids.Spawner;
	import Meteoroids.MeteoroidTracker;
	
	public class MissileTutorial extends Tutorial
	{
		[Embed(source = "../../../lib/missions/missile_tutorial.png")] protected static const _map_image:Class;
		
		protected const TOTAL_WAVES:int = 1;
		
		public function MissileTutorial()
		{
			super(_map_image);
			
			spawnerType = PlanetSpawner;
			victoryText = "Survived the meteoroids!";
			
			spawnTimer = 1;
		}
		
		override public function create():void
		{
			super.create();
			
			hud.goalName = "Survived";
			hud.updateGoal(0);
			hud.setGoalIcon(C.ICONS[C.METEOROIDS]);
		}
	
		override protected function setupBags():void
		{
			bagType = new BagType([new BagType([SmallBarracks]), new BagType([SmallBarracks, RocketGun]), new BagType([SmallBarracks, RocketGun]), new BagType([SmallBarracks, RocketGun])]);
			super.setupBags();
		}
		
		override protected function getMinoChoice():Class
		{
			if (GlobalCycleTimer.minosDropped < 1)
				return RocketGun;
			else
				return super.getMinoChoice();
		}
		
		override protected function createTracker(waveMeteos:Number = 3):void
		{
			var warning:Number = 1.5;
			var spawner:Spawner = new spawnerType(warning, station.core.absoluteCenter, meteoSpeedMultiplier * C.difficulty.meteoroidSpeedFactor);
			tracker = new MeteoroidTracker(spawner, 15, warning, waveMeteos, bagType.length + 1);
			tracker.shouldPlayKlaxon = !combatMusic || !C.newMusicOK; 
			hud.setTracker(tracker);
			add(tracker);
		}
		
		override protected function get goalPercent():int
		{
			var waveIndex:int = tracker.waveIndex;
			if (!tracker.safe)
				waveIndex -= 1;
			return waveIndex * 100 / TOTAL_WAVES;
		}
	}
}