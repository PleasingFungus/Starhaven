package GameBonuses.Attack {
	import org.flixel.*;
	import Missions.LoadedMission;
	import Mining.PlanetMaterial;
	import flash.geom.Point;
	import Editor.StationLoader;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class AttackLevelOne extends AttackScenario {
		
		private var skyline:FlxSprite;
		
		public function AttackLevelOne() {
			super();
			initialLives = 3;
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
			
			super.addElements();
		}
		
		
		override protected function makeStations():void {
			makeStation( -1, 4, ["Hook-Conduit,-4,4,0", "Long-Conduit,-9,4,0", "Long-Conduit,1,4,0", "LeftHook-Conduit,3,2,2", "LeftHook-Conduit,8,2,0", "Long-Conduit,8,-1,3", "LeftHook-Conduit,9,-4,2", "LeftHook-Conduit,6,-4,2", "LeftHook-Conduit,-11,2,3", "Long-Conduit,-11,0,3", "LeftHook-Conduit,-11,-4,2", "Small Barracks,8,-6,3", "Small Barracks,1,2,3", "Small Barracks,-11,-6,3", "Rocket Gun,-8,-5,3", "Rocket Gun,6,-5,3", "Rocket Gun,2,1,3", "Hook-Conduit,-12,-5,0"]);
		}
		
		[Embed(source = "../../../lib/art/backgrounds/skyline_mtn.png")] private const _skyline:Class;
		[Embed(source = "../../../lib/missions/attack_1.png")] private const _raw_mission:Class;
	}

}