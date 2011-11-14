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
				var block:Block = new Block(Math.floor(stepper.x) - min.x,
											Math.floor(stepper.y) - min.y);
				path[i] = block;
				stepper.offset(direction.x, direction.y);
			}
			
			return path;
		}
		
		public static function findMin(A:Point, B:Point):Point {
			return new Point((A.x < B.x) ? A.x : B.x, (B.y < A.y) ? B.y : A.y);
		}
	}

}