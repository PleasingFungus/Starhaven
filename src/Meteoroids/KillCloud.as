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
			
			cycleSpeed *= 3;
			falling = false;
			C.sound.play(EXPLODE_NOISE, 1);
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
			//checkKills();
		}
		
		override public function update():void {
			super.update();
			checkKills();
		}
		
		protected var expansionTimer:int;
		protected const EXPANSION_TIME:int = 3;
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
					&& mino.intersect(this)) {
					explodeAt(mino);
					break;
				}
		}
		
		protected function explodeAt(target:Mino):void {
			var absCen:Point = absoluteCenter;
			for each (var block:Point in blocks)
				target.takeExplodeDamage(block.x + absCen.x, block.y + absCen.y, this);
		}
		
		
		private const MAX_RADIUS:int = 2;
		[Embed(source = "../../lib/sound/game/explosion_rocket.mp3")] protected const EXPLODE_NOISE:Class;
	}

}