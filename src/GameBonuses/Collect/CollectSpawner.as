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
		private var totalSpawns:int;
		private var spawnAngles:Array;
		public function CollectSpawner(Warning:Number, Target:Point, SpeedFactor:Number) {
			super(Warning, Target, SpeedFactor);
			stationFacing = FlxSprite.DOWN;
		}
		
		override public function spawnMeteoroid():Meteoroid {
			if (!spawnNo) {
				var spawnRange:Number = 3 / 3;
				var spawnOffset:Number = (2 - spawnRange) / 2;
				var startingPoint:Number = 0.5 * stationFacing + spawnOffset;
				
				spawnAngles = [];
				for (var i:int = 0; i < totalSpawns; i++) {
					var spawnStart:Number = startingPoint + i * spawnRange / totalSpawns;
					var randomFraction:Number = FlxU.random() * spawnRange / totalSpawns;
					var spawnAngle:Number = (spawnStart + randomFraction) * Math.PI;
					spawnAngles.splice(Math.floor(FlxU.random() * (spawnAngles.length + 1)) - 1, 0, spawnAngle);
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
	
		public function setWave(TotalSpawns:int):void {
			totalSpawns = TotalSpawns;
			spawnNo = 0;
		}
	}
}