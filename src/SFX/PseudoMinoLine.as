package SFX {
	import org.flixel.FlxSprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class PseudoMinoLine extends FlxSprite {
		
		protected var start:Point;
		protected var end:Point;
		protected var path:Vector.<Point>;
		public function PseudoMinoLine(Start:Point, End:Point) {
			super();
			createGraphic(C.BLOCK_SIZE, C.BLOCK_SIZE);
			
			start = Start;
			end = End;
			path = findPath(Start, End);
		}
		
		public function pointTo(end:Point, start:Point = null):void {
			if (!start)
				start = this.start;
			if (this.start.equals(start) && this.end.equals(end))
				return;
			
			path = findPath(start, end);
			
			this.start = start;
			this.end = end;
		}
		
		public function intersect():Mino {
			for each (var block:Point in path)
				if (canIntersect(Mino.getGrid(block.x, block.y)))
					return Mino.getGrid(block.x, block.y);
			return null;
		}
		
		public function canIntersect(other:Mino):Boolean {
			return other && other.exists &&
				   other.solid && !other.falling;
		}
		
		public function truncateToIntersection():Boolean {
			for (var i:int = 0; i < path.length; i++ ) {
				var block:Point = path[i];
				if (canIntersect(Mino.getGrid(block.x, block.y))) {
					path = path.slice(0, i);
					return false;
				}
			}
			return true;
		}
		
		override public function render():void {
			for each (var block:Point in path) {
				x = block.x * C.BLOCK_SIZE + C.B.drawShift.x;
				y = block.y * C.BLOCK_SIZE + C.B.drawShift.y;
				super.render();
			}
		}
		
		
		
		public static function findPath(Start:Point, End:Point):Vector.<Point> {
			var delta:Point = new Point(End.x - Start.x, End.y - Start.y);
			var direction:Point = delta.clone();
			direction.normalize(1);
			
			var stepper:Point = Start.clone();
			var path:Vector.<Point> = new Vector.<Point>(Math.ceil(delta.length));
			for (var i:int = 0; i < path.length; i++) {
				var block:Point = new Point(Math.floor(stepper.x),
											Math.floor(stepper.y));
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