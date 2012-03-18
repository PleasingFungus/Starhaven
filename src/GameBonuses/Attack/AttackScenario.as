package GameBonuses.Attack {
	import GameBonuses.BonusState;
	import HUDs.MapBounds;
	import Meteoroids.SlowRocket;
	import Missions.LoadedMission;
	import Scenarios.DefaultScenario;
	import org.flixel.*;
	import Mining.PlanetMaterial;
	import Controls.ControlSet;
	import flash.geom.Point;
	import Sminos.RocketGun;
	import Sminos.SecondaryReactor;
	import Editor.StationLoader;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class AttackScenario extends DefaultScenario {
		
		protected var initialLives:int;
		
		public function AttackScenario() {
			super(NaN);
			
			rotateable = false;
			canFastfall = false;
			C.B.viewLimited = true;
			mapBuffer = 0;
		}
		
		private var arrowHint:AttackHelper;
		protected var aggregate:Aggregate;
		protected var stations:Vector.<Station>
		protected var lives:int;
		
		protected var gunTimers:Array;
		protected const GUN_COOLDOWN:Number = 2.4;
		
		override public function create():void {
			lives = initialLives;
			stations = new Vector.<Station>;
			
			super.create();
			
			spawnTimer /= 2;
			
			initCombatMinoPool();
		}
		
		override protected function registerStart():void { }
		
		override protected function createStation():void {
			setBounds();
			buildLevel();
		}
		
		override protected function setBounds():void {
			if (!aggregate) return;
			
			C.B.StationBounds = aggregate.bounds;
			C.B.PlayArea = aggregate.bounds; //spawns a copy each
		}
		
		override protected function addElements():void {
			Mino.all_minos.push(rock);			
			minoLayer.add(rock);
			
			addBase();
			if (stations.length > 1)
				victoryText = "Targets destroyed!";
			else
				victoryText = "Target destroyed!";
			
			setBounds();
		}
		
		protected function addBase():void {
			aggregate = new Aggregate(rock, null);
			aggregate.centroidOffset.x = 17;
			aggregate.centroidOffset.y = 20;
			
			makeStations();
			
			Mino.resetGrid(); //fix initial core locs
			for each (var mino:Mino in Mino.all_minos)
				if (mino.exists)
					mino.addToGrid();
		}
		
		protected function makeStations():void { }
		
		protected function makeStation(x:int, y:int, sminos:Array):void {
			var station:Station = new AttackStation(null);
			station.core.gridLoc.x += x;
			station.core.gridLoc.y += y;
			station.core.addToGrid();
			
			new StationLoader(station, sminos);
			for each (var member:Mino in station.members)
				aggregate.members.push(member);
			
			minoLayer.add(station.core);
			minoLayer.add(station);
			stations.push(station);
		}
		
		
		override protected function setupBags():void { } //not needed
		override protected function createTracker(_:Number = 3):void { } //likewise
		override protected function setHudStation():void { } //actively detrimental
		
		override protected function createHUD():FlxGroup { 
			hud = new AttackHud(C.accomplishments.bonusHighScores[C.accomplishments.BONUS_REVERSE]);
			
			var bounds:MapBounds = new MapBounds();
			minoLayer.add(bounds);
			hud.bounds = bounds;
			
			//TODO
			return hud;
		}
		
		override protected function checkPlayerEvents():void {
			//TODO
		}
		
		override protected function initCombatMinoPool():void {
			combatMinoPool = [];
			for each (var station:Station in stations)
				for each (var mino:Mino in station.members)
					if (mino.exists && mino is RocketGun)
						combatMinoPool.push(mino);
			
			for each (var gun:RocketGun in combatMinoPool)
				gun.loadRockets();
			
			gunTimers = new Array(combatMinoPool.length);
			setGunTimers();
		}
		
		protected function setGunTimers():void {
			for (var i:int = 0; i < gunTimers.length; i++)
				gunTimers[i] = GUN_COOLDOWN + GUN_COOLDOWN * i / (gunTimers.length + 1); //+1 provides a gap between volleys
		}
		
		
		
		
		
		
		
		
		
		
		
		override protected function normalUpdate():void {
			checkCurrentMino();
			checkGuns();
			checkCamera();
			checkInput();
			
			defaultGroup.update();
			hudLayer.update();
			(hud as AttackHud).updateLives(lives);
			
			checkGoal();
			checkEndConditions();
		}
		
		override protected function checkCurrentMino():void {
			if (currentMino && currentMino.gridLoc.y > C.B.PlayArea.bottom) {
				currentMino.exists = false;
				lives--;
				killCurrentMino();
			}
			
			var minoIsCool:Boolean = currentMino && currentMino.holdsAttention;
			
			if (!minoIsCool) {
				if (minoWasCool) {
					lives--;
					onAnchor();
				}
				
				spawnTimer -= FlxG.elapsed;
				if (spawnTimer <= 0)
					spawnNextMino();
			}
			minoWasCool = minoIsCool;
		}
		
		override protected function spawnNextMino():void {
			if (currentMino)
				onAnchor();
			
			var Y:int;
			if (rotateable)
				Y = - C.B.getFurthest() + 1;
			else
				Y = C.B.PlayArea.top - 15;
			minoLayer.add(currentMino = new MeteoMino(0, Y));
			currentMino.gridLoc.y -= currentMino.blockDim.y + 1;
			//currentMino.current = true;
			
			if (!arrowHint)
				minoLayer.add(arrowHint = new AttackHelper(currentMino));
			else if (arrowHint.exists)
				arrowHint.parent = currentMino;
			
			spawnTimer = SPAWN_TIME;
			setGunTimers();
		}
		
		protected function checkGuns():void {
			if (!currentMino || !combatMinoPool.length)
				return;
			
			var target:Point = currentMino.absoluteCenter;
			
			for (var i:int = 0; i < combatMinoPool.length; i++) {
				gunTimers[i] -= FlxG.elapsed;
				if (gunTimers[i] > 0)
					continue;
				
				var gun:RocketGun = combatMinoPool[i];
				var dist:Number = target.subtract(gun.absoluteCenter).length;
				var travelTime:Number = dist * C.BLOCK_SIZE / SlowRocket.SPEED;
				var adjTarget:Point = target.add(new Point(0, Math.round(travelTime * 1.25 / C.CYCLE_TIME))); 
				if (gun.canFireOn(adjTarget, true)) {
					gun.fireOn(adjTarget, false);
					gunTimers[i] = GUN_COOLDOWN;
				}
			}
		}
		
		//override protected function killCurrentMino():void {
			//super.killCurrentMino();
		//}
		
		override protected function checkInput():void {
			if (currentMino && currentMino.falling) //probably somewhat redundant
				checkMinoMoveInput();
			
			if (ControlSet.CANCEL_KEY.justPressed())
				enterPauseState();
		}
		
		override protected function get inputScale():Number { return 1; }
		
		override protected function shouldZoomOut():Boolean {
			return true;
		}
		
		override protected function centerOnStation():void {
			C.B.centerDrawShiftOn(aggregate.centroidOffset.add(aggregate.core.absoluteCenter));
		}
		
		override protected function get goalPercent():int {
			var deadStations:int = 0;
			for each (var station:Station in stations)
				if (!station.core.exists)
					deadStations++;
			return deadStations * 100 / stations.length;
		}
		
		override protected function won():Boolean {
			return goalFraction >= 4;
		}
		
		override protected function checkEndConditions():void {
			if (substate == SUBSTATE_MISSOVER)
				return; //to avoid double-triggering on debug input
			
			if (won() || (lives < 0 && (!currentMino || currentMino.dead)))
				beginEndgame();
		}
		
		override protected function resetLevel(_:String):void {
			super.resetLevel(_);
			//TODO?
		}
		
		override protected function getEndText():String {
			if (won())
				return victoryText;
			return "Out of lives!";
		}
		
		override protected function contemplateShaking():void { } //nope
		
		override protected function registerEnd(quit:Boolean):void {
			if (won())
				C.accomplishments.registerBonusReverseScore(lives + 1);
		}
		
		override protected function endGame():void {
			//FlxG.state = new AttackState;
			FlxG.state = new BonusState;
		}
		
		override protected function exitToMenu(_:String = null):void {
			//FlxG.state = new AttackState;
			FlxG.state = new BonusState;
		}
	}

}