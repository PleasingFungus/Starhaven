package Meteoroids {
	import org.flixel.FlxGroup;
	import flash.geom.Point;
	/**
	 * ...
	 * @author ...
	 */
	public class Spawner {
		
		protected var warning:Number;
		protected var target:Point;
		protected var speedFactor:Number;
		public function Spawner(Warning:Number, Target:Point = null, SpeedFactor:Number = 1) {
			warning = Warning;
			target = Target;
			speedFactor = SpeedFactor;
		}
		
		public function spawnMeteoroid():Meteoroid {
			return null;
		}
	}

}