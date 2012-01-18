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
			mapWidth = (27 + FlxU.random() * 6) * 2;
			rockDepth = 12;
			atmosphere = 24;
			
			super(Seed);
		}
	}

}