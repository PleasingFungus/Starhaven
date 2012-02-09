package Scenarios {
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import InfoScreens.HelpState;
	import Mining.BaseAsteroid
	import Mining.MineralBlock;
	import Mining.Terrain;
	import Missions.AsteroidMission;
	import org.flixel.*;
	import Meteoroids.MeteoroidTracker;
	/**
	 * ...
	 * @author ...
	 */
	public class AsteroidScenario extends DefaultScenario {
		
		public function AsteroidScenario(Seed:Number = NaN) {
			super(Seed);
			
			goal = 0.75;
			bg_sprites = _bgs;
			mapBuffer = 20;
			missionType = AsteroidMission;
		}
		
		override protected function blockLimitToFullyMine():int {
			return 50;
		}
		
		override protected function createTracker(waveMeteos:Number = 2):void {
			super.createTracker(waveMeteos);
		}
		
		override protected function repositionLevel():void {
			var closestLocation:Point = findClosestFreeSpot();
			
			station.core.gridLoc.x = closestLocation.x;
			station.core.gridLoc.y = closestLocation.y;
			station.centroidOffset.x = -closestLocation.x;
			station.centroidOffset.y = -closestLocation.y;
			
			//cleanMinerals();
		}
		
		protected function findClosestFreeSpot():Point {
			var bounds:Rectangle = new Rectangle(0, 0, mission.rawMap.mapDim.x, mission.rawMap.mapDim.y);
			
			var minoGrid:Array = new Array(bounds.height * bounds.width);
			for each (var block:Block in mission.rawMap.map)
				minoGrid[block.x + block.y * bounds.width] = true;
			
			var closest:Number = int.MAX_VALUE;
			var options:Array = [];
			for (var x:int = 0; x < bounds.width; x++)
				for (var y:int = 0; y < bounds.height; y++)
					if (!minoGrid[x + y * bounds.width]) {
						var dx:int = x - bounds.width / 2;
						var dy:int = y - bounds.height / 2;
						var dist:Number = dx * dx + dy * dy;
						if (dist <= closest)
							closest = dist;
					}
			
			
			for (x = 0; x < bounds.width; x++)
				for (y = 0; y < bounds.height; y++)
					if (!minoGrid[x + y * bounds.width]) {
						dx = x - bounds.width / 2;
						dy = y - bounds.height / 2;
						dist = dx * dx + dy * dy;
						if (dist <= closest)
							options.push(new Point(Math.floor(x - bounds.width / 2), Math.floor(y - bounds.height / 2)));
					}
			
			if (options.length)
				return options[Math.floor(FlxU.random() * options.length)];
			
			return new Point( -1, -1); //amusing, valid
		}
		
		override protected function createBG():void {
			super.createBG();
			
			parallaxBG = new FlxGroup;
			var sectors:Array = new Array(9);
			for (var X:int = 0; X < 3; X++)
				for (var Y:int = 0; Y < 3; Y++)
					sectors[X + Y * 3] = new Point(X, Y);
			
			for (var i:int = 0; i < 7; i++) {
				var bgMission:AsteroidMission = new AsteroidMission(NaN, 0.9);
				var astrScale:Number = i > 3 ? i > 5 ? 1/2 : 1/4 : 1/8; 
				var bgAsteroid:BaseAsteroid = new BaseAsteroid(-1, -1, bgMission.rawMap.map, bgMission.rawMap.center, astrScale);
				var bmp:BitmapData = bgAsteroid.pixels.clone();
				
				var sectorIndex:int = FlxU.random() * sectors.length;
				var sector:Point = sectors[sectorIndex];
				sectors.splice(sectorIndex, 1);
				
				var spr:FlxSprite = new FlxSprite((FlxU.random()) * FlxG.width * 1.5 * sector.x / 3,
												  (FlxU.random()) * FlxG.height * 1.5 * sector.y / 3);
				spr.scrollFactor.x = spr.scrollFactor.y = astrScale;
				spr.pixels = bmp;
				spr.frame = 0;
				
				spr.color = 0x606060;
				parallaxBG.add(spr);
			}
			parallaxBG.scrollFactor.x = parallaxBG.scrollFactor.y = 0.1;
		}
		
		//protected function cleanMinerals():void {
			//var direction:Point, done:Boolean, p:Point;
			//p = new Point;
			//var sabsc:Point = station.core.absoluteCenter;
			//var stationBounds:Rectangle = new Rectangle(Math.floor(sabsc.x - station.core.blockDim.x / 2),
													    //Math.floor(sabsc.y - station.core.blockDim.y / 2),
														//station.core.blockDim.x, station.core.blockDim.y);
			//
			//var sign:int, block:MineralBlock;
			//if (Math.abs(station.core.gridLoc.x) > Math.abs(station.core.gridLoc.y)) {
				//if (station.core.gridLoc.x > 0) {
					//p.x = stationBounds.left; sign = -1;
				//} else {
					//p.x = stationBounds.right; sign = 1;
				//}
				//
				//C.log("Going xwise: " + p.x);
				//
				//for (; !done; p.x += sign) {
					//for (p.y = stationBounds.top; p.y < stationBounds.bottom; p.y++) {
						//block = rock.resourceAt(p);
						//if (block) {
							//done = done || block.type == MineralBlock.BEDROCK;
							//block.type = MineralBlock.BEDROCK;
						//}
					//}
					//
					//done = done || ((sign > 0) == (p.x > 0));
				//}
			//} else {
				//if (station.core.gridLoc.y > 0) {
					//p.y = stationBounds.top; sign = -1;
				//} else {
					//p.y = stationBounds.bottom; sign = 1;
				//}
				//
				//C.log("Going ywise: " + p.y);
				//
				//for (; !done; p.y += sign) {
					//for (p.x = stationBounds.left; p.x < stationBounds.right; p.x++) {
						//block = rock.resourceAt(p);
						//if (block) {
							//done = done || block.type == MineralBlock.BEDROCK;
							//block.type = MineralBlock.BEDROCK;
						//}
					//}
					//
					//done = done || ((sign > 0) == (p.y > 0));
				//}
			//}
			//
			//rock.newlyDamaged = false;
		//}
		
		
		[Embed(source = "../../lib/art/backgrounds/garradd_3.jpg")] private static const _bg1:Class;
		[Embed(source = "../../lib/art/backgrounds/garradd_4.jpg")] private static const _bg2:Class;
		[Embed(source = "../../lib/art/backgrounds/garradd_5.jpg")] private static const _bg3:Class;
		[Embed(source = "../../lib/art/backgrounds/garradd_6.jpg")] private static const _bg4:Class;
		[Embed(source = "../../lib/art/backgrounds/garradd_7.jpg")] private static const _bg5:Class;
		private static const _bgs:Array = [_bg1, _bg2, _bg3, _bg4, _bg5];
	}
	

}