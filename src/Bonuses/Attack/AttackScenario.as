package Bonuses.Attack {
	import Scenarios.DefaultScenario;
	import org.flixel.*;
	import Mining.PlanetMaterial;
	import Controls.ControlSet;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class AttackScenario extends DefaultScenario {
		
		public function AttackScenario() {
			super(NaN);
			
			rotateable = false;
			mapBuffer = 0;
			victoryText = "Targets destroyed!";
		}
		
		private var skyline:FlxSprite;
		protected var lives:int;
		protected var currentMeteo:
		
		override public function create():void {
			super.create();
			//TODO: add loaded mission
			//TODO: add preplaced parts
			//TODO: replace hud
		}
		
		override protected function createStation():void {
			setBounds();
			buildLevel();
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
		
		override protected function buildRock():void {
			rock = new PlanetMaterial( -1, -1, mission.rawMap.map, mission.rawMap.center);
			rock.color = skyline.color;
		}
		
		override protected function addElements():void {
			var planet_bg:Mino = new Mino(rock.gridLoc.x, rock.gridLoc.y, mission.rawMap.map, mission.rawMap.center, 0xff23170f);
			//planet_bg.color = C.interpolateColors(planet_bg.color, skyline.color, 0.5);
			minoLayer.add(planet_bg);
			super.addElements();
			
			addBase();
		}
		
		protected function addBase():void {
			//TODO
		}
		
		override protected function setupBags():void { } //not needed
		override protected function createTracker(_:Number = 3):void { } //likewise
		
		override protected function createHUD():FlxGroup { 
			var hud:FlxGroup = new FlxGroup();
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
			
			checkGoal();
			checkEndConditions();
		}
		
		override protected function checkCurrentMino():void {
			//TODO
		}
		
		override protected function checkInput():void {
			//TODO
			
			if (ControlSet.CANCEL_KEY.justPressed())
				enterPauseState();
		}
		
		override protected function checkCamera():void {
			//TODO
		}
		
		override protected function checkGoal():void {
			//TODO
		}
		
		override protected function checkEndConditions():void {
			//TODO
		}
		
		override protected function resetLevel(_:String):void {
			super.resetLevel(_);
			//TODO
		}
		
		[Embed(source = "../../lib/art/backgrounds/skyline_dirt.png")] private const _skyline:Class;
	}

}