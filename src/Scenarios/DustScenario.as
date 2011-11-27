package Scenarios {
	import Missions.AsteroidMission;
	import Mining.BaseAsteroid;
	import Mining.NebulaCloud;
	import Mining.MetaResource;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import Mining.MineralBlock;
	import Missions.NebulaMission;
	import org.flixel.FlxU;
	import Sminos.*;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class DustScenario extends DefaultScenario {
		
		protected var nMission:NebulaMission;
		protected var aMission:AsteroidMission;
		public function DustScenario(Seed:Number = NaN) {
			super(Seed);
			goal = 0.35;
			if (C.difficulty.hard)
				goal = 0.52;
			bg_sprites = _bgs;
			mapBuffer = 26;
			//goal stuff
			//bombs?
		}
		
		override public function create():void {
			nMission = new NebulaMission(seed, 0.8);
			aMission = new AsteroidMission(seed, 0.75);
			mapDim = aMission.fullMapSize;
			super.create();
		}
		
		override protected function _getBounds():Rectangle {
			return C.B.OUTER_BOUNDS;
		}
		
		override protected function createStation():void {
			var preNebula:Number = new Date().valueOf();
			var nebula:NebulaCloud = new NebulaCloud(0, 0,
											 nMission.rawMap.map, nMission.rawMap.center);
			//var preNebula:Number = new Date().valueOf();
			C.log("Time spent building nebula: " + ((new Date().valueOf()) - preNebula) + " ms.");
			
			var asteroid:BaseAsteroid = new BaseAsteroid(0, 0, aMission.rawMap.map, aMission.rawMap.center);
			
			super.createStation();
			
			var closestLocation:Point = findClosestFreeSpot();
			//shift asteroid
			station.core.gridLoc.x = closestLocation.x;
			station.core.gridLoc.y = closestLocation.y;
			station.centroidOffset.x = -closestLocation.x;
			station.centroidOffset.y = -closestLocation.y;
			//erase overlapping asteroid blocks
			for (var i:int = 0; i < asteroid.blocks.length; i++) {
				var aBlock:MineralBlock = asteroid.blocks[i];
				var adjustedAsteroidBlock:Point = new Point(aBlock.x + asteroid.absoluteCenter.x,
															aBlock.y + asteroid.absoluteCenter.y);
				if (station.core.bounds.containsPoint(adjustedAsteroidBlock)) {
					asteroid.blocks.splice(i, 1);
					i--;
				} else
					nebula.mine(adjustedAsteroidBlock);
			}
			asteroid.forceSpriteReset();
			
			station.add(asteroid);
			minoLayer.add(asteroid);
			Mino.all_minos.push(asteroid);
			asteroid.addToGrid();
			
			//erase overlapping nebula blocks
			for each (var block:Block in station.core.blocks)
				nebula.mine(block.add(station.core.absoluteCenter));
			for each (aBlock in nebula.blocks)
				aBlock.valueFactor *= 2;
			nebula.forceSpriteReset();
			
			station.resourceSource = new MetaResource([asteroid, nebula]);
			initialMinerals = station.mineralsAvailable;
			
			minoLayer.add(nebula);
		}
		
		protected function findClosestFreeSpot():Point {
			var bounds:Rectangle = new Rectangle(0, 0, aMission.rawMap.mapDim.x, aMission.rawMap.mapDim.y);
			
			var minoGrid:Array = new Array(bounds.height * bounds.width);
			for each (var block:Block in aMission.rawMap.map)
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
			var assortment:Array = [makeBag(SmallFab), makeBag(Fabricator), makeBag(LongDrill), makeBag(NebularAccumulator)];
			if (index)
				assortment.push(makeBag(AsteroidGun));
			if (!(C.DEBUG && C.NO_CREW))
				assortment = assortment.concat(makeBag(SmallBarracks), makeBag(MediumBarracks));
			return assortment;
		}
		
		override protected function createGCT(miningTime:Number = 65):void {
			super.createGCT(miningTime);
		}
		
		override protected function createTracker(Density:Number = 2, WaveSpacing:int = 18):void {
			super.createTracker(Density, WaveSpacing);
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