package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import Helpers.*;
	import HUDs.BlinkText;
	import HUDs.FlashText;
	import HUDs.Minimap;
	import HUDs.PauseLayer;
	import MainMenu.MenuState;
	import MainMenu.QuickPlayState;
	import MainMenu.SkipTutorialState;
	import MainMenu.StateThing;
	import MainMenu.TutorialSelectState;
	import Metagame.Campaign;
	import Metagame.CampaignState;
	import Metagame.Statblock;
	import Meteoroids.MeteoroidTracker;
	import Meteoroids.SlowRocket;
	import Meteoroids.TargetingCursor;
	import Mining.ResourceSource;
	import SFX.Fader;
	import SFX.PowerSound;
	import Sminos.Bomb;
	import Sminos.RocketGun;
	import Sminos.StationCore;
	import Controls.ControlSet;
	import InfoScreens.NewPieceInfo;
	import InfoScreens.NewPlayerEvent;
	import Icons.FloatingIconText;
	import HUDs.MapBounds;
	
	import GrabBags.*;
	import org.flixel.*;
	import HUDs.HUD;

	public class Scenario extends FlxState
	{
		
		protected var seed:Number;
		
		protected var station:Station;
		protected var currentMino:Smino;
		protected var bag:GrabBag;
		
		protected var spawnTimer:Number;
		protected var spawner:Class;
		protected var tracker:MeteoroidTracker;
		protected var hud:HUD;
		
		protected var bg:FlxSprite;
		protected var bg_sprite:Class;
		protected var bg_sprites:Array;
		protected var parallaxBG:FlxGroup;
		
		protected var rotateable:Boolean;
		
		protected var resourceSource:ResourceSource;
		protected var initialMinerals:int;
		protected var goalMultiplier:Number;
		protected var goalFraction:int;
		protected var minoLimitMultiplier:Number;
		protected var missionOver:Boolean;
		
		protected var mapDim:Point;
		protected var mapBuffer:int = 12;
		
		private var arrowHint:ArrowHelper;
		private var stationHint:StationHint;
		private var targetCursor:TargetingCursor;
		
		protected var minoLayer:FlxGroup;
		protected var iconLayer:FlxGroup;
		protected var hudLayer:FlxGroup;
		
		private var _buffer:BitmapData;
		private var _bufferRect:Rectangle;
		private var _scale:Number;
		private var _rotation:Number;
		private var zoomToggled:Boolean;
		
		public static var substate:int;
		public static var dangeresque:Boolean;
		
		public function Scenario(Seed:Number) {
			if (C.DEBUG && !isNaN(C.DEBUG_SEED))
				seed = C.DEBUG_SEED;
			else if (isNaN(Seed))
				seed = FlxU.random();
			else 
				seed = Seed;
			
			C.log("\nStarting level: " + C.scenarioList.names[C.scenarioList.index(this)]);
			C.log("Seed: " + seed);
			
			goalMultiplier = 0.6;
			minoLimitMultiplier = 1;
			rotateable = true;
		}
		
		override public function create():void
		{
			Mino.all_minos = [];
			C.B = new Bounds();
			C.B.maxDim = new Point(mapDim.x * 2, mapDim.y * 2);
			C.B.viewLimited = !rotateable;
			C.fluid = null;
			Mino.resetGrid();
			createGCT(-1);
			FlashText.activeTexts = [];
			
			_buffer = new BitmapData(FlxG.width, FlxG.height, true, FlxState.bgColor );
			_bufferRect = new Rectangle(0, 0, FlxG.width, FlxG.height);
			_scale = 1;
			_rotation = 0;
			hasUpdated = false;
			frame = 0;
			spawnTimer = SPAWN_TIME * 1.5;
			
			setupBags();
			
			makeLayers();
			
			createStation();
			setHudStation();
			createTracker();
			
			name = "Scenario";
			substate = SUBSTATE_NORMAL;
			dangeresque = false;
			
			//if (C.DEBUG)
				//FlxG.mouse.load(_combat_cursor, 15, 15);
			//else
				FlxG.mouse.hide();
			C.music.intendedMusic = C.music.PLAY_MUSIC;
		}
		
		protected function setupBags():void { }
		
		protected function makeLayers():void {
			minoLayer = new FlxGroup();
			iconLayer = new FlxGroup();
			hudLayer = createHUD();
			createBG();
			add(minoLayer);
			add(iconLayer);
			
			Mino.layer = Fader.layer = minoLayer;
			C.iconLayer = iconLayer;
			C.hudLayer = hudLayer;
		}
		
		protected function createBG():void {
			if (bg_sprites) {
				var bg_index:int = FlxU.random() * bg_sprites.length;
				bg = new FlxSprite().loadGraphic(bg_sprites[bg_index]);
			} else if (bg_sprite)
				bg = new FlxSprite().loadGraphic(bg_sprite);
		}
		
		protected function notionalMinoLimit():int {
			var toMine:int = station.resourceSource.totalBlocks() * goalMultiplier;
			var baseLimit:Number = toMine * 0.65; //semi-arbitrary
			if (!rotateable)
				baseLimit *= 0.42;
			var adjustedLimit:Number = baseLimit * minoLimitMultiplier;
			C.log("Limit: " + toMine, baseLimit, adjustedLimit);
			return adjustedLimit;
		}
		
		protected function createGCT(miningTime:int):void {
			add(new GlobalCycleTimer());
			GlobalCycleTimer.miningTime = miningTime;
		}
		
		protected function createStation():void {
			station = new Station();
			station.minimap = hud.minimap;
			station.rotateable = rotateable;
			minoLayer.add(station);
			minoLayer.add(station.core);
			C.B.PlayArea = _getBounds();
			buildLevel();
			station.silent = false;
		}
		
		protected function buildLevel():void {
			//override me, my children! FEED
		}
		
		protected function setHudStation():void {
			hud.setStation(station);
			hud.setGoal(goalMultiplier);
			
			GlobalCycleTimer.notionalMiningTime = notionalMinoLimit();
			if (GlobalCycleTimer.miningTime == -1)
				GlobalCycleTimer.miningTime = GlobalCycleTimer.notionalMiningTime;
		}
		
		protected function createTracker(waveMeteos:Number = 3):void {
			tracker = new MeteoroidTracker(minoLayer, spawner, station.core, 15, 1.5, waveMeteos, BagType.all[0].length);
			hud.setTracker(tracker);
			add(tracker);
		}
		
		protected function createHUD():FlxGroup {
			var bounds:MapBounds, minimap:Minimap;
			minoLayer.add(bounds = new MapBounds());
			//minoLayer.add(minimap = new Minimap(0, 0));
			minimap = new Minimap(0, 0)
			
			hud = new HUD;
			hud.minimap = minimap;
			hud.add(minimap);
			hud.bounds = bounds;
			return hud;
		}
		
		
		
		
		protected var hasUpdated:Boolean;
		protected var frame:int;
		override public function update():void {
			hasUpdated = true;
			if (C.DEBUG) frame++;
			FlxG.timeScale = 1;
			switch (substate) {
				case SUBSTATE_NORMAL: normalUpdate(); break;
				case SUBSTATE_PAUSED: pauseUpdate(); break;
				case SUBSTATE_INFOPAUSE: infoUpdate(); break;
				case SUBSTATE_ROTPAUSE: rotateUpdate(); break;
				case SUBSTATE_MISSOVER: overUpdate(); break;
			}
			C.music.update(); //might update double-fast? oops
		}
		
		private function normalUpdate():void {
			checkCurrentMino();
			checkInput();
			checkCamera();
			if (dangeresque)
				checkCombatCursor();
			
			super.update();
			hudLayer.update();
			
			checkGoal();
			checkEndConditions();
			
			if (!missionOver) {
				checkArrowHint();
				checkPlayerEvents();
			}
			
			if (tracker.safe == dangeresque) { //mismatch!
				if (tracker.safe)
					endCombat();
				else
					initCombat();
			}
		}
		
		protected var minoWasCool:Boolean;
		protected function checkCurrentMino():void {
			if (currentMino && currentMino.gridLoc.y > C.B.PlayArea.bottom) {
				if (!(currentMino is Bomb))
					tracker.registerDrop();
				currentMino.exists = false;
				killCurrentMino();
			}
			
			if (dangeresque)
				return;
			
			var minoIsCool:Boolean = currentMino && currentMino.holdsAttention;
			
			if (!minoIsCool) {
				if (minoWasCool) {
					if (!(currentMino is Bomb))
						tracker.registerDrop();
					onAnchor();
				}
				if (tracker.safe && !station.core.damaged) {
					spawnTimer -= FlxG.elapsed;
					if (spawnTimer <= 0)
						spawnNextMino();
				}
			}
			minoWasCool = minoIsCool;
		}
		
		protected function killCurrentMino():void {
			if (currentMino) {
				currentMino.current = false;
				if (currentMino is Bomb) {
					currentMino = (currentMino as Bomb).uncle;
					currentMino.active = currentMino.current = true;
				} else {								
					checkMinoEvents();					
					currentMino = null;
					GlobalCycleTimer.minosDropped++;
				}
			}
		}
		
		protected function checkMinoEvents():void {
			if (!currentMino.exists) return;
			
			if (!currentMino.powered)
				NewPlayerEvent.fire(NewPlayerEvent.DISCONNECT);
			else if (station.crewDeficit)
				NewPlayerEvent.fire(NewPlayerEvent.DECREW);
			else if (currentMino.submerged && !currentMino.waterproofed)
				NewPlayerEvent.fire(NewPlayerEvent.SUBMERGE);
		}
		
		protected function spawnNextMino():void {
			if (currentMino)
				onAnchor();
			
			minoLayer.add(currentMino = popNextMino());
			
			if (!arrowHint)
				minoLayer.add(arrowHint = new ArrowHelper(currentMino));
			else if (arrowHint.exists)
				arrowHint.parent = currentMino;
			else if (currentMino.bombCarrying)
				minoLayer.add(new BombHelper(currentMino));
			
			if (C.ANNOYING_NEW_PIECE_POPUP && !NewPieceInfo.seenPieces[NewPieceInfo.getPieceName(currentMino)])
				hudLayer.add(new NewPieceInfo(currentMino));
			
			spawnTimer = SPAWN_TIME;
		}
		
		protected function onAnchor():void {
			killCurrentMino();
			C.B.PlayArea = _getBounds();
		}
		
		protected function popNextMino():Smino {
			if (!bag || bag.empty())
				bag = chooseNextBag();
			
			var X:int = 0;
			var Y:int;
			if (rotateable)
				Y = - C.B.getFurthest() + 1;
			else
				Y = C.B.PlayArea.top - 15;
			var choice:Class = bag.grabMino();
			var spawnedMino:Smino = new choice(X, Y)
			spawnedMino.gridLoc.y -= spawnedMino.blockDim.y + 1;
			
			do {
				var collision:Boolean = false;
				var collideLength:int = 6;
				for (var y:int = 0; y < collideLength; y++) {
					spawnedMino.gridLoc.y += y;
					if (spawnedMino.intersects()) {
						collision = true;
						break;
					}
					spawnedMino.gridLoc.y -= y;
				}
				if (collision)
					spawnedMino.gridLoc.y -= collideLength;
			} while (collision);
			while (spawnedMino.intersects())
				spawnedMino.gridLoc.y -= spawnedMino.blockDim.y + 6;
			
			spawnedMino.current = true;
			return spawnedMino;
		}
		
		protected function chooseNextBag():GrabBag {
			return GrabBag.chooseBag();
		}
		
		protected function initCombat():void {
			initCombatMinoPool();
			for each (var gun:RocketGun in combatMinoPool)
				gun.loadRockets();
			if (stationHint && stationHint.exists && !C.NO_COMBAT_ROTATING)
				stationHint.visible = false;
			dangeresque = true;
			
			hudLayer.add(targetCursor = new TargetingCursor);
			NewPlayerEvent.fire(NewPlayerEvent.METEOROIDS);
		}
		
		protected function endCombat():void {
			for each (var gun:RocketGun in combatMinoPool)
				gun.unloadRockets();
			combatMinoPool = null;
			if (stationHint && stationHint.exists && !C.NO_COMBAT_ROTATING)
				stationHint.visible = true;
			dangeresque = false;
			
			targetCursor.exists = false;
			targetCursor = null;
		}
		
		protected var combatMinoPool:Array;
		protected function initCombatMinoPool():void {
			combatMinoPool = [];
			for each (var mino:Mino in station.members)
				if (mino.exists && mino is RocketGun && (mino as Smino).operational)
					combatMinoPool.push(mino);
		}
		
		protected function checkCombatCursor():void {
			var target:Point = C.B.screenToBlocks(targetCursor.x, targetCursor.y);
			var closest:RocketGun = findClosestValidLauncher(target);
			if (closest)
				closest.aimAt(target);
		}
		
		
		
		
		
		protected function checkArrowHint():void {
			if (!stationHint && arrowHint && !arrowHint.exists && rotateable && currentMino) {
				minoLayer.add(stationHint = new StationHint(station));
				if (currentMino.bombCarrying || currentMino is Bomb)
					minoLayer.add(new BombHelper(currentMino));
			}
		}
		
		
		private var lastSubstate:int;
		private var pauseLayer:FlxGroup;
		public function enterPauseState():void {
			if (pauseLayer && pauseLayer.exists)
				return;
			
			hudLayer.add(pauseLayer = new PauseLayer(exitToMenu, resetLevel));
			C.HUD_ENABLED = true;
			
			lastSubstate = substate;
			substate = SUBSTATE_PAUSED;
			FlxG.mouse.show();
		}
		
		private function pauseUpdate():void {
			//pauseText.update();
			pauseLayer.update();
			
			if (FlxG.keys.anyKey()) {
				leavePauseState();
			}
		}
		
		public function leavePauseState():void {
			if (!pauseLayer || !pauseLayer.exists)
				return;
			
			pauseLayer.exists = false;
			substate = lastSubstate;
			FlxG.mouse.hide();
		}
		
		private function resetLevel(_:String):void {
			defaultGroup = new FlxGroup;
			currentMino = null;
			FlxG.fade.stop();
			create();
		}
		
		private function infoUpdate():void {
			hudLayer.update();
		}
		
		private function rotateUpdate():void {
			checkRotateControls();
			station.update();
			if (dangeresque)
				targetCursor.update();
		}
		
		private var inputTimer:Number = 0;
		private var inputTime:Number = .1;
		private function checkInput():void {
			checkContinuousInput();
			checkDiscontinuousInput();
			if (dangeresque)
				checkCombatInput();
			if (C.DEBUG)
				checkDebugInput();
		}
		
		private function checkCombatInput():void {
			if (FlxG.mouse.justPressed() || ControlSet.BOMB_KEY.justPressed())
				fireRocket(C.B.screenToBlocks(targetCursor.x, targetCursor.y));
		}
		
		protected function checkContinuousInput():void {
			if (!dangeresque) {
				if (currentMino && currentMino.falling)
					checkMinoMoveInput();
				else
					checkMinoSpawnInput();
			}
			
			if (!C.NO_COMBAT_ROTATING || !dangeresque)
				checkRotateControls();
		}
		
		protected function checkMinoMoveInput():void {
			if (ControlSet.MINO_L_KEY.justPressed()) {
				currentMino.moveLeft();
				inputTimer = 0;
			} else if (ControlSet.MINO_R_KEY.justPressed()) {
				currentMino.moveRight();
				inputTimer = 0;
			} else if (ControlSet.FASTFALL_KEY.justPressed()) {
				currentMino.moveDown(true);
				inputTimer = 0;
			} else {
				inputTimer += FlxG.elapsed;
				
				var minoDist:int = Math.abs(currentMino.gridLoc.y - station.core.gridLoc.y);
				var inputScale:Number = Math.max(0.5, Math.min(1, 30 / minoDist));
				//var nearby:int = C.B.getFurthest() * 0.5;
				//if (minoDist > nearby)
					//inputScale = Math.min(2, (minoDist - nearby) / (nearby * 2));
				//C.log(minoDist, nearby, (minoDist - nearby) / (nearby * 2/3), inputScale);
				
				if (inputTimer >= inputTime * inputScale) {
					inputTimer -= inputTime * inputScale;
					
					if (ControlSet.MINO_L_KEY.pressed())
						currentMino.moveLeft();
					if (ControlSet.MINO_R_KEY.pressed())
						currentMino.moveRight();
				
					if (ControlSet.FASTFALL_KEY.pressed())
						currentMino.moveDown(true);
				}
			}
		}
		
		protected function checkMinoSpawnInput():void {
			if (ControlSet.MINO_L_KEY.justPressed() ||
				ControlSet.MINO_R_KEY.justPressed() ||
				ControlSet.FASTFALL_KEY.justPressed()) {
				killCurrentMino();
				spawnTimer = 0;
				inputTimer = 0;
			} else if (ControlSet.ST_CW_KEY.justPressed() ||
					   ControlSet.ST_CCW_KEY.justPressed()) {
				killCurrentMino();
				spawnTimer = 0;
			} else if (spawnTimer <= SPAWN_TIME - 0.3 && (
					   ControlSet.MINO_L_KEY.pressed() ||
					   ControlSet.MINO_R_KEY.pressed() ||
					   ControlSet.FASTFALL_KEY.pressed())) {
				killCurrentMino();
				spawnTimer = 0;
			}
		}
		
		protected function checkRotateControls():void {
			if (!rotateable) return;
			if (ControlSet.ST_CW_KEY.pressed())
				station.smoothRotateClockwise();
			if (ControlSet.ST_CCW_KEY.pressed())
				station.smoothRotateCounterclockwise();
			if (station.justRotated) {
				C.B.PlayArea = _getBounds();
				if (_scale == 1)
					checkCamera();
				station.justRotated = false;
			}
		}
		
		protected function checkDiscontinuousInput():void {
			if (currentMino && currentMino.falling) {
				if (currentMino.rotateable) {
					if (ControlSet.MINO_CW_KEY.justPressed())
						currentMino.rotateClockwise();
					if (ControlSet.MINO_CCW_KEY.justPressed())
						currentMino.rotateCounterclockwise();
				}
				
				//if (ControlSet.MINO_HELP_KEY.justPressed())
					//hudLayer.add(new NewPieceInfo(currentMino));
				if (ControlSet.BOMB_KEY.justPressed() && tracker.safe && currentMino) {
					if (currentMino is Bomb)
						(currentMino as Bomb).manuallyDetonate();
					else if (currentMino.bombCarrying && !currentMino.parent)
						dropBomb();
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
			if (ControlSet.ZOOM_KEY.justPressed())
				zoomToggled = !zoomToggled;
			
			if (ControlSet.CANCEL_KEY.justPressed())
				enterPauseState();
		}
		
		protected function dropBomb():void {			
			currentMino.active = currentMino.current = currentMino.bombCarrying = false;
			minoLayer.add(currentMino = new Bomb(currentMino))//0, - C.B.getFurthest() - 1));
			currentMino.current = true;
			if (arrowHint && arrowHint.exists)
				arrowHint.parent = currentMino;
			else
				minoLayer.add(new BombHelper(currentMino));
			spawnTimer = SPAWN_TIME;
		}
		
		protected function fireRocket(target:Point):void {
			var closest:RocketGun = findClosestValidLauncher(target);
			if (closest)
				closest.fireOn(target);
		}
		
		protected function findClosestValidLauncher(target:Point):RocketGun {
			var closest:RocketGun = findClosestLauncher(target, true);
			if (closest)
				return closest;
			return findClosestLauncher(target, false);
		}
		
		protected function findClosestLauncher(target:Point, checkForBlock:Boolean):RocketGun {
			var dist:int = int.MAX_VALUE;
			var closest:RocketGun;
			for each (var gun:RocketGun in combatMinoPool)
				if (gun.exists && gun.canFireOn(target, true)) {
					var gunDist:int = target.subtract(gun.fireOrigin).length;
					if (gunDist < dist) {
						dist = gunDist;
						closest = gun;
					}
				}
			return closest;
		}
		
		protected function checkDebugInput():void {
			if (ControlSet.DEBUG_DESTRUCT_KEY.justPressed() && currentMino) {
				currentMino.exists = false;
				currentMino = null;
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
			
			if (ControlSet.DEBUG_ROCKET_KEY.justPressed())
				minoLayer.add(new SlowRocket(station.core.absoluteCenter, C.B.screenToBlocks(FlxG.mouse.x, FlxG.mouse.y), null));
		}
		
		protected function checkCamera():void {
			C.B.buffer = mapBuffer;
			var shouldZoomOut:Boolean = !currentMino && (!GlobalCycleTimer.minosDropped || dangeresque);
			if ((!shouldZoomOut && zoomToggled) ||
				(shouldZoomOut && !zoomToggled)) {
				if (_scale == 1)
					adjustScale(true);
				C.B.centerDrawShiftOn(station.centroidOffset.add(station.core.absoluteCenter));
			} else {
				if (_scale != 1)
					adjustScale(false);
			}
		}
		
		
		
		
		
		protected function checkPlayerEvents():void {
			if (rotateable && !NewPlayerEvent.seen[NewPlayerEvent.ROTATEABLE])
				hudLayer.add(NewPlayerEvent.rotationMinitutorial());
			
		}
		
		protected function checkGoal():void {
			var newFraction:int = Math.floor(goalPercent / 25);
			if (newFraction > goalFraction && newFraction < 4)
				hudLayer.add(new FlashText(goalPercent + "% of goal passed!", 0x80ffd000, 2));
			goalFraction = newFraction;
			hud.updateGoal(goalPercent);
		}
		
		protected function get goalPercent():int {
			return station.mineralsLaunched * 100 / (initialMinerals * goalMultiplier);
		}
		
		protected function checkEndConditions():void {
			if (substate == SUBSTATE_MISSOVER)
				return; //to avoid double-triggering on debug input
			
			if (won() ||
				GlobalCycleTimer.outOfTime() ||
				station.core.damaged)
				
				beginEndgame();
		}
		
		protected var victoryText:String = "Mineral goal reached!";
		protected function beginEndgame():void {
			FlxG.flash.start(0xefffffff, 3.5/*, endGame*/);
			
			missionOver = true;
			substate = SUBSTATE_MISSOVER;
			if (dangeresque) {
				tracker.active = false;
				for each (var mino:Mino in Mino.all_minos)
					if (mino.dangerous)
						mino.exists = false;
				dangeresque = false;
			}
			if (won())
				C.accomplishments.registerVictory(this);
			
			//var shroud:FlxSprite = new FlxSprite().createGraphic(FlxG.width, FlxG.height, 0xff000000);
			//shroud.alpha = 0.5;
			//hudLayer.add(shroud);
			
			var endText:FlxText = new FlxText(20, FlxG.height / 2 - 30, FlxG.width - 40, " ");
			endText.setFormat(C.FONT, 48, 0xffffff, 'center');
			
			if (won()) {
				endText.text = "Victory!";
				endText.color = 0x10ff18;
				shakeIntensity = 0;
			} else {
				endText.text = "Defeat.";
				endText.color = 0xff2810;
				if (!station.core.damaged)
					station.core.takeExplodeDamage( -1, -1, station.core);
				FlxG.quake.start(shakeIntensity, SHAKE_TIME);
				shakeTimer = SHAKE_TIME;
			}
			hudLayer.add(endText);
			
			var endSub:FlxText = new FlxText(20, endText.y + endText.height + 5, FlxG.width - 40, " ");
			if (won())
				endSub.text = victoryText;
			else if (GlobalCycleTimer.outOfTime())
				endSub.text = "Out of blocks!";
			else
				endSub.text = "Station destroyed!";
			endSub.setFormat(C.FONT, 24, 0xffffff, 'center');
			hudLayer.add(endSub);
			
			hudLayer.add(new BlinkText(0, FlxG.height - 25, "Press "+ControlSet.CONFIRM_KEY+" To Continue", 16));
		}
		
		private var overTimer:Number = 0.8;
		protected function overUpdate():void {
			if (overTimer > 0)
				overTimer -= FlxG.elapsed;
			else if (ControlSet.CONFIRM_KEY.justPressed()) {
				endGame();
				return;
			}
			checkShake();
			checkCamera();
			super.update();
			hudLayer.update();
		}
		
		protected var shakeTimer:Number;
		protected const SHAKE_TIME:Number = 2/3;
		protected var shakeIntensity:Number = 0.2;
		protected function checkShake():void {
			if (!shakeIntensity)
				return;
			
			shakeTimer -= FlxG.elapsed
			if (shakeTimer <= 0) {
				shakeIntensity /= 2;
				if (shakeIntensity < 0.01)
					shakeIntensity = 0;
				else {
					shakeTimer = SHAKE_TIME;
					FlxG.quake.start(shakeIntensity, SHAKE_TIME);
				}
			}
			
		}
		
		protected function endGame():void {		
			if (C.campaign) {
				if (won()) {
					C.campaign.winMission(makeStatblock(true));
					FlxG.state = new CampaignState;
				} else {
					C.campaign.endMission(makeStatblock(false));
					FlxG.state = new CampaignState(true);
				}
			} else if (C.IN_TUTORIAL) {
				var curLevel:int = C.scenarioList.index(this);
				if (!won()) {
					FlxG.state = new C.scenarioList.all[curLevel];
				} else {				
					var nextLevel:int = curLevel + 1;
					if (!C.accomplishments.winsByScenario[nextLevel] && !C.accomplishments.tutorialDone)
						FlxG.state = new C.scenarioList.all[nextLevel]
					else
						FlxG.state = new MenuState;
				}
			} else
				FlxG.state = new MenuState;
		}
		
		protected function makeStatblock(won:Boolean):Statblock {
			return new Statblock(won ? 1 : 0, GlobalCycleTimer.minosDropped,
								 station.mineralsLaunched, MeteoroidTracker.kills)
		}
		
		protected function exitToMenu(_:String = null):void {
			if (C.IN_TUTORIAL)
				FlxG.state = new TutorialSelectState;
			else if (C.campaign) {
				C.campaign.endMission(makeStatblock(false));
				FlxG.state = new CampaignState(true);
			} else
				FlxG.state = new QuickPlayState;
		}
		
		protected function won():Boolean {
			return goalFraction >= 4;
		}
		
		protected function getEndCause():int {
			if (won())
				return Campaign.MISSION_MINEDOUT;
			else if (GlobalCycleTimer.outOfTime())
				return Campaign.MISSION_TIMEOUT;
			else
				return Campaign.MISSION_EXPLODED;
		}
		
		
		
		
		
		protected function _getBounds():Rectangle {
			//return new Rectangle(C.B.OUTER_BOUNDS.x, C.B.OUTER_BOUNDS.y - mapBuffer,
								 //C.B.OUTER_BOUNDS.width, C.B.OUTER_BOUNDS.height + mapBuffer);
			
			var stationBounds:Rectangle = C.B.StationBounds = station.bounds;
			var mapBounds:Rectangle =  new Rectangle(stationBounds.x - mapBuffer,
													 stationBounds.y - mapBuffer,
													 stationBounds.width + mapBuffer * 2,
													 stationBounds.height + mapBuffer * 2);
			
			//var D:int = Math.max(mapBounds.width, mapBounds.height);
			//mapBounds.x -= (D - mapBounds.width) / 2;
			//mapBounds.y -= (D - mapBounds.height) / 2;
			//mapBounds.width = mapBounds.height = D;
			//C.log("Setting map bounds to: " + mapBounds);
			
			//var mapBounds:Rectangle =  new Rectangle(Math.max(stationBounds.x - mapBuffer, C.B.OUTER_BOUNDS.x),
													 //Math.max(stationBounds.y - mapBuffer, C.B.OUTER_BOUNDS.y),
													 //Math.min(stationBounds.right + mapBuffer, C.B.OUTER_BOUNDS.right),
													 //Math.min(stationBounds.bottom + mapBuffer, C.B.OUTER_BOUNDS.bottom));
			
			return mapBounds;
		}
		
		private function adjustScale(zoomedOut:Boolean):void {
			C.B.PlayArea = _getBounds();
			if (zoomedOut) {
				var yScale:Number = C.B.BASE_AREA.height / C.B.PlayArea.height;
				var xScale:Number = C.B.BASE_AREA.height / C.B.PlayArea.width;
				
				//to disable windowboxing:
				//var xScale:Number = C.BASE_AREA.width / C.B.PlayArea.width;
				_scale = xScale < yScale ? xScale : yScale;
				
				//_scale = Math.min(2 / Math.ceil(2 / _scale), 1);
			} else
				_scale = 1;
			
			C.B.scale = _scale;
			
			var bufferWidth:int = FlxG.width / _scale;
			var bufferHeight:int = FlxG.height / _scale;
			
			_bufferRect = new Rectangle(0, 0, bufferWidth, bufferHeight);
			if (_buffer)
				_buffer.dispose();
			_buffer = new BitmapData(bufferWidth, bufferHeight, true, FlxState.bgColor);
			
		}
		
		//protected function get zoomedOut():Boolean {
			//return (GlobalCycleTimer.minosDropped <= 1 && !currentMino) || !tracker.safe;
		//}
		
		
		
		
		
		
		private var flxbufferRect:Rectangle;
		private var matrix:Matrix;
		override public function render():void {
			if (!hasUpdated)
				update(); //make sure update is called before render!
			
			if (!matrix)
				matrix = new Matrix();
			matrix.identity();
			
			matrix.scale(_scale, _scale);
			//matrix.translate((FlxG.width - C.B.PlayArea.width * C.BLOCK_SIZE * _scale) / 2,
							 //(FlxG.height - C.B.PlayArea.height * C.BLOCK_SIZE * _scale) / 2);
			
			if (!flxbufferRect)
				flxbufferRect = new Rectangle(0, 0, FlxG.width, FlxG.height);
			FlxG.buffer.fillRect(flxbufferRect, bgColor);
			if (bg)
				bg.render();
			
			if (parallaxBG)
				renderParallaxBG();
			
			var realBuffer:BitmapData = FlxG.buffer;
			FlxG.buffer = _buffer;
			_buffer.fillRect(_bufferRect, 0x0);
			
			if (C.DEBUG && C.DISPLAY_BOUNDS)
				renderMapBounds();
			
			super.render();
			if (C.DEBUG && C.DISPLAY_COLLISION)
				renderCollision();
			else if (substate == SUBSTATE_ROTPAUSE)
				station.render();
			
			realBuffer.draw(_buffer, matrix);
			FlxG.buffer = realBuffer;
			
			if (C.DRAW_GLOW)
				drawGlow();
			
			if (C.HUD_ENABLED)
				hudLayer.render();
		}
		
		private function renderParallaxBG():void {
			//var rangeOfMotion:Point = new Point(FlxG.width - parallaxBG.width,
												//FlxG.height - parallaxBG.height);
			//C.B.getMaxShift
			
			for each (var obj:FlxSprite in parallaxBG.members) {
				obj.offset.x = -C.B.drawShift.x * obj.scrollFactor.x * C.B.scale;
				obj.offset.y = -C.B.drawShift.y * obj.scrollFactor.y * C.B.scale;
			}
			parallaxBG.render();
		}
		
		private function renderCollision():void {
			var stamp:FlxSprite = new FlxSprite().createGraphic(C.BLOCK_SIZE, C.BLOCK_SIZE);
			for (var x:int = C.B.PlayArea.left; x < C.B.PlayArea.right; x++)
				for (var y:int = C.B.PlayArea.top; y < C.B.PlayArea.bottom; y++) {
					if (Mino.getGrid(x, y))
						stamp.color = 0x80ff80;
					else
						continue;
					stamp.x = x * C.BLOCK_SIZE + C.B.drawShift.x;
					stamp.y = y * C.BLOCK_SIZE + C.B.drawShift.y;
					stamp.render();
				}
		}
		
		private function renderMapBounds():void {
			var bounds:Rectangle = C.B.PlayArea;
			var debugSprite:FlxSprite = new FlxSprite(bounds.x * C.BLOCK_SIZE + C.B.drawShift.x,
													  bounds.y * C.BLOCK_SIZE + C.B.drawShift.y);
			debugSprite.createGraphic(bounds.width * C.BLOCK_SIZE, bounds.height * C.BLOCK_SIZE, 0xff000000);
			debugSprite.render();
		}
		
		private var glowBuffer:BitmapData;
		private var glowColorTransform:ColorTransform = new ColorTransform(1, 1, 1, C.GLOW_ALPHA);
		private const blurFilter:BlurFilter = new BlurFilter(C.GLOW_SCALE, C.GLOW_SCALE, 1);
		private function drawGlow():void {
			if (!glowBuffer)
				glowBuffer = FlxG.buffer.clone();
			glowBuffer.applyFilter(FlxG.buffer, new Rectangle(0, 0, FlxG.width, FlxG.height), new Point(), blurFilter);
			FlxG.buffer.draw(glowBuffer, null, glowColorTransform, BlendMode.SCREEN);
		}
		
		public static const SUBSTATE_NORMAL:int = 0;
		public static const SUBSTATE_INFOPAUSE:int = 1;
		public static const SUBSTATE_ROTPAUSE:int = 2;
		public static const SUBSTATE_MISSOVER:int = 3;
		public static const SUBSTATE_PAUSED:int = 4;
		
		private const SPAWN_TIME:Number = 2;
	}
}
