package  {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class MinoLine extends Mino {
		
		protected var start:Point;
		protected var end:Point;
		public function MinoLine(Start:Point, End:Point) {
			var min:Point = findMin(Start, End);
			var blocks:Array = findPath(Start, End);
			//start = Start;
			//end = End;
			
			super(min.x, min.y, blocks, new Point(0, 0), C.DEBUG_COLOR);
		}
		
		public function pointTo(end:Point, start:Point = null):void {
			if (!start)
				start = this.start;
			//if (this.start.equals(start) && this.end.equals(end))
				//return;
			
			gridLoc = findMin(start, end);
			blocks = findPath(start, end);
			generateSprite(true);
			
			this.start = start;
			this.end = end;
		}
		
		//public function truncateToIntersection():Boolean {
			//var fullPath:Array = blocks.slice();
			//for (var i:int = 0; i < blocks.length; i++) {
				//blocks = fullPath.slice(0, i + 1);
				//if (intersects())
				//
			//}
		//}
		
		
		
		public static function findPath(Start:Point, End:Point):Array {
			var min:Point = findMin(Start, End);
			
			var delta:Point = new Point(End.x - Start.x, End.y - Start.y);
			var direction:Point = delta.clone();
			direction.normalize(1);
			
			var stepper:Point = Start.clone();
			var path:Array = new Array(Math.ceil(delta.length));
			for (var i:int = 0; i < path.length; i++) {
				var block:Block = new Block(Math.round(stepper.x) - min.x,
											Math.round(stepper.y) - min.y);
				path[i] = block;
				stepper.offset(direction.x, direction.y);
			}
			
			return path;
		}
		
		public static function wuAlgorithm(Start:Point, End:Point):Array {
			var path:Array = [];
			
			
			//dx = x2 - x1
			//dy = y2 - y1
			var delta:Point = new Point(End.x - Start.x, End.y - Start.y);
			
			//Note: If at the beginning of the routine abs(dx) < abs(dy) is true, then all plotting should be done with x and y reversed.
			var xGreater:Boolean = Math.abs(delta.x) > Math.abs(delta.y); 
			if (xGreater) {               
				//swap x1, y1
				Start = new Point(Start.y, Start.x);
				//swap x2, y2
				End = new Point(End.y, End.x);
				//swap dx, dy
				delta = new Point(delta.y, delta.x);
			}
			
			//if x2 < x1
			if (End.x < Start.x) {
				//swap x1, x2
				//swap y1, y2
				var temp:Point = Start;
				Start = End;
				End = temp;
			}
			
			//gradient = dy / dx
			var gradient:Number = delta.y / delta.x;
			
			// handle first endpoint
			//xend = round(x1)
			var xend:int = Math.round(Start.x); //should be integral anyway...?
			//yend = y1 + gradient * (xend - x1)
			var yend:int = Start.y + gradient * (xend - Start.x);
			//xgap = rfpart(x1 + 0.5)
			var xgap:int = rfpart(Start.x + 0.5);
			//xpxl1 = xend  // this will be used in the main loop
			var xpxl1:int = xend;
			//ypxl1 = ipart(yend)
			var ypxl1:int = int(yend);
			plot(xpxl1, ypxl1, rfpart(yend) * xgap, path);
			plot(xpxl1, ypxl1 + 1, fpart(yend) * xgap, path);
			var intery:int = yend + gradient; // first y-intersection for the main loop
			
			// handle second endpoint
			xend = Math.round (End.x);
			yend = End.y + gradient * (xend - End.x);
			xgap = fpart(End.x + 0.5)
			var xpxl2:int = xend  // this will be used in the main loop
			var ypxl1:int = int(yend)
			plot (xpxl2, ypxl2, rfpart (yend) * xgap, path)
			plot (xpxl2, ypxl2 + 1, fpart (yend) * xgap, path)
			
			// main loop
			//for x from xpxl1 + 1 to xpxl2 - 1 do
			for (var x:int = xpxl1 + 1; x < xpxl2; x++) {
				plot (x, int(intery), rfpart (intery), path)
				plot (x, int(intery) + 1, fpart (intery), path)
				intery = intery + gradient
			}
			
			return path;
		}
		
		private static function plot(x:int, y:int, b:Number, path:Array):void {
			if (b != 0)
				path.push(new Point(x, y));
		}
		
		private static function fpart(x:Number):Number {
			return x - Math.floor(x);
		}
		
		private static function rfpart(x:Number):Number {
			return 1 - fpart(x);
		}
		
		public static function findMin(A:Point, B:Point):Point {
			return new Point((A.x < B.x) ? A.x : B.x, (B.y < A.y) ? B.y : A.y);
		}
	}

}