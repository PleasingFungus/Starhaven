package Missions {
	import org.flixel.FlxU;
	import Mining.MineralBlock;
	import Mining.Terrain;
	import flash.geom.Point;
	/**
	 * ...
	 * @author ...
	 */
	public class PlanetMission extends TerrestrialMission {
		
		public function PlanetMission(Seed:Number) {
			mapWidth = 60;
			rockDepth = 12;
			atmosphere = 24;
			
			super(Seed);
		}
		override protected function randomMineralType():int {
			return MineralBlock.WEAK_MINERALS;
		}
	}

}