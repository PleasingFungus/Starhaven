package Mining {
	import flash.geom.Point;
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author ...
	 */
	public class BaseAsteroid extends Mino implements ResourceSource {
		
		public function BaseAsteroid(X:int, Y:int, Blocks:Array, Center:Point ) {
			super(X, Y, Blocks, Center);
		}
		
		override protected function beDamaged():void {
			resetSprites();
			generateSprite(); //may be excessive, but that's okay
			
			newlyDamaged = false;
		}
		
		override public function takeExplodeDamage(X:int, Y:int, Source:Mino):void {
			if (!exists || falling)
				return;
			
			var adjustedX:int = X - gridLoc.x + center.x;
			var adjustedY:int = Y - gridLoc.y + center.y;
			for each (var block:MineralBlock in blocks)
				if (block.x == adjustedX && block.y == adjustedY && !block.damaged && block.type != MineralBlock.BEDROCK) {
					damaged = newlyDamaged = true;
					block.damaged = true;
					Mino.setGrid(X, Y, null);
				}
			
			damagedBy = Source;
		}
		
		override protected function drawBlocks():void {
			var Stamp:FlxSprite = new FlxSprite().createGraphic(C.BLOCK_SIZE, C.BLOCK_SIZE);
			
			for each (var block:MineralBlock in blocks) {
				if (block.damaged) continue;
				var X:int = (block.x - topLeft.x) * C.BLOCK_SIZE;
				var Y:int = (block.y - topLeft.y) * C.BLOCK_SIZE;
				
				Stamp.color = block.color;
				draw(Stamp, X, Y);
			}
		}
		
		public function totalResources():int {
			var mineralsAvailable:int = 0;
			for each (var block:MineralBlock in blocks)
				if (block.type && !block.damaged)
					mineralsAvailable += block.value;
			return mineralsAvailable;
		}
		
		public function resourceAt(point:Point):MineralBlock {
			var absCenter:Point = absoluteCenter;
			for each (var mineralBlock:MineralBlock in blocks)
				if (mineralBlock.add(absCenter).equals(point))
					return mineralBlock;
			return null;
		}
		
		public function mine(point:Point):void {
			var block:MineralBlock = resourceAt(point);
			if (block) {
				block.damaged = true;
				newlyDamaged = true;
				Mino.setGrid(block.x + absoluteCenter.x, block.y + absoluteCenter.y , null);
			}
		}
		
		public function unmine(point:Point):void {
			var block:MineralBlock = resourceAt(point);
			if (block) {
				block.damaged = false;
				newlyDamaged = true; //so the sprites will reset
				Mino.setGrid(block.x + absoluteCenter.x, block.y + absoluteCenter.y , this);
			}
		}
			
			
			
		
		override public function minimapColor(block:Block = null):uint {
			return (block as MineralBlock).color;
		}
	}

}