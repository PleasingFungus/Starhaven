package SFX {
	import flash.geom.Point;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class RocketGunTracer extends PseudoMinoLine {
		
		protected var parent:Mino;
		public function RocketGunTracer(Parent:Mino) {
			super(new Point, new Point);
			parent = Parent;
			color = 0xfff91b1b; //5bc7ff
			alpha = 0.5;
		}
		
		override public function canIntersect(other:Mino):Boolean {
			return super.canIntersect(other) && other != parent;
		}
	}

}