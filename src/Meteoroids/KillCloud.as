package Meteoroids {
	import flash.display.BitmapData;
	import flash.geom.Point;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class KillCloud extends Mino {
		
		protected var expanding:Boolean = true;
		protected var radius:int = 1;
		public function KillCloud(X:int, Y:int) {
			center = new Point();
			generateCloud();
			super(X, Y, blocks, center, 0xbee93a0f);
			
			falling = false;
		}
		
		protected function generateCloud():void {
			blocks = [];
			for (var x:int = -radius; x <= radius; x++)
				for (var y:int = -radius; y <= radius; y++)
					if (Math.abs(x) + Math.abs(y) <= radius)
						blocks.push(new Block(x, y));
		}
		
		override protected function executeCycle():void {
			super.executeCycle();
			checkExpansion();
			checkKills();
		}
		
		protected var expansionTimer:int;
		protected const EXPANSION_TIME:int = 1;
		protected function checkExpansion():void {
			expansionTimer++;
			if (expansionTimer >= EXPANSION_TIME) {
				if (expanding)
					radius++;
				else
					radius--;
				
				if (radius == 0)
					exists = false;
				else {
					if (radius == MAX_RADIUS)
						expanding = false;
					updateSprite();
				}
				
				expansionTimer = 0;
			}
		}
		
		protected function updateSprite():void {
			generateCloud();
			generateSprite(true);
		}
		
		override protected function createSprite():void {
			var backColor:uint = (C.DEBUG && C.DISPLAY_DRAW_AREA) ? C.DEBUG_COLOR : 0x0;
			var cacheName:String = "Killcloud-" + radius;
			
			var alreadyMade:Boolean = FlxG.checkBitmapCache(cacheName);
			createGraphic(C.BLOCK_SIZE * blockDim.x, C.BLOCK_SIZE * blockDim.y, backColor, false, cacheName);
			if (!alreadyMade)
				drawBlocks();
		}
		
		protected function checkKills():void {
			for each (var mino:Mino in Mino.all_minos)
				if (mino.exists && mino.active && !mino.dead && mino.dangerous
					&& mino.overlaps(this)) {//mino.intersect(this)) {
					mino.takeExplodeDamage(mino.gridLoc.x, mino.gridLoc.y, this);
					break;
				}
		}
		
		
		private const MAX_RADIUS:int = 3;
	}

}