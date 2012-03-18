package GameBonuses.Collect {
	import Meteoroids.Spawner;
	import Meteoroids.Meteoroid;
	import org.flixel.FlxU;
	import org.flixel.FlxSprite;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class CollectSpawner extends Spawner {
		
		public var stationFacing:int;
		private var spawnNo:int;
		private var spawnAngles:Array;
		public function CollectSpawner(Warning:int, Target:Point, SpeedFactor:Number) {
			super(Warning, Target, SpeedFactor);
			stationFacing = FlxSprite.DOWN;
		}
		
		override public function spawnMeteoroid():Meteoroid {
			if (!spawnNo) {
				var initialAngle:Number = (FlxU.random() * 1 / 3 + 1 / 6 + 0.5 * stationFacing) * Math.PI;
				spawnAngles = [];
				for (var i:int = 0; i < 3; i++) {
					var newAngle:Number = initialAngle + (i * 0.5 + 1 / 3 * FlxU.random()) * Math.PI;
					spawnAngles.splice(Math.floor(FlxU.random() * (spawnAngles.length + 1)) - 1, 0, newAngle);
				}
			}
				
			
			var furthest:int = C.B.getFurthest();
			var travelDist:Number = warning * speedFactor / (C.CYCLE_TIME * Meteoroid.period);
			
			var radius:int = furthest + travelDist;
			var angle:Number = spawnAngles[spawnNo];
			var X:int = Math.cos(angle) * radius
			var Y:int = Math.sin(angle) * radius
			
			spawnNo++;
			
			return new CollectMeteo(X, Y, target, speedFactor);
		}
	}

}