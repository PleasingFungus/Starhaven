package Scenarios {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import Mining.BaseAsteroid;
	import Mining.MineralBlock;
	import Mining.Terrain;
	import Mining.Water;
	import Missions.ShoreMission;
	import org.flixel.FlxU;
	import Meteoroids.PlanetSpawner;
	import GrabBags.BagType;
	import Sminos.*;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class ShoreScenario extends DefaultScenario {
		
		public function ShoreScenario(Seed:Number = NaN) {
			super(Seed);
			
			mapBuffer = 0;
			spawner = PlanetSpawner;
			missionType = ShoreMission;
			bg_sprite = _bg;
			rotateable = false;
		}
		
		override protected function blockLimitToFullyMine():int {
			return 85;
		}
		
		override protected function createBG():void {
			super.createBG();
		}
		
		override protected function createStation():void {
			resourceSource = new BaseAsteroid( -1, -1, mission.rawMap.map, mission.rawMap.center);
			super.createStation();
			buildPlanet();
		}
		
		protected function buildPlanet():void {
			var planet:BaseAsteroid = resourceSource as BaseAsteroid;
			//shift planet
			station.core.gridLoc.y = ShoreMission.atmosphere - mission.fullMapSize.y - 3;
			Mino.resetGrid();
			station.core.addToGrid();
			planet.gridLoc.x = station.core.gridLoc.x;
			planet.gridLoc.y = Math.ceil(ShoreMission.atmosphere / 2);
			//erase overlapping planet blocks
			for (var i:int = 0; i < mission.rawMap.map.length; i++) {
				var aBlock:MineralBlock = mission.rawMap.map[i];
				var adjustedplanetBlock:Point = new Point(aBlock.x + planet.absoluteCenter.x,
															aBlock.y + planet.absoluteCenter.y);
				if (station.core.bounds.containsPoint(adjustedplanetBlock)) {
					mission.rawMap.map.splice(i, 1);
					i--;
				}
			}
			planet.forceSpriteReset();
			
			station.resourceSource = planet;
			initialMinerals = station.mineralsAvailable;
			
			var planet_bg:Mino = new Mino(planet.gridLoc.x, planet.gridLoc.y, mission.rawMap.map, mission.rawMap.center, 0xff303030);
			
			minoLayer.add(planet_bg);
			minoLayer.add(planet);
			station.add(planet);
			Mino.all_minos.push(planet);
			planet.addToGrid();
			
			minoLayer.members.splice(0, 0, new Water());
		}
		
		override protected function getAssortment(index:int):Array {
			var assortment:Array = [makeBag(SmallLauncher), makeBag(MediumLauncher), makeBag(LongDrill), makeBag(Scoop)];
			if (index && C.BEAM_DEFENSE)
				assortment.push(makeBag(AsteroidGun));
			if (!(C.DEBUG && C.NO_CREW))
				assortment = assortment.concat(makeBag(SmallBarracks), makeBag(SmallBarracks), makeBag(MediumBarracks));
			return assortment;
		}
		
		protected var conduits:int;
		override protected function makeBag(primarySmino:Class):BagType {
			if (conduits < 8) {
				conduits++;
				return super.makeBag(primarySmino);
			} else
				return new BagType(null, 1, [primarySmino]);
		}
		
		[Embed(source = "../../lib/art/backgrounds/planetside.png")] private static const _bg:Class;
		
	}

}