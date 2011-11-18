package Mining {
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.flixel.FlxSprite;
	import HUDs.MinedText;
	/**
	 * ...
	 * @author ...
	 */
	public class NebulaCloud extends Mino implements ResourceSource {
		
		private var resourceGrid:Array;
		public function NebulaCloud(X:int, Y:int, Blocks:Array, Center:Point ) {
			super(X, Y, Blocks, Center);
			falling = solid = false;
			generateGrid();
		}
		
		protected function generateGrid():void {
			resourceGrid = new Array(Mino.grid.length);
			var absCenter:Point = absoluteCenter;
			for each (var block:MineralBlock in blocks)
				if (!block.damaged) {
					var adjustedBlock:Point = block.add(absCenter);
					resourceGrid[adjustedBlock.x + adjustedBlock.y * bounds.width] = block;
				}
		}
		
		override public function addToGrid():void {	} //?
		
		override protected function drawBlocks():void {
			var Stamp:FlxSprite = new FlxSprite().createGraphic(C.BLOCK_SIZE, C.BLOCK_SIZE);
			
			for each (var block:MineralBlock in blocks) {
				if (block.damaged) continue;
				
				var X:int = (block.x - topLeft.x) * C.BLOCK_SIZE;
				var Y:int = (block.y - topLeft.y) * C.BLOCK_SIZE;
				
				Stamp.color = block.color;
				draw(Stamp, X, Y);
			}
			
			alpha = 2 / 3;
		}
		
		public function totalResources():int {
			var mineralsAvailable:int = 0;
			for each (var block:MineralBlock in blocks)
				if (block.type && !block.damaged)
					mineralsAvailable += block.value;
			return mineralsAvailable;
		}
		
		public function resourceAt(point:Point):MineralBlock {
			//var absCenter:Point = absoluteCenter;
			//for each (var mineralBlock:MineralBlock in blocks)
				//if (mineralBlock.add(absCenter).equals(point))
					//return mineralBlock;
			//return null;
			return resourceGrid[point.x + point.y * bounds.width];
		}
		
		public function mine(point:Point):void {
			var block:MineralBlock = resourceAt(point);
			if (block) {
				block.damaged = true;
				resourceGrid[point.x + point.y * bounds.width] = null;
				erase(point);
			}
		}
		
		//unused
		public function unmine(point:Point):void {
			var block:MineralBlock = resourceAt(point);
			if (block) {
				block.damaged = false;
				resourceGrid[point.x + point.y * bounds.width] = block;
				unerase(block);
			}
		}
		
		private var _unstamp:BitmapData;
		private var _unstamprect:Rectangle;
		private function erase(point:Point):void {
			var X:int = (point.x + center.x) * C.BLOCK_SIZE;
			var Y:int = (point.y + center.y) * C.BLOCK_SIZE;
			
			if (!_unstamp)
				_unstamp = new BitmapData(C.BLOCK_SIZE, C.BLOCK_SIZE, true, 0x0);
			if (!_unstamprect)
				_unstamprect = new Rectangle(0, 0, C.BLOCK_SIZE, C.BLOCK_SIZE);
				//_unstamprect = new Rectangle(X, Y, C.BLOCK_SIZE, C.BLOCK_SIZE);
			_framePixels.copyPixels(_unstamp, _unstamprect, new Point(X, Y));
			//_framePixels.fillRect(_unstamprect, 0x0);
		}
		
		private function unerase(block:MineralBlock):void {
			var X:int = (block.x + center.x) * C.BLOCK_SIZE;
			var Y:int = (block.y + center.y) * C.BLOCK_SIZE;
			
			if (!_unstamprect)
				_unstamprect = new Rectangle(X, Y, C.BLOCK_SIZE, C.BLOCK_SIZE);
			_framePixels.fillRect(_unstamprect, block.color);
			
		}
		
		
		override public function minimapColor(block:Block = null):uint {
			return (block as MineralBlock).color;
		}
		
	}

}