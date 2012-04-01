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
	import InfoScreens.NewPlayerEvent;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class DustScenario extends SpaceScenario {
		
		public function DustScenario(Seed:Number = NaN) {
			super(Seed);
			bg_sprites = _bgs;
			mapBuffer = 26;
			bgMissionType = AsteroidMission;
			//goalMultiplier = 0.65;
			minoLimitMultiplier = 0.7;
			buildMusic = C.music.DUST_MUSIC;
		}
		
		override protected function createMission():void {
			mission = new AsteroidMission(seed, 0.75 * C.difficulty.scale());
		}
		
		override protected function buildLevel():void {
			super.buildLevel();
			buildNebula();
		}
		
		protected function buildNebula():void {
			var nMission:NebulaMission = new NebulaMission(seed, 0.8 * C.difficulty.scale());
			
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
			station.checkMinerals();
			initialMinerals = station.mineralsAvailable;
			C.log("Resources: "+rock.totalResources(), nebula.totalResources(), station.resourceSource.totalResources(), station.mineralsAvailable);
			
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
			var closestSpot:Point = new Point;
			while (rock.resourceAt(closestSpot))
				closestSpot.y -= 1;
			return closestSpot;
		}
		
		override protected function getAssortment(index:int):Array {
			var assortment:Array = [makeBag(NebularAccumulator), makeBag(LongDrill), makeBag(RocketGun)];
			if (index)
				assortment.push(makeBag(MediumLauncher), makeBag(SmallLauncher));
			else
				assortment.push(makeBag(SmallLauncher));
				
			if (!(C.DEBUG && C.NO_CREW)) {
				if (index)
					assortment.push(makeBag(MediumBarracks));
				assortment.push(makeBag(SmallBarracks));
			}
			return assortment;
		}
		
		override protected function createBG():void {
			super.createBG();
			bg.color = 0xc0ffc0; //desaturate?
		}
		
		override protected function bgAstrColor(astrScale:Number):uint {
			var colorComponent:int = 0xf0 * astrScale; //max 0x80
			return (colorComponent << 16) | (colorComponent << 8) | colorComponent;
		}
		
		override protected function checkPlayerEvents():void {
			NewPlayerEvent.fire(NewPlayerEvent.NEBULA);
			super.checkPlayerEvents();
		}
		
		[Embed(source = "../../lib/art/backgrounds/nebula_1.jpg")] private static const _bg01:Class;
		[Embed(source = "../../lib/art/backgrounds/nebula_2.jpg")] private static const _bg0:Class;
		[Embed(source = "../../lib/art/backgrounds/nebula_3.jpg")] private static const _bg1:Class;
		[Embed(source = "../../lib/art/backgrounds/nebula_4.jpg")] private static const _bg2:Class;
		[Embed(source = "../../lib/art/backgrounds/nebula_5.jpg")] private static const _bg3:Class;
		[Embed(source = "../../lib/art/backgrounds/nebula_6s.jpg")] private static const _bg4:Class;
		private static const _bgs:Array = [_bg0, _bg01, _bg1, _bg2, _bg3, _bg4];
	}

}