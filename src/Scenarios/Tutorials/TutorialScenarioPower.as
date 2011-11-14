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
	public class TutorialScenarioPower extends Scenario {
		
		override public function create():void {
			super.create();
			
			trackers.active = false; //disable attacks, ship
			hud.disableShip();
			hud.disableTech();
			hud.disableThreats();//turn off unnecessary UI
			
			setupBags();
			
			(station.core as Smino).powerGen *= 3;
			
			name = "Powermonger";
			hudLayer.add(new MissionIntro(name, "OBJECTIVES:\n- Learn how to control your new Clark-class station\n\n- Deploy Microwave Transmitters to earn money \n\n- Accumulate $" + VICTORY_CASH + "!"));
		}
		
		protected function setupBags():void {
			BagType.all = [];
			
			new BagType("Baguette", C.GENERAL, 1,
						[Conduit, Conduit, MicrowaveTransmitter, MicrowaveTransmitter, MicrowaveTransmitter]);
		}
		
		override public function update():void {
			super.update();
			if (station.cash >= VICTORY_CASH)
				winScenario();
		}
		
		protected function winScenario():void {
			FlxG.state = new ScenarioCompleteState(name);
		}
		
		public static const VICTORY_CASH:int = 888;
		public static const name:String = "Tutorial 1: Power";
	}

}