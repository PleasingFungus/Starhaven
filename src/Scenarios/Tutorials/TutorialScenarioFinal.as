package Scenarios.Tutorials {
	import InfoScreens.MissionIntro;
	import GrabBags.BagType;
	import Scenarios.DefaultScenario;
	import Sminos.*;
	import TransitionStates.ScenarioCompleteState;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class TutorialScenarioFinal extends DefaultScenario {
		
		override public function create():void {
			super.create();
			
			setupBags();
			
			trackers.asteroidTracker.active = false;
			
			trackers.period = 80;
			trackers.timer = trackers.nextWave - (trackers.period + 40);
			
			name = "Protector";
			hudLayer.add(new MissionIntro(name, "OBJECTIVES:\n\n- Build a station. Research technology quickly.\n\n- At Tech Level 2 and up, set priorities to focus the type of blocks supplied.\n\n- Use Shield Generators and Torpedo Launchers to fend off the Marauders.\n\n- Survive for "+C.renderTime(VICTORY_TIME)+"!"));
		}
		
		override public function update():void {
			super.update();
			
			if (station.lifespan >= VICTORY_TIME)
				winScenario();
		}
		
		protected function winScenario():void {
			FlxG.state = new ScenarioCompleteState(name);
		}
		
		public static const VICTORY_TIME:int = 240;
		public static const name:String = "Tutorial 5: Final";
		
	}

}