package GameBonuses.Attack {
	import org.flixel.*;
	import Missions.LoadedMission;
	import Mining.PlanetMaterial;
	import flash.geom.Point;
	import Editor.StationLoader;
	import Mining.Water;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class AttackLevelTwo extends AttackScenario {
		
		private var skyline:FlxSprite;
		
		public function AttackLevelTwo() {
			super();
			initialLives = 5;
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
			return 0x38619c;
		}
		
		override protected function createMission():void {
			mission = new LoadedMission(_raw_mission);
		}
		
		override protected function buildRock():void {
			rock = new PlanetMaterial(-10, 0, mission.rawMap.map, mission.rawMap.center);
			rock.color = skyline.color;
		}
		
		override protected function repositionLevel():void {
			rock.center.x += 5;
			rock.center.y += 0;
		}
		
		override protected function eraseOverlap():void { } //not needed
		
		override protected function addElements():void {
			var planet_bg:Mino = new Mino(rock.gridLoc.x, rock.gridLoc.y, mission.rawMap.map, mission.rawMap.center, 0xff23170f);
			//planet_bg.color = C.interpolateColors(planet_bg.color, skyline.color, 0.5);
			minoLayer.add(planet_bg);
			minoLayer.add(new Water(C.B.OUTER_BOUNDS.top + 12));
			
			super.addElements();
		
		}
		
		override protected function makeStations():void {
			makeStation( -5, -7, ["Hook-Conduit,-7,-6,0", "Hook-Conduit,-10,-4,1", "Long-Conduit,-13,-6,0", "Long-Conduit,-17,-6,0", "LeftHook-Conduit,-19,-4,1", "Long-Conduit,-22,-6,0", "Long-Conduit,-26,-6,0", "Long-Conduit,-2,-6,0", "Small Barracks,-1,-8,3", "Small Barracks,-14,-8,3", "Rocket Gun,-11,-8,1", "Rocket Gun,-3,-8,1"]);
			makeStation( 3, -7, null);
		}
		
		[Embed(source = "../../../lib/art/backgrounds/skyline.png")] private const _skyline:Class;
		[Embed(source = "../../../lib/missions/attack_2.png")] private const _raw_mission:Class;
		
	}

}