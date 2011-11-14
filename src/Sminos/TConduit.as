package Sminos {
	import flash.geom.Point;
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class TConduit extends Conduit {
		
		public function TConduit(X:int, Y:int) {
			var blocks:Array = [new Block(0, 0), new Block(1, 0), new Block(2, 0),
													new Block(1, 1),
													new Block(1, 2)];
			super(X, Y, blocks, new Point(1, 0));
			name = "T-Conduit";
		}
		
	}

}