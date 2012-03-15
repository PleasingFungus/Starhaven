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
	import Musics.MusicTrack;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class WaterScenario extends PlanetScenario {
		
		public function WaterScenario(Seed:Number = NaN) {
			super(Seed);
			
			mapBuffer = 0;
			miningTool = Scoop;
			spawner = PlanetSpawner;
			missionType = WaterMission;
			rotateable = false;
			conduitLimit = 8;
			buildMusic = new MusicTrack(C.music.MUSIC_PREFIX + "ST_AD_Loop.m4a", C.music.MUSIC_PREFIX + "ST_AD_Intro.m4a");
		}
		
		override protected function repositionLevel():void {
			rock.gridLoc.x = station.core.gridLoc.x;
			rock.gridLoc.y = Math.ceil((mission as WaterMission).atmosphere / 2);
			station.core.gridLoc.y = (mission as WaterMission).atmosphere - mission.fullMapSize.y - 3;
		}
		
		override protected function addElements():void {
			var planet_bg:Mino = new Mino(rock.gridLoc.x, rock.gridLoc.y, mission.rawMap.map, mission.rawMap.center, 0xff303030);
			minoLayer.add(planet_bg);
			
			minoLayer.add(new Water(C.B.OUTER_BOUNDS.top + (mission as WaterMission).atmosphere));
			
			super.addElements();
		}
		
		override protected function getLandColor(skyHue:Number):uint {
			return 0x38619c;
		}
		
		override protected function get skylineSpr():Class {
			return _skyline;
		}
		
		[Embed(source = "../../lib/art/backgrounds/skyline.png")] private const _skyline:Class;
	}

}