package Sminos {
	import flash.geom.Point;
	import Icons.FloatIcon;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class Factory extends Smino {
		
		protected var goodType:int;
		protected var productionPeriod:int;
		protected var batchSize:int;
		protected var flashColor:uint;
		
		protected var fractionalGoods:int;
		protected var flashTimer:Number = 0;
		public function Factory(X:int, Y:int, blocks:Array, center:Point,
								ProductionPeriod:int, BatchSize:int = 1,
								Sprite:Class = null, InopSprite:Class = null) {
			super(X, Y, blocks, center, 0xff1e5a2c, 0xff42a45a, Sprite, InopSprite);
			
			goodType = C.MINERALS;
			productionPeriod = ProductionPeriod;
			fractionalGoods = productionPeriod - 1;
			batchSize = BatchSize;
			flashColor = 0xff37ff67;
			
			affectedByBrownouts = true;
		}
		
		override public function executeDropCycle():void {
			if (operational && (fractionalGoods < timeRequired - 1 || inputAvailable))
				produce();
		}
		
		protected function get inputAvailable():Boolean {
			return station.mineralsMined > 0;
		}
		
		protected function get timeRequired():int {
			return productionPeriod * (brownout ? 2 : 1);
		}
		
		protected function produce():void {
			fractionalGoods += 1;
			if (fractionalGoods >= timeRequired) {
				finishBatch();
				boostNeighbors();
			}
		}
		
		protected function finishBatch():void {
			fractionalGoods = 0;
			station.refine(goodType, batchSize);
			C.iconLayer.add(new FloatIcon(gridLoc.x * C.BLOCK_SIZE + C.drawShift.x,
										  gridLoc.y * C.BLOCK_SIZE + C.drawShift.y,
										  goodType));
		}
		
		protected function boostNeighbors():void {
			var neighbors:Array = getNeighbors();
			for each (var neighbor:Smino in neighbors) {
				if (neighbor.name != name)
					continue;
				
				(neighbor as Factory).beBoosted();
			}
			
			flashTimer = FLASH_DURATION;
		}
		
		protected function beBoosted():void {
			if (operational) {
				fractionalGoods += 1;
				flashTimer = FLASH_DURATION;
			}
		}
		
		override public function render():void {
			if (operational && flashTimer > 0) {
				color = flashColor;
				flashTimer -= FlxG.elapsed;
				minoRender();
			} else
				super.render();
		}
		
		protected const FLASH_DURATION:Number = 0.25;
	}

}