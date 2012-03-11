package GameBonuses.Attack {
	import GameBonuses.BonusState;
	import HUDs.MapBounds;
	import Missions.LoadedMission;
	import Scenarios.DefaultScenario;
	import org.flixel.*;
	import Mining.PlanetMaterial;
	import Controls.ControlSet;
	import flash.geom.Point;
	import Sminos.SecondaryReactor;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class AttackScenario extends DefaultScenario {
		
		public function AttackScenario() {
			super(NaN);
			
			rotateable = false;
			canFastfall = false;
			C.B.viewLimited = true;
			mapBuffer = 0;
			victoryText = "Targets destroyed!";
		}
		
		private var skyline:FlxSprite;
		private var aggregate:Aggregate;
		private var arrowHint:AttackHelper;
		protected var stations:Vector.<Station>
		protected var lives:int;
		protected var initialLives:int = 3;
		
		override public function create():void {
			lives = initialLives;
			stations = new Vector.<Station>;
			
			super.create();
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
		
		override protected function createBG():void {
			var FLXW:int = FlxG.width / C.BLOCK_SIZE;
			var FLXH:int = FlxG.height / C.BLOCK_SIZE;
			var x:int, y:int;
			
			var sky:FlxSprite = new FlxSprite().createGraphic(FlxG.width, FlxG.height, 0xff000000, true, "sky");
			sky.fill(0xff000000);
			
			//generate 'sun'
			var stamp:FlxSprite = new FlxSprite().createGraphic(C.BLOCK_SIZE, C.BLOCK_SIZE);
			stamp.color = 0xfffd00;
			var sunAngle:Number = FlxU.random() * Math.PI / 2 + Math.PI * 5/4;
			var sunPoint:Point = new Point((Math.cos(sunAngle) * .8 + 1) * FLXW / 2, 
										   (Math.sin(sunAngle) * .8 + 1) * FLXH / 2
										   /*FLXW / 2, FLXH / 4*/);
			var sunRad:int = FlxU.random() * 3;
			for (x = sunPoint.x - sunRad; x <= sunPoint.x + sunRad; x++)
				for (y = sunPoint.y - sunRad; y <= sunPoint.y + sunRad; y++)
					sky.draw(stamp, x * C.BLOCK_SIZE, y * C.BLOCK_SIZE);
			
			//basic sky color
			
			var hue:Number = FlxU.random();
			var strip:FlxSprite = new FlxSprite().createGraphic(FlxG.width, C.BLOCK_SIZE);
			for (y = 0; y < FLXH; y++) {
				var skyFraction:Number = y / FLXH;
				skyFraction = 1 - (1 - skyFraction) * (1 - skyFraction);
				var brightness:Number = 0.25 + 0.45 * skyFraction;
				strip.color = C.HSVToRGB(hue, .5, 1);
				strip.alpha = brightness;
				sky.draw(strip, 0, y * C.BLOCK_SIZE);
			}
			
			bg = sky;
			
			parallaxBG = new FlxGroup;
			skyline = new FlxSprite(-FlxG.width / 2, FlxG.height / 2, _skyline);
			skyline.scrollFactor.x = skyline.scrollFactor.y = 0.25;
			skyline.color = getLandColor(hue);
			parallaxBG.add(skyline);
		}
		
		protected function getLandColor(skyHue:Number):uint {
			return C.HSVToRGB(skyHue, .25, 0.72);
		}
		
		override protected function createMission():void {
			mission = new LoadedMission(_raw_mission);
		}
		
		override protected function buildRock():void {
			rock = new PlanetMaterial(-10, 0, mission.rawMap.map, mission.rawMap.center);
			rock.color = skyline.color;
		}
		
		override protected function repositionLevel():void {
			rock.center.x += 0;
			rock.center.y += 0;
		}
		
		override protected function eraseOverlap():void { } //not needed
		
		override protected function addElements():void {
			var planet_bg:Mino = new Mino(rock.gridLoc.x, rock.gridLoc.y, mission.rawMap.map, mission.rawMap.center, 0xff23170f);
			//planet_bg.color = C.interpolateColors(planet_bg.color, skyline.color, 0.5);
			minoLayer.add(planet_bg);
			
			Mino.all_minos.push(rock);			
			minoLayer.add(rock);
			
			addBase();
			
			setBounds();
		}
		
		protected function addBase():void {
			aggregate = new Aggregate(rock, null);
			aggregate.centroidOffset.x = 17;
			aggregate.centroidOffset.y = 20;
			
			var station:Station = new AttackStation(null);
			station.core.gridLoc.y += 4;
			Mino.resetGrid(); //fix initial core loc
			rock.addToGrid(); //fix resulting missing rock
			station.core.addToGrid();
			
			minoLayer.add(station.core);
			minoLayer.add(station);
			stations.push(station);
		}
		
		protected function addSmino(X:int, Y:int, minoType:Class, Facing:int = FlxSprite.DOWN):void {
			var smino:Smino = new minoType(X, Y);
			while (smino.facing != Facing)
				smino.rotateClockwise(true);
			smino.setTutorial(aggregate);
			minoLayer.add(smino);
		}
		
		override protected function setupBags():void { } //not needed
		override protected function createTracker(_:Number = 3):void { } //likewise
		override protected function setHudStation():void { } //actively detrimental
		
		override protected function createHUD():FlxGroup { 
			hud = new AttackHud();
			
			var bounds:MapBounds = new MapBounds();
			minoLayer.add(bounds);
			hud.bounds = bounds;
			
			//TODO
			return hud;
		}
		
		override protected function checkPlayerEvents():void {
			//TODO
		}
		
		
		
		
		
		
		
		
		
		
		
		override protected function normalUpdate():void {
			checkCurrentMino();
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
				if (station.core.dead)
					deadStations++;
			return deadStations * 100 / stations.length;
		}
		
		override protected function checkEndConditions():void {
			if (substate == SUBSTATE_MISSOVER)
				return; //to avoid double-triggering on debug input
			
			if (won() || (lives == 0 && (!currentMino || currentMino.dead)))
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
			//TODO [high scores]
		}
		
		override protected function endGame():void {
			FlxG.state = new BonusState;
		}
		
		override protected function exitToMenu(_:String = null):void {
			FlxG.state = new BonusState;
		}
		
		[Embed(source = "../../../lib/art/backgrounds/skyline_dirt.png")] private const _skyline:Class;
		[Embed(source = "../../../lib/missions/tutorial_housing.png")] private const _raw_mission:Class;
	}

}