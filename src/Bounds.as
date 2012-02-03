package  {
	import org.flixel.FlxG;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author ...
	 */
	public class Bounds {
		public var maxDim:Point;
		private var _lastDim:Point;
		private var _last_outer_bound:Rectangle;
		
		public function get HALFWIDTH():int { return FlxG.width / (C.BLOCK_SIZE * 2); }
		public function get HALFHEIGHT():int { return FlxG.height / (C.BLOCK_SIZE * 2); }
		
		public var BASE_AREA:Rectangle;
		public var PlayArea:Rectangle;
		public var screenArea:Rectangle;
		public var scale:Number;
		public var drawShift:Point;
		public var buffer:int;
		
		public function Bounds() {
			var w:int = FlxG.width / C.BLOCK_SIZE;
			var h:int = FlxG.height / C.BLOCK_SIZE;
			BASE_AREA = new Rectangle(-w/2, -h/2, w, h);
			PlayArea = BASE_AREA.clone();
			screenArea = new Rectangle(0, 0, FlxG.width, FlxG.height);
			scale = 1;
			drawShift  = new Point;
		}
		
		public function getFurthest():int {
			var bounds:Rectangle = PlayArea;
			var max:int = - bounds.left;
			if (max < - bounds.top)
				max = - bounds.top
			if (max < bounds.right)
				max = bounds.right;
			if (max < bounds.bottom)
				max = bounds.bottom;
			return max;
		}
		
		public function centerDrawShiftOn(gridLoc:Point, downShift:Boolean = false):void {			
			drawShift.x = FlxG.width / (2 * scale) - gridLoc.x * C.BLOCK_SIZE;
			drawShift.y = FlxG.height / ((downShift ? 4 : 2) * scale) - gridLoc.y * C.BLOCK_SIZE;
			
			var maxYShift:int = OUTER_BOUNDS.bottom * C.BLOCK_SIZE - FlxG.height / scale;
			if (drawShift.y < -maxYShift)
				drawShift.y = -maxYShift;
			
			var maxXShift:int = (OUTER_BOUNDS.right + buffer) * C.BLOCK_SIZE - FlxG.width / scale;
			if (drawShift.x < -maxXShift)
				drawShift.x = -maxXShift;
			var minXShift:int = (OUTER_BOUNDS.left - buffer) * C.BLOCK_SIZE
			if (drawShift.x > -minXShift)
				drawShift.x = -minXShift;
		}
		
		public function get OUTER_BOUNDS():Rectangle {
			if (_lastDim && _lastDim.equals(maxDim))
				return _last_outer_bound;
				
			_last_outer_bound = new Rectangle(-maxDim.x / 2, -maxDim.y / 2, maxDim.x, maxDim.y);
			_lastDim = maxDim.clone();
			return _last_outer_bound
		}
		
		public function screenToBlocks(X:int, Y:int):Point {
			X /= scale;
			Y /= scale;
			X -= C.B.drawShift.x;
			Y -= C.B.drawShift.y;
			X /= C.BLOCK_SIZE;
			Y /= C.BLOCK_SIZE;
			return new Point(X, Y);
		}
		
		public function blocksToScreen(X:int, Y:int):Point {
			X *= C.BLOCK_SIZE;
			Y *= C.BLOCK_SIZE;
			X += C.B.drawShift.x;
			Y += C.B.drawShift.y;
			X *= scale;
			Y *= scale;
			return new Point(X, Y);
		}
		
	}

}