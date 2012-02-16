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
			rotateable = false;
		}
		
		override protected function minoLimitToFullyMine():int {
			return 85;
		}
		
		override protected function repositionLevel():void {
			rock.gridLoc.x = station.core.gridLoc.x;
			rock.gridLoc.y = Math.ceil(ShoreMission.atmosphere / 2);
			station.core.gridLoc.y = ShoreMission.atmosphere - mission.fullMapSize.y - 3;
		}
		
		override protected function addElements():void {
			var planet_bg:Mino = new Mino(rock.gridLoc.x, rock.gridLoc.y, mission.rawMap.map, mission.rawMap.center, 0xff303030);
			minoLayer.add(planet_bg);
			super.addElements();
			minoLayer.members.splice(0, 0, new Water(C.B.OUTER_BOUNDS.top + ShoreMission.atmosphere));
		}
		
		override protected function getAssortment(index:int):Array {
			var assortment:Array = [makeBag(SmallLauncher), makeBag(MediumLauncher), makeBag(LongDrill), makeBag(Scoop)];
			if (index)
				assortment.push(makeBag(RocketGun));
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
		
	}

}