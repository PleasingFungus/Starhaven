package Globals {
	import org.flixel.FlxObject;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class GlobalCycleTimer extends FlxObject {
		
		public static var cycle:int;
		protected var timer:Number;
		public function GlobalCycleTimer() {
			super();
			cycle = 0;
			timer = 0;
			
			minosDropped = 0;
			lastDroppedCount = 0;
		}
		
		override public function update():void {
			super.update();
			
			timer += FlxG.elapsed;
			if (timer >= C.CYCLE_TIME) {
				timer -= C.CYCLE_TIME;
				cycle++;
			}
			
			justDropped = lastDroppedCount != minosDropped;
			if (justDropped)
				lastDroppedCount = minosDropped;
		}
		
		public static function outOfTime():Boolean {
			return miningTime && minosDropped > miningTime;
		}
		
		public static var minosDropped:int;
		private var lastDroppedCount:int;
		public static var notionalMiningTime:int;
		public static var miningTime:int;
		public static var justDropped:Boolean;
	}

}