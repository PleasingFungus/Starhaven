package Scenarios {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import Mining.BaseAsteroid;
	import Mining.MineralBlock;
	import Mining.Terrain;
	import Mining.Water;
	import Missions.WaterMission;
	import org.flixel.FlxU;
	import Meteoroids.PlanetSpawner;
	import Sminos.Scoop;
	import GrabBags.BagType;
	import Sminos.SmallBarracks;
	import Sminos.SmallLauncher;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class WaterScenario extends DefaultScenario {
		
		public function WaterScenario(Seed:Number = NaN) {
			super(Seed);
			
			mapBuffer = 0;
			miningTool = Scoop;
			spawner = PlanetSpawner;
			missionType = WaterMission;
			bg_sprite = _bg;
			rotateable = false;
			conduitLimit = 8;
		}
		
		override protected function blockLimitToFullyMine():int {
			return 90;
		}
		
		override protected function repositionLevel():void {
			rock.gridLoc.x = station.core.gridLoc.x;
			rock.gridLoc.y = Math.ceil((mission as WaterMission).atmosphere / 2);
			station.core.gridLoc.y = (mission as WaterMission).atmosphere - mission.fullMapSize.y - 3;
		}
		
		override protected function addElements():void {
			var planet_bg:Mino = new Mino(rock.gridLoc.x, rock.gridLoc.y, mission.rawMap.map, mission.rawMap.center, 0xff303030);
			minoLayer.add(planet_bg);
			super.addElements();
			minoLayer.members.splice(0, 0, new Water(C.B.OUTER_BOUNDS.top + (mission as WaterMission).atmosphere));
		}
		
		[Embed(source = "../../lib/art/backgrounds/planetside.png")] private static const _bg:Class;
		
	}

}