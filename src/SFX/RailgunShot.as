package SFX {
	import flash.geom.Point;
	import Sminos.AsteroidGun;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class RailgunShot extends MinoLine {
		
		protected var gun:AsteroidGun;
		public function RailgunShot(Start:Point, End:Point, Gun:AsteroidGun ) {
			super(Start, End);
			gun = Gun;
			color = 0xfff91b1b; //5bc7ff
		}
		
		override public function canIntersect(mino:Mino):Boolean {
			return super.canIntersect(mino) && mino != gun && !mino.dangerous;
		}
		
		
		public function truncateToIntersection():Boolean {
			var loc:Point = new Point();
			var oLoc:Point = new Point();
			
			//var useGrid:Boolean = Mino.grid && Mino.getGrid(blocks[0].x + gridLoc.x,
			//												blocks[0].y + gridLoc.y).name == gun.name; //!shielded
			//var useGrid:Boolean = false;
			var useGrid:Boolean = true;
			
			var intersection:int = -1;
			for (var i:int = 0; i < blocks.length && intersection == -1; i++) {
				var block:Block = blocks[i];
				loc.x = block.x + gridLoc.x - center.x;
				loc.y = block.y + gridLoc.y - center.y;
				
				if (useGrid) {
					if (canIntersect(Mino.getGrid(loc.x, loc.y)))
						intersection = i;
				} else
					for each (var mino:Mino in all_minos) {
						if (mino == this || mino == gun || mino == gun.target ||
							!mino.exists || !mino.solid)
							continue;
						
						var mBounds:Rectangle = mino.bounds;
						if (!mBounds.containsPoint(loc))
							continue;
						
						if (mino.intersectsPoint(loc)) {
							intersection = i;
							break;
						}
					}
			}
			
			if (intersection == -1)
				return false;
			
			blocks = blocks.slice(0, i+1);
			generateSprite(true);
			return true;
		}
		
		public function findIntersect(target:Mino):Point {
			var globalPoint:Point = new Point();
			for (var i:int = blocks.length - 1; i >= 0; i--) {
				globalPoint.x = blocks[i].x + gridLoc.x - center.x;
				globalPoint.y = blocks[i].y + gridLoc.y - center.y;
				if (!target.intersectsPoint(globalPoint))
					break;
			}
			
			var interceptIndex:int = i == blocks.length - 1 ? i : i + 1;
			
			globalPoint.x = blocks[interceptIndex].x + gridLoc.x - center.x;
			globalPoint.y = blocks[interceptIndex].y + gridLoc.y - center.y;
			return globalPoint;
		}
	}

}