package Scenarios.Tutorials {
	import GrabBags.BagType;
	import InfoScreens.MissionIntro;
	import Sminos.*;
	import org.flixel.*;
	import TransitionStates.ScenarioCompleteState;
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class TutorialScenarioCrew extends Scenario {
		
		override public function create():void {
			super.create();
			
			trackers.asteroidTracker.active = false;
			trackers.marauderTracker.active = false;
			hud.disableTech();
			hud.disableThreats(); //turn off unnecessary UI
			
			trackers.shipTimer.period -= 20;
			trackers.shipTimer.timer += 20;
			
			setupBags();
			
			(station.core as Smino).powerGen *= 2;
			
			name = "Industrialist";
			hudLayer.add(new MissionIntro(name, "OBJECTIVES:\n\n- Take advantage of newly-available barracks and the Cargo Ship to supply your station with crew.\n\n- Use the crew to staff factories and produce goods.\n\n- Ship "+VICTORY_GOODS+" goods from the station!"));
		}
		
		protected function setupBags():void {
			BagType.all = [];
			
			new BagType("Baginoid", C.GENERAL, 1,
						[Conduit, Conduit, Conduit,
						MediumBarracks, MediumBarracks, MediumBarracks,
						Manufacturing, Manufacturing, Manufacturing,
						Conduit]);
		}
		
		override public function update():void {
			super.update();
			
			//if (shipWasHere && !trackers.shipTimer.paused &&
				//station.stats[C.GOODS] >= VICTORY_GOODS)
				//winScenario();
			//else
				//shipWasHere = trackers.shipTimer.paused; //valid while no asteroids or marauders are around
			if (station.stats[C.GOODS] - station.goods >= VICTORY_GOODS)
				winScenario();
		}
		
		protected function winScenario():void {
			FlxG.state = new ScenarioCompleteState(name);
		}
		
		public static const VICTORY_GOODS:int = 50;
		public static const name:String = "Tutorial 2: Crew";
	}

}