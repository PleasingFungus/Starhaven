package SFX {
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class Pyrotechnic extends FlxSprite {
		
		protected var cycleTimer:Number = 0;
		public function Pyrotechnic(X:int, Y:int, Direction:int, Color:uint = 0xbee93a0f) {
			super(X * C.BLOCK_SIZE, Y * C.BLOCK_SIZE);
			createGraphic(C.BLOCK_SIZE, C.BLOCK_SIZE, Color);
			facing = Direction;
		}
		
		override public function update():void {
			cycleTimer += FlxG.elapsed;
			if (cycleTimer >= C.CYCLE_TIME / 2) {
				alpha -= .25;
				if (alpha == 0)
					exists = false;
				else
					switch (facing) {
						case LEFT: x -= C.BLOCK_SIZE; break;
						case UP: y -= C.BLOCK_SIZE; break;
						case RIGHT: x += C.BLOCK_SIZE; break;
						case DOWN: y += C.BLOCK_SIZE; break;
					}
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