package Meteoroids {
	import flash.geom.Point;
	import org.flixel.FlxU;
	import org.flixel.FlxGroup;
	/**
	 * ...
	 * @author ...
	 */
	public class PlanetSpawner extends Spawner {
		
		protected var malevolent:Boolean;
		protected var allowedWidth:Number;
		public function PlanetSpawner(Warning:int, Target:Mino) {
			super( Warning, Target);
			malevolent = false;
			allowedWidth = 0.1;
		}
		
		override public function spawnMeteoroid(asteroids:FlxGroup):void {
			var Y:int = C.B.OUTER_BOUNDS.top - 10;
			
			var X:int, targetCenter:Point;
			if (malevolent) {
				X = C.B.OUTER_BOUNDS.left + FlxU.random() * C.B.OUTER_BOUNDS.width;
				targetCenter = target.absoluteCenter;
			} else {
				var rand:Number = FlxU.random();
				rand = (rand - 0.5) * allowedWidth;
				X = C.B.OUTER_BOUNDS.left + (0.5 + rand) * C.B.OUTER_BOUNDS.width; //focus on center
				targetCenter = new Point(Math.min(C.B.OUTER_BOUNDS.right, Math.max(C.B.OUTER_BOUNDS.left, X + (FlxU.random() - 0.5) * 2 * 10)),
										 C.B.OUTER_BOUNDS.bottom);
				allowedWidth += (1 - allowedWidth) * WIDTH_GROW_RATE; 
			}
			
			asteroids.add(new Meteoroid(X, Y, targetCenter));
		}
		
		protected const WIDTH_GROW_RATE:Number = 1/8;
	}

}