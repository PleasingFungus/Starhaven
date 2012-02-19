package Meteoroids {
	import org.flixel.FlxGroup;
	/**
	 * ...
	 * @author ...
	 */
	public class Spawner {
		
		protected var warning:int;
		protected var target:Mino;
		protected var speedFactor:Number;
		public function Spawner(Warning:int, Target:Mino = null, SpeedFactor:Number = 1) {
			warning = Warning;
			target = Target;
			speedFactor = SpeedFactor;
		}
		
		public function spawnMeteoroid():Meteoroid {
			return null;
		}
	}

}