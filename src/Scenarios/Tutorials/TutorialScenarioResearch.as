package Scenarios.Tutorials {
	import InfoScreens.MissionIntro;
	import GrabBags.BagType;
	import Sminos.*;
	import TransitionStates.ScenarioCompleteState;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class TutorialScenarioResearch extends Scenario {
		
		override public function create():void {
			super.create();
			
			trackers.marauderTracker.active = false;
			hud.disablePriorities();
			
			setupBags();
			
			name = "Technologist";
			hudLayer.add(new MissionIntro(name, "OBJECTIVES:\n\n- Build and staff a series of research labs.\n\n- Use your research labs to generate Science, advance technologically, and improve the quality of blocks available to the station.\n\n- Reach Tech Level 3!"));
		}
		
		protected function setupBags():void {
			BagType.all = [];
			
			new BagType("TL1 General", C.GENERAL, 1,
						[SmallBarracks, SmallLab, Conduit, Conduit],
						1, 1);
			
			new BagType("TL2 General", C.GENERAL, 1,
						[SmallBarracks, SmallLab, Manufacturing, ArmorPlating, Conduit, Conduit],
						2, 2);
			
			new BagType("TL3 General", C.GENERAL, 1,
						[MediumBarracks, SmallLab, Manufacturing, ArmorPlating, SolarPanels, AsteroidGun,
						Conduit, Conduit, Conduit],
						3, 3);
			
			new BagType("TL4 General", C.GENERAL, 1,
						[MediumBarracks, Lab, Manufacturing, SolarPanels, AsteroidGun, ShieldGenerator,
						Conduit, Conduit, Conduit],
						4, 4);
			
			new BagType("TL5 General", C.GENERAL, 1,
						[LargeBarracks, Lab, LargeFactory, SolarPanels, SecondaryReactor, AsteroidGun, ShieldGenerator,
						Conduit, Conduit, Conduit, Conduit],
						5);
		}
		
		override public function update():void {
			super.update();
			
			if (tech.level == 3)
				winScenario();
		}
		
		protected function winScenario():void {
			FlxG.state = new ScenarioCompleteState(name);
		}
		
		public static const name:String = "Tutorial 4: Research";
	}

}