package Meteoroids {
	import org.flixel.FlxU;
	import org.flixel.FlxGroup;
	/**
	 * ...
	 * @author ...
	 */
	public class EggSpawner extends Spawner {
		
		public function EggSpawner(Warning:int, Target:Mino = null) {
			super( Warning, Target);
		}
		
		override public function spawnMeteoroid():Meteoroid {
			var furthest:int = C.B.getFurthest();
			var travelDist:Number = warning / (C.CYCLE_TIME * Meteoroid.period);
			
			var radius:int = furthest + travelDist;
			var angle:Number = FlxU.random() * 2 * Math.PI;
			var X:int = Math.cos(angle) * radius
			var Y:int = Math.sin(angle) * radius
			
			return new Meteoroid(X, Y, target.absoluteCenter);
		}
		
	}

}