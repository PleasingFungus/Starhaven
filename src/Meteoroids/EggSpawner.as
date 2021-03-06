package Meteoroids {
	import org.flixel.FlxU;
	import org.flixel.FlxGroup;
	import flash.geom.Point;
	/**
	 * ...
	 * @author ...
	 */
	public class EggSpawner extends Spawner {
		
		public function EggSpawner(Warning:Number, Target:Point = null, SpeedFactor:Number = 1) {
			super( Warning, Target, SpeedFactor);
		}
		
		override public function spawnMeteoroid():Meteoroid {
			var furthest:int = C.B.getFurthest();
			var travelDist:Number = warning * speedFactor / (C.CYCLE_TIME * Meteoroid.period);
			
			var radius:int = furthest + travelDist;
			var angle:Number = FlxU.random() * 2 * Math.PI;
			var X:int = Math.cos(angle) * radius
			var Y:int = Math.sin(angle) * radius
			
			return new Meteoroid(X, Y, target, speedFactor);
		}
		
	}

}