package Scenarios.Tutorials {
	import Sminos.*;
	import InfoScreens.MissionIntro;
	import org.flixel.FlxG;
	import TransitionStates.ScenarioCompleteState;
	import GrabBags.BagType;
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class TutorialScenarioAsteroids extends Scenario {
		
		private var victoryTimer:Number = 0;
		private var asteroidsArrived:Boolean = false;
		
		override public function create():void {
			super.create();
			
			trackers.marauderTracker.active = false;
			trackers.period = 40;
			trackers.timer = trackers.nextWave - trackers.period; //hard-force
			hud.disableTech(); //turn off unnecessary UI
			
			setupBags();
			
			name = "Survivor";
			hudLayer.add(new MissionIntro(name, "OBJECTIVES:\n\n- Plate your station with armor.\n\n- Cover all angles with Defense Beams.\n\n- Survive the wave of asteroids!"));
		}
		
		private function getWaveType(waveIndex:int):int {
			return Trackers.WAVE_ASTEROIDS;
		}
		
		protected function setupBags():void {
			BagType.all = [];
			
			new BagType("Defensebag", C.GENERAL, 1,
						[Conduit, Conduit, Conduit,
						SmallBarracks, SmallBarracks, AsteroidGun, AsteroidGun, ArmorPlating, ArmorPlating]);
		}
		
		override public function update():void {
			super.update();
			
			if (trackers.asteroidTracker.waveOngoing)
				asteroidsArrived = true;
			else if (asteroidsArrived && !trackers.asteroidTracker.waveOngoing) {
				victoryTimer += FlxG.elapsed;
				if (victoryTimer >= VICTORY_TIME)
					winScenario();
			}
		}
		
		protected function winScenario():void {
			FlxG.state = new ScenarioCompleteState(name);
		}
		
		public static const VICTORY_TIME:int = 3;
		public static const name:String = "Tutorial 3: Asteroids";
	}

}