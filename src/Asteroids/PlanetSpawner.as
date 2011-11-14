package Asteroids {
	import org.flixel.FlxU;
	import org.flixel.FlxGroup;
	/**
	 * ...
	 * @author ...
	 */
	public class PlanetSpawner extends Spawner {
		
		public function PlanetSpawner(Warning:int, Target:Mino) {
			super( Warning, Target);
		}
		
		override public function spawnAsteroid(asteroids:FlxGroup):void {
			var Y:int = C.B.OUTER_BOUNDS.top - 10;
			var X:int = C.B.OUTER_BOUNDS.left + FlxU.random() * C.B.OUTER_BOUNDS.width;
			
			asteroids.add(new Asteroid(X, Y, target.absoluteCenter));
		}
		
	}

}