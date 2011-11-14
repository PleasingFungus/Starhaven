package  {
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class Block extends Point {
		
		public var damaged:Boolean;
		public function Block(X:int=0, Y:int=0,Damaged:Boolean = false) {
			super(X, Y);
			damaged = Damaged;
		}
		
		public function outsideOuterBounds(X:int, Y:int):Boolean {
			X += x;
			Y += y;
			var outside:Boolean = !C.B.OUTER_BOUNDS.containsPoint(new Point(X, Y));
			return outside;	
		}
		
	}

}