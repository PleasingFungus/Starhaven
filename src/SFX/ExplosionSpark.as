package SFX {
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class ExplosionSpark extends FlxSprite {
		
		protected var cycleTimer:Number = 0;
		public function ExplosionSpark(X:int, Y:int) {
			super(X * C.BLOCK_SIZE, Y * C.BLOCK_SIZE);
			createGraphic(C.BLOCK_SIZE, C.BLOCK_SIZE, 0xbee93a0f);
		}
		
		override public function update():void {
			cycleTimer += FlxG.elapsed;
			if (cycleTimer >= C.CYCLE_TIME / 2) {
				alpha -= .25;
				if (alpha == 0)
					exists = false;
				cycleTimer -= C.CYCLE_TIME / 2;
			}
		}
		
		override public function getScreenXY(point:FlxPoint=null):FlxPoint {
			point = super.getScreenXY(point);
			point.x += C.B.drawShift.x;
			point.y += C.B.drawShift.y;
			return point;
		}
		
	}

}