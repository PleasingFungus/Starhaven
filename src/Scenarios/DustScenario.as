package Scenarios {
	import Missions.AsteroidMission;
	import Mining.BaseAsteroid;
	import Mining.NebulaCloud;
	import Mining.MetaResource;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import Mining.MineralBlock;
	import Missions.NebulaMission;
	import org.flixel.*;
	import Sminos.*;
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class DustScenario extends DefaultScenario {
		
		public function DustScenario(Seed:Number = NaN) {
			super(Seed);
			goal = 0.52;
			bg_sprites = _bgs;
			mapBuffer = 26;
		}
		
		override protected function _getBounds():Rectangle {
			return C.B.OUTER_BOUNDS;
		}
		
		override protected function createMission():void {
			mission = new AsteroidMission(seed, 0.75);
		}
		
		override protected function buildLevel():void {
			super.buildLevel();
			buildNebula();
		}
		
		protected function buildNebula():void {
			var nMission:NebulaMission = new NebulaMission(seed, 0.8);
			
			var preNebula:Number = new Date().valueOf();
			var nebula:NebulaCloud = new NebulaCloud(0, 0,
											 nMission.rawMap.map, nMission.rawMap.center);
			//var preNebula:Number = new Date().valueOf();
			C.log("Time spent building nebula: " + ((new Date().valueOf()) - preNebula) + " ms.");
			
			//erase overlapping nebula blocks
			for each (var aBlock:MineralBlock in rock.blocks)
				nebula.mine(aBlock.add(rock.absoluteCenter));
			nebula.forceSpriteReset();
			
			for each (aBlock in nebula.blocks)
				aBlock.valueFactor *= 2;
			
			station.resourceSource = new MetaResource([rock, nebula]);
			initialMinerals = station.mineralsAvailable;
			
			minoLayer.add(nebula);
		}
		
		override protected function repositionLevel():void {
			var closestLocation:Point = findClosestFreeSpot();
			//shift asteroid
			station.core.gridLoc.x = closestLocation.x;
			station.core.gridLoc.y = closestLocation.y;
			station.centroidOffset.x = -closestLocation.x;
			station.centroidOffset.y = -closestLocation.y;
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
		
		override protected function getAssortment(index:int):Array {
			var assortment:Array = [makeBag(SmallLauncher), makeBag(MediumLauncher), makeBag(LongDrill), makeBag(NebularAccumulator)];
			if (index)
				assortment.push(makeBag(RocketGun));
			if (!(C.DEBUG && C.NO_CREW))
				assortment = assortment.concat(makeBag(SmallBarracks), makeBag(SmallBarracks), makeBag(MediumBarracks));
			return assortment;
		}
		
		override protected function blockLimitToFullyMine():int {
			return 130;
		}
		
		override protected function createTracker(waveMeteos:Number = 2):void {
			super.createTracker(waveMeteos);
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
			
			//todo: add increasing dusty-haze for further-back asteroids (simple color-shift?)
		}
		
		[Embed(source = "../../lib/art/backgrounds/nebula_1.jpg")] private static const _bg01:Class;
		[Embed(source = "../../lib/art/backgrounds/nebula_2.jpg")] private static const _bg0:Class;
		[Embed(source = "../../lib/art/backgrounds/nebula_3.jpg")] private static const _bg1:Class;
		[Embed(source = "../../lib/art/backgrounds/nebula_4.jpg")] private static const _bg2:Class;
		[Embed(source = "../../lib/art/backgrounds/nebula_5.jpg")] private static const _bg3:Class;
		[Embed(source = "../../lib/art/backgrounds/nebula_6.jpg")] private static const _bg4:Class;
		private static const _bgs:Array = [_bg0, _bg01, _bg1, _bg2, _bg3, _bg4];
	}

}