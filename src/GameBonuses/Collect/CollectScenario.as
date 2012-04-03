package GameBonuses.Collect {
	import Scenarios.AsteroidScenario;
	import GameBonuses.BonusState;
	import org.flixel.*;
	import flash.geom.Point;
	import GameBonuses.Collect.Sminos.*;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class CollectScenario extends AsteroidScenario {
		
		private var spawner:CollectSpawner;
		private var mineralsLaunched:int;
		public function CollectScenario() {
			super(NaN);
			missionType = CollectMission;
			goalFraction = 1/3; //TODO: tweak?
		}
		
		override public function create():void {
			super.create();
			mineralsLaunched = 0;
		}
		
		override protected function setMaxDim():void {
			C.B.maxDim = new Point(mapDim.x * 4, mapDim.y * 4);
		}
		
		override protected function getAssortment(index:int):Array {
			var assortment:Array = [makeBag(miningTool),  makeBag(SmallLauncherC)];
			if (index)
				assortment.push(makeBag(MediumLauncherC));
			else
				assortment.push(makeBag(miningTool));
				
			if (!(C.DEBUG && C.NO_CREW)) {
				if (index)
					assortment.push(makeBag(MediumBarracksC));
				else
					assortment.push(makeBag(SmallBarracksC));
				assortment.push(makeBag(SmallBarracksC));
			}
			
			return assortment;
		}
		
		override protected function createTracker(waveMeteos:Number = 3):void {
			var warning:Number = 0.5;
			spawner = new CollectSpawner(warning, station.centerOfRotation, 0.7);
			tracker = new CollectTracker(spawner, 5, warning, waveMeteos, bagType.length * 1.5);
			tracker.shouldPlayKlaxon = !combatMusic || !C.newMusicOK; 
			hud.setTracker(tracker);
			add(tracker);
		}
		
		override protected function initCombat():void {
			if (stationHint && stationHint.exists )
				stationHint.visible = false;
			dangeresque = true;
			if (combatMusic && C.newMusicOK)
				C.music.combatMusic = combatMusic; //???
			
			if (initialMinerals && !won()) 
				beginEndgame();
		}
		
		override protected function checkCombatCursor():void { }
		override protected function checkCombatInput():void { }
		
		override protected function endCombat():void {
			if (stationHint && stationHint.exists)
				stationHint.visible = true;
			dangeresque = false;
			C.music.combatMusic = null;
			
			initialMinerals = station.mineralsAvailable + station.mineralsMined; //don't add mineralsMined...?
			mineralsLaunched += station.mineralsLaunched;
			station.mineralsLaunched = 0;
			setBounds(); //new stuff glued to station!
		}
		
		
		override protected function checkRotateControls():void {
			if (!dangeresque)
				super.checkRotateControls();
		}
		
		override protected function compensateForRotation():void {
			super.compensateForRotation();
			spawner.stationFacing = station.core.facing
		}
		
		override protected function checkEndConditions():void {
			if (substate == SUBSTATE_MISSOVER)
				return; //to avoid double-triggering on debug input
			
			if (station.core.damaged)
				beginEndgame();
		}
		
		override protected function resetLevel(_:String):void {
			super.resetLevel(_);
			//TODO?
		}
		
		override protected function getEndText():String {
			if (station.core.damaged)
				return "Station destroyed!";
			return "Goal not reached!";
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