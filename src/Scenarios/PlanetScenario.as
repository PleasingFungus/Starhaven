package Scenarios {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import Mining.BaseAsteroid;
	import Mining.MineralBlock;
	import Mining.Terrain;
	import Missions.PlanetMission;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	import Meteoroids.PlanetSpawner;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author ...
	 */
	public class PlanetScenario extends DefaultScenario {
		
		public function PlanetScenario(Seed:Number = NaN) {
			super(Seed);
			
			mapBuffer = 0;
			spawner = PlanetSpawner;
			missionType = PlanetMission;
			goal = 0.65; //should be higher?
			bg_sprite = _bg;
			//bg_sprites = _bgs;
			rotateable = false;
		}
		
		override protected function blockLimitToFullyMine():int {
			return 85;
		}
		
		override protected function repositionLevel():void {
			station.core.gridLoc.y = (mission as PlanetMission).atmosphere - mission.fullMapSize.y;
			
			rock.gridLoc.x = station.core.gridLoc.x;
			rock.gridLoc.y = Math.ceil((mission as PlanetMission).atmosphere / 2);
		}
		
		override protected function addElements():void {
			var planet_bg:Mino = new Mino(rock.gridLoc.x, rock.gridLoc.y, mission.rawMap.map, mission.rawMap.center, 0xff303030);
			minoLayer.add(planet_bg);
			super.addElements();
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
				var brightness:Number = 0.3 + 0.6 * skyFraction;
				strip.color = C.HSVToRGB(hue, .5, 1);
				strip.alpha = brightness;
				sky.draw(strip, 0, y * C.BLOCK_SIZE);
			}
			
			//clouds
			
			/*
			var clouds:Array = new Array(FLXW * FLXH);
			var cloudClusters:int = 10;
			for (var i:int = 0; i < cloudClusters; i++) {
				
				var rx:int = FlxU.random() * FLXW;
				var ry:int = FlxU.random() * FLXH;
				var cx:int = 3;
				var cy:int = 2;
				var cx2:int = cx * cx;
				var cy2:int = cy * cy;
				
				for (x = Math.max(rx - cx, 0); x < Math.min(rx + cx + 1, FLXW); x++)
					for (y = Math.max(ry - cy, 0); y < Math.min(ry + cy + 1, FLXH); y++) {
						var dx:int = x - rx;
						var dy:int = y - ry;
						if (i == 0)
							C.log(rx, ry, x, y, dx, dy, cx, cy, dx*dx / cx2 + dy*dy / cy2);
						if (dx*dx / cx2 + dy*dy / cy2 <= 1)
							clouds[x + y * FLXW] = true;
					}
			}
		
			stamp.color = 0xffffff;
			stamp.alpha = 0.25;
			for (x = 0; x < FLXW; x++)
				for (y = 0; y < FLXH; y++) {
					var rand:Number = FlxU.random();
					if (rand < 0.04)
						clouds[x + y * FLXW] = true;
					else if (rand < 0.14)
						clouds[x + y * FLXW] = false;
					
					if (clouds[x + y * FLXW])
						sky.draw(stamp, x * C.BLOCK_SIZE, y * C.BLOCK_SIZE);
				}
			*/
			
			//done
			
			bg = sky;
		}
		
		//[Embed(source = "../../lib/art/backgrounds/bg_1.jpg")] private static const _bg01:Class;
		//[Embed(source = "../../lib/art/backgrounds/bg_2.jpg")] private static const _bg0:Class;
		//[Embed(source = "../../lib/art/backgrounds/bg_3.jpg")] private static const _bg1:Class;
		//[Embed(source = "../../lib/art/backgrounds/bg_4.jpg")] private static const _bg2:Class;
		//[Embed(source = "../../lib/art/backgrounds/bg_5.jpg")] private static const _bg3:Class;
		//[Embed(source = "../../lib/art/backgrounds/bg_6.jpg")] private static const _bg4:Class;
		//private static const _bgs:Array = [_bg0, _bg01, _bg1, _bg2, _bg3, _bg4];
		[Embed(source = "../../lib/art/backgrounds/planetside.png")] private static const _bg:Class;
	}

}