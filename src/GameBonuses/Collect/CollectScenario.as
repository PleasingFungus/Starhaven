package GameBonuses.Collect {
	import Scenarios.AsteroidScenario;
	import GameBonuses.BonusState;
	import org.flixel.*;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class CollectScenario extends AsteroidScenario {
		
		private var spawner:CollectSpawner;
		public function CollectScenario() {
			super(NaN);
			missionType = CollectMission;
		}
		
		override public function create():void {
			super.create();
		}
		
		override protected function setMaxDim():void {
			C.B.maxDim = new Point(mapDim.x * 4, mapDim.y * 4);
		}
		
		override protected function createTracker(waveMeteos:Number = 3):void {
			var warning:Number = 0.5;
			spawner = new CollectSpawner(warning, station.centerOfRotation, 0.7);
			tracker = new CollectTracker(spawner, 5, warning, waveMeteos, bagType.length);
			tracker.shouldPlayKlaxon = !combatMusic || !C.newMusicOK; 
			hud.setTracker(tracker);
			add(tracker);
		}
		
		override protected function initCombat():void {
			if (stationHint && stationHint.exists )
				stationHint.visible = false;
			dangeresque = true;
			if (combatMusic && C.newMusicOK)
				C.music.combatMusic = combatMusic;
		}
		
		override protected function checkCombatCursor():void { }
		override protected function checkCombatInput():void { }
		
		override protected function endCombat():void {
			if (stationHint && stationHint.exists)
				stationHint.visible = true;
			dangeresque = false;
			C.music.combatMusic = null;
			
			setBounds(); //new stuff glued to station!
		}
		
		
		override protected function checkRotateControls():void {
			if (!dangeresque)
				super.checkRotateControls();
		}
		
		override protected function compensateForRotation():void {
			super.compensateForRotation();
			spawner.stationFacing = station.core.facing
			C.log(spawner.stationFacing);
		}
		
		override protected function get goalPercent():int {
			return 0; //irrelevant
		}
		
		override protected function checkEndConditions():void {
			if (substate == SUBSTATE_MISSOVER)
				return; //to avoid double-triggering on debug input
			
			//TODO
		}
		
		override protected function resetLevel(_:String):void {
			super.resetLevel(_);
			//TODO?
		}
		
		override protected function getEndText():String {
			return "Time's Up!";
		}
		
		override protected function contemplateShaking():void { } //nope
		
		override protected function registerEnd(quit:Boolean):void {
			//TODO [high scores]
		}
		
		override protected function endGame():void {
			FlxG.state = new BonusState;
		}
		
		override protected function exitToMenu(_:String = null):void {
			FlxG.state = new BonusState;
		}
	}

}