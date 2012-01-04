package Meteoroids {
	import org.flixel.FlxGroup;
	/**
	 * ...
	 * @author ...
	 */
	public class Spawner {
		
		protected var warning:int;
		protected var target:Mino;
		public function Spawner(Warning:int, Target:Mino = null) {
			warning = Warning;
			target = Target;
		}
		
		public function spawnMeteoroid():Meteoroid {
			return null;
		}
	}

}