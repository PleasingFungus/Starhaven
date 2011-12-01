package Controls {
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class Controller {
		
		public var station:Station;
		public var rotateable:Boolean;
		public var p:Scenario;
		public function Controller(station:Station, parent:Scenario, Rotateable:Boolean) {
			this.station = station;
			p = parent;
			rotateable = Rotateable;
		}
		
		
		private var inputTimer:Number = 0;
		private var inputTime:Number = .1;
		public function checkInput():void {
			checkContinuousInput();
			checkDiscontinuousInput();
			if (C.DEBUG)
				checkDebugInput();
		}
		
		public function checkContinuousInput():void {
			if (p.currentMino && p.currentMino.falling)
				checkMinoMoveInput();
			else
				checkMinoSpawnInput();
			checkRotateControls();
		}
		
		public function checkMinoMoveInput():void {
			if (ControlSet.MINO_L_KEY.justPressed()) {
				p.currentMino.moveLeft();
				inputTimer = 0;
			} else if (ControlSet.MINO_R_KEY.justPressed()) {
				p.currentMino.moveRight();
				inputTimer = 0;
			} else if (ControlSet.FASTFALL_KEY.justPressed()) {
				p.currentMino.moveDown(true);
				inputTimer = 0;
			} else {
				inputTimer += FlxG.elapsed;
				
				var minoDist:int = Math.abs(p.currentMino.gridLoc.y - station.core.gridLoc.y);
				var inputScale:Number = Math.max(0.5, Math.min(1, 30 / minoDist));
				//var nearby:int = C.B.getFurthest() * 0.5;
				//if (minoDist > nearby)
					//inputScale = Math.min(2, (minoDist - nearby) / (nearby * 2));
				//C.log(minoDist, nearby, (minoDist - nearby) / (nearby * 2/3), inputScale);
				
				if (inputTimer >= inputTime * inputScale) {
					inputTimer -= inputTime * inputScale;
					
					if (ControlSet.MINO_L_KEY.pressed())
						p.currentMino.moveLeft();
					if (ControlSet.MINO_R_KEY.pressed())
						p.currentMino.moveRight();
				
					if (ControlSet.FASTFALL_KEY.pressed())
						p.currentMino.moveDown(true);
				}
			}
		}
		
		public function checkMinoSpawnInput():void {
			if (ControlSet.MINO_L_KEY.justPressed() ||
				ControlSet.MINO_R_KEY.justPressed() ||
				ControlSet.FASTFALL_KEY.justPressed()) {
				p.killCurrentMino();
				inputTimer = 0;
			} else if (ControlSet.ST_CW_KEY.justPressed() ||
					   ControlSet.ST_CCW_KEY.justPressed())
				p.killCurrentMino();
			else if (p.sufficientlyAfterDrop && (
					   ControlSet.MINO_L_KEY.pressed() ||
					   ControlSet.MINO_R_KEY.pressed() ||
					   ControlSet.FASTFALL_KEY.pressed()))
				p.killCurrentMino();
		}
		
		public function checkRotateControls():void {
			if (!rotateable) return;
			
			if (ControlSet.ST_CW_KEY.pressed())
				station.smoothRotateClockwise();
			if (ControlSet.ST_CCW_KEY.pressed())
				station.smoothRotateCounterclockwise();
			
			if (station.justRotated)
				p.dealWithRotation()
		}
		
		public function checkDiscontinuousInput():void {
			if (p.currentMino && p.currentMino.falling) {
				if (ControlSet.MINO_CW_KEY.justPressed())
					p.currentMino.rotateClockwise();
				if (ControlSet.MINO_CCW_KEY.justPressed())
					p.currentMino.rotateCounterclockwise();
				
				if (ControlSet.MINO_HELP_KEY.justPressed())
					hudLayer.add(new NewPieceInfo(currentMino));
				if (ControlSet.BOMB_KEY.justPressed() && tracker.safe) {
					if (p.currentMino && p.currentMino is Bomb)
						(p.currentMino as Bomb).manuallyDetonate();
					else if (bombs > 0) {
						if (p.currentMino && !p.currentMino.parent)
							p.currentMino.exists = false;
						bag.repush(); //replace current mino in bag
						
						if (C.FINITE_BOMBS)
							bombs--;
						hud.updateBombs(bombs);
						
						minoLayer.add(p.currentMino = new Bomb(p.currentMino.gridLoc.x, p.currentMino.gridLoc.y))//0, - C.B.getFurthest() - 1));
						p.currentMino.current = true;
						if (arrowHint)
							arrowHint.parent = currentMino;
						spawnTimer = SPAWN_TIME;
					}
				}
					
			}
			
			//to re-enable snap-rotating of the station
			//if (ControlSet.ST_CW_KEY.justPressed()) {
				//station.rotateClockwise();
				//adjustScale();
				//_rotation += Math.PI / 2;
			//}if (ControlSet.ST_CCW_KEY.justPressed()) {
				//station.rotateCounterclockwise();
				//adjustScale();
				//_rotation -= Math.PI / 2;
			//}
			
			if (ControlSet.DISABLE_HUD_KEY.justPressed())
				C.HUD_ENABLED = !C.HUD_ENABLED;
			
			
			if (ControlSet.CANCEL_KEY.justPressed())
				enterPauseState();
		}
		
		public function checkDebugInput():void {
			if (ControlSet.DEBUG_DESTRUCT_KEY.justPressed() && currentMino) {
				p.currentMino.exists = false;
				p.currentMino = null;
				spawnTimer = 0.01;
			}
			
			if (ControlSet.DEBUG_SKIP_KEY.justPressed()) {
				if (arrowHint)
					arrowHint.exists = false;
				if (stationHint)
					stationHint.exists = false;
			}
			
			if (ControlSet.DEBUG_ASTEROIDS_KEY.justPressed())
				tracker.debugForceWave(5);
			
			if (ControlSet.DEBUG_DIE_KEY.justPressed())
				beginEndgame();
			
			if (ControlSet.DEBUG_WIN_KEY.justPressed()) {
				station.mineralsLaunched = station.mineralsAvailable;
				goalFraction = 4;
				beginEndgame();
			}
			
			if (ControlSet.DEBUG_PRINT_KEY.justPressed())
				station.print();
		}
	}

}