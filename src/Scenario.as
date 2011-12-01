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
	import MainMenu.MenuState;
	import MainMenu.StateThing;
	import Metagame.Campaign;
	import Metagame.CampaignDefeatState;
	import Metagame.CampaignState;
	import Metagame.CampaignVictoryState
	import Meteoroids.MeteoroidTracker;
	import Mining.ResourceSource;
	import SFX.Fader;
	import Sminos.Bomb;
	import Sminos.Drill;
	import Sminos.StationCore;
	import Controls.ControlSet;
	import InfoScreens.NewPieceInfo;
	import InfoScreens.NewPlayerEvent;
	import Icons.FloatingIconText;
	import Sminos.Launcher;
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
		
		protected var spawnTimer:Number = SPAWN_TIME * 1.5;
		protected var spawner:Class;
		protected var tracker:MeteoroidTracker;
		protected var hud:HUD;
		
		protected var bg:FlxSprite;
		protected var bg_sprite:Class;
		protected var bg_sprites:Array;
		
		protected var rotateable:Boolean;
		
		protected var resourceSource:ResourceSource;
		protected var initialMinerals:int;
		protected var goal:Number;
		protected var goalFraction:int;
		protected var missionOver:Boolean;
		
		protected var mapDim:Point;
		protected var mapBuffer:int = 12;
		
		private var arrowHint:ArrowHelper;
		private var stationHint:StationHint;
		
		protected var minoLayer:FlxGroup;
		protected var iconLayer:FlxGroup;
		protected var hudLayer:FlxGroup;
		
		private var _buffer:BitmapData;
		private var _bufferRect:Rectangle;
		private var _scale:Number;
		private var _rotation:Number;
		
		public static var substate:int;
		
		public function Scenario(Seed:Number) {
			if (C.DEBUG && !isNaN(C.DEBUG_SEED))
				seed = C.DEBUG_SEED;
			else if (isNaN(Seed))
				seed = FlxU.random();
			else 
				seed = Seed;
			
			C.log("Seed: " + seed);
			
			goal = 0.5;
			if (C.difficulty.hard)
				goal = 0.6;
			rotateable = true;
		}
		
		override public function create():void
		{
			Mino.all_minos = [];
			C.B = new Bounds();
			C.B.maxDim = new Point(mapDim.x * 2, mapDim.y * 2);
			C.fluid = null;
			Mino.resetGrid();
			createGCT();
			FlashText.activeTexts = [];
			
			_buffer = new BitmapData(FlxG.width, FlxG.height, true, FlxState.bgColor );
			_bufferRect = new Rectangle(0, 0, FlxG.width, FlxG.height);
			_scale = 1;
			_rotation = 0;
			C.B.drawShift = new Point();
			
			makeLayers();
			
			createStation();
			createTracker();
			createHUD();
			
			name = "Scenario";
			substate = SUBSTATE_NORMAL;
			FlxG.mouse.hide();
			//C.music.intendedMusic = Music.PLAY_MUSIC;
		}
		
		protected function makeLayers():void {
			minoLayer = new FlxGroup();
			iconLayer = new FlxGroup();
			hudLayer = new FlxGroup();
			createBG();
			add(minoLayer);
			add(iconLayer);
			
			Mino.layer = Fader.layer = minoLayer;
			C.iconLayer = iconLayer;
			FlashText.layer = hudLayer;
		}
		
		protected function createBG():void {
			if (bg_sprites) {
				var bg_index:int = FlxU.random() * bg_sprites.length;
				bg = new FlxSprite().loadGraphic(bg_sprites[bg_index]);
			} else if (bg_sprite)
				bg = new FlxSprite().loadGraphic(bg_sprite);
		}
		
		protected function createGCT(miningTime:Number = 40):void {
			add(new GlobalCycleTimer());
			if (C.difficulty.normal)
				miningTime = Math.floor(miningTime * 1.5 / 5) * 5;
			GlobalCycleTimer.miningTime = miningTime;
		}
		
		protected function createStation():void {
			station = new Station(resourceSource);
			minoLayer.add(station);
			minoLayer.add(station.core);
			C.B.PlayArea = _getBounds();
		}
		
		protected function createTracker(Density:Number = 2, WaveSpacing:int = 16):void {
			//if (!rotateable) Density /= 2;
			tracker = new MeteoroidTracker(minoLayer, spawner, station.core, 15, 1.5, Density, WaveSpacing);
			add(tracker);
		}
		
		protected function createHUD():void {
			//hudLayer.add(new MapBounds());
			minoLayer.add(new MapBounds());
			
			minoLayer.add(new Minimap(0, 0, station));
			
			if (C.campaign)
				goal *= C.campaign.difficultyFactor;
			hud = new HUD(station, goal, tracker);
			hudLayer.add(hud);
		}
		
		
		
		
		
		override public function update():void {
			switch (substate) {
				case SUBSTATE_NORMAL: normalUpdate(); break;
				case SUBSTATE_PAUSED: pauseUpdate(); break;
				case SUBSTATE_INFOPAUSE: infoUpdate(); break;
				case SUBSTATE_ROTPAUSE: rotateUpdate(); break;
				case SUBSTATE_MISSOVER: overUpdate(); break;
			}
			//C.music.update();
		}
		
		private function normalUpdate():void {
			checkCurrentMino();
			checkInput();
			checkCamera();
			
			super.update();
			hudLayer.update();
			
			checkGoal();
			checkEndConditions();
			
			if (!missionOver) {
				checkArrowHint();
				checkPlayerEvents();
			}
		}
		
		protected function checkCurrentMino():void {
			if (currentMino && currentMino.gridLoc.y > C.B.PlayArea.bottom) {
				currentMino.exists = false;
				killCurrentMino();
			}
			
			if (!currentMino || (!currentMino.falling && (!(currentMino is Drill) || !(currentMino as Drill).drilling))) {
				if (tracker.safe && !station.core.damaged) {
					spawnTimer -= FlxG.elapsed;
					if (spawnTimer <= 0)
						spawnNextMino();
				}
			}
		}
		
		protected function killCurrentMino():void {
			if (currentMino) {
				currentMino.current = false;
				if (currentMino is Bomb) {
					currentMino = (currentMino as Bomb).uncle;
					currentMino.active = currentMino.current = true;
				} else {				
					currentMino = null;
					GlobalCycleTimer.minosDropped++;
				}
			}
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
			if (!NewPlayerEvent.seen[NewPlayerEvent.DISCONNECT] && !currentMino.powered)
				hudLayer.add(NewPlayerEvent.onFirstDisconnect());
			else if (!NewPlayerEvent.seen[NewPlayerEvent.DECREW] && station.crewDeficit)
				hudLayer.add(NewPlayerEvent.onFirstUncrewed());
			else if (!NewPlayerEvent.seen[NewPlayerEvent.SUBMERGE] && currentMino.submerged)
				hudLayer.add(NewPlayerEvent.onFirstSubmerged());
			
			killCurrentMino();
			C.B.PlayArea = _getBounds();
		}
		
		protected function popNextMino():Smino {
			if (!bag || bag.empty()) {
				bag = chooseNextBag();
				C.log("New bag: " + bag);
			}
			
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
		
		protected function checkArrowHint():void {
			if (!stationHint && arrowHint && !arrowHint.exists && rotateable) {
				minoLayer.add(stationHint = new StationHint(station));
				if (currentMino.bombCarrying || currentMino is Bomb)
					minoLayer.add(new BombHelper(currentMino));
			}
		}
		
		
		private var darkShroud:FlxSprite;
		private var pauseText:FlxText;
		private var quitButton:StateThing;
		private function enterPauseState():void {
			darkShroud = new FlxSprite().createGraphic(FlxG.width, FlxG.height, 0xff000000);
			darkShroud.alpha = 0.5;
			hudLayer.add(darkShroud);
			
			MenuThing.menuThings = [];
			quitButton = new StateThing("Click To Quit", MenuState);
			var quitCol:Array = [quitButton];
			MenuThing.addColumn(quitCol, FlxG.width/2 - quitButton.fullWidth/2);
			hudLayer.add(quitButton);
			
			pauseText = new BlinkText(0, FlxG.height/2 + 15, "Press any key to unpause.", 16)
			hudLayer.add(pauseText);
			
			substate = SUBSTATE_PAUSED;
			FlxG.mouse.show();
		}
		
		private function pauseUpdate():void {
			//pauseText.update();
			quitButton.update();
			
			if (FlxG.keys.anyKey()) {
				pauseText.exists = darkShroud.exists = quitButton.exists = false;
				FlxG.mouse.hide();
				substate = SUBSTATE_NORMAL;
			} else if (ControlSet.CONFIRM_KEY.justPressed())
				exitToMenu();
		}
		
		private function infoUpdate():void {
			hudLayer.update();
		}
		
		private function rotateUpdate():void {
			checkRotateControls();
			station.update();
		}
		
		private var inputTimer:Number = 0;
		private var inputTime:Number = .1;
		private function checkInput():void {
			checkContinuousInput();
			checkDiscontinuousInput();
			if (C.DEBUG)
				checkDebugInput();
		}
		
		protected function checkContinuousInput():void {
			if (currentMino && currentMino.falling)
				checkMinoMoveInput();
			else
				checkMinoSpawnInput();
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
					adjustScale(false);
				station.justRotated = false;
			}
		}
		
		protected function checkDiscontinuousInput():void {
			if (currentMino && currentMino.falling) {
				if (ControlSet.MINO_CW_KEY.justPressed())
					currentMino.rotateClockwise();
				if (ControlSet.MINO_CCW_KEY.justPressed())
					currentMino.rotateCounterclockwise();
				
				if (ControlSet.MINO_HELP_KEY.justPressed())
					hudLayer.add(new NewPieceInfo(currentMino));
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
		}
		
		protected function checkCamera():void {
			C.B.buffer = mapBuffer;
			if (!currentMino && (!GlobalCycleTimer.minosDropped || !tracker.safe)) {
				C.B.centerDrawShiftOn(station.core.gridLoc);
				if (_scale == 1)
					adjustScale(true);
			} else if (_scale != 1)
				adjustScale(false);
		}
		
		
		
		
		
		protected function checkPlayerEvents():void {
			if (!NewPlayerEvent.seen[NewPlayerEvent.ASTEROIDS] && !tracker.safe)
				hudLayer.add(NewPlayerEvent.onFirstAsteroids());
		}
		
		protected function checkGoal():void {
			var newFraction:int = Math.floor(station.mineralsLaunched * 4 / (initialMinerals * goal));
			if (newFraction > goalFraction)
				hudLayer.add(new FlashText((newFraction * 25) + "% of goal reached!", 0x80ffd000, 2));
			goalFraction = newFraction;
			hud.updateGoal(station.mineralsLaunched * 100 / (initialMinerals * goal));
		}
		
		protected function checkEndConditions():void {
			if (won() ||
					GlobalCycleTimer.outOfTime() ||
					station.core.damaged)
				
				beginEndgame();
		}
		
		protected function beginEndgame():void {
			FlxG.flash.start(0xefffffff, 3.5/*, endGame*/);
			missionOver = true;
			substate = SUBSTATE_MISSOVER;
			
			var shroud:FlxSprite = new FlxSprite().createGraphic(FlxG.width, FlxG.height, 0xff000000);
			shroud.alpha = 0.5;
			hudLayer.add(shroud);
			
			var endText:FlxText = new FlxText(20, FlxG.height / 2 - 30, FlxG.width - 40, " ");
			endText.setFormat(C.FONT, 48, 0xffffff, 'center');
			
			if (won()) {
				endText.text = "Victory!";
				endText.color = 0x10ff18;
			} else {
				endText.text = "Defeat.";
				endText.color = 0xff2810;
				if (!station.core.damaged)
					station.core.takeExplodeDamage( -1, -1, station.core);
			}
			hudLayer.add(endText);
			
			var endSub:FlxText = new FlxText(20, endText.y + endText.height + 5, FlxG.width - 40, " ");
			if (won())
				endSub.text = "Mineral goal reached!";
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
			checkCamera();
			super.update();
			hudLayer.update();
		}
		
		protected function endGame():void {		
			if (C.campaign) {
				if (won()) {
					C.campaign.endMission();
					if (C.campaign.nextMission)
						FlxG.state = new CampaignState;
					else
						FlxG.state = new CampaignVictoryState;
				} else if (C.campaign.lives) {
					C.campaign.lives--;
					FlxG.state = new CampaignState;
				} else
					FlxG.state = new CampaignDefeatState;
			} else
				FlxG.state = new MenuState;
		}
		
		protected function exitToMenu():void {
			FlxG.state = new MenuState;
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
			
			var stationBounds:Rectangle = station.bounds;
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
				
				C.B.drawShift = new Point(C.B.HALFWIDTH -C.B.PlayArea.x * C.BLOCK_SIZE, C.B.HALFHEIGHT - C.B.PlayArea.y * C.BLOCK_SIZE);
				//C.centerDrawShiftOn(station.core.gridLoc);
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
		//private function drawGlow():void {
			//if (!glowBuffer || glowBuffer.width != FlxG.width / C.GLOW_SCALE)
				//glowBuffer = new BitmapData(FlxG.width / C.GLOW_SCALE, FlxG.height / C.GLOW_SCALE, true, 0x0);
			//
			//matrix.identity();
			//matrix.scale(1 / C.GLOW_SCALE, 1 / C.GLOW_SCALE);
			//glowBuffer.draw(FlxG.buffer, matrix, glowColorTransform);
			//
			//matrix.identity();
			//matrix.scale(C.GLOW_SCALE, C.GLOW_SCALE);
			//FlxG.buffer.draw(glowBuffer, matrix, null, BlendMode.ADD);
		//}
		
		private const blurFilter:BlurFilter = new BlurFilter(C.GLOW_SCALE, C.GLOW_SCALE, 1);
		private function drawGlow():void {
			if (glowBuffer) {
				//glowBuffer.fillRect(new Rectangle(0, 0, FlxG.width, FlxG.height), 0x0);
				//glowBuffer.draw(FlxG.buffer);
			} else
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
			//var X:int = -(FlxG.width - width) / 2;
			//var Y:int = -(FlxG.height - height) / 2;
			
			//FlxG.camera = FlxG.addCamera(new FlxCamera(X, Y, width, height, scale)); //oh dear
			//FlxG.camera.buffer = new BitmapData(width, height, false, FlxG.bgColor);
			//FlxG.camera.resize(X, Y, width, height);
			
			//FlxG.camera.zoom = scale;
			//FlxG.camera.width = FlxG.width / scale;
			//FlxG.camera.height = FlxG.height / scale;
			//FlxG.camera.x = DEBUG_X = -(FlxG.width - FlxG.width / scale) / 2;
			//FlxG.camera.y = DEBUG_Y = -(FlxG.height - FlxG.height / scale) / 2;
			//FlxG.camera.buffer.dispose();
			//FlxG.camera.buffer = new BitmapData(FlxG.camera.width, FlxG.camera.height, false, 0xff000000);
}
