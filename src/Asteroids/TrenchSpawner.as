package Asteroids {
	import org.flixel.FlxU;
	import Missions.TrenchMission;
	import org.flixel.FlxGroup;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class TrenchSpawner extends Spawner {
		
		public function TrenchSpawner( Warning:int, Target:Mino) {
			super(Warning, Target);
		}
		
		override public function spawnAsteroid(asteroids:FlxGroup):void {
			var Y:int = C.B.OUTER_BOUNDS.top - 10;
			var X:int = C.B.OUTER_BOUNDS.left + TrenchMission.TRENCH_WIDTH / 2 + FlxU.random() * TrenchMission.TRENCH_WIDTH;
			
			asteroids.add(new Asteroid(X, Y, target.absoluteCenter));
		}
		
	}

}