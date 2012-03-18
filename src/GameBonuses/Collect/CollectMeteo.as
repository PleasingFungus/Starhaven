package GameBonuses.Collect {
	import Meteoroids.Meteoroid;
	import flash.geom.Point;
	import Mining.BaseAsteroid;
	import Mining.MineralBlock;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class CollectMeteo extends Meteoroid {
		
		public function CollectMeteo(X:int, Y:int, Target:Point = null, speedFactor:Number = 1, HasBeard:Boolean = false) {
			super(X, Y, Target, speedFactor, HasBeard);
			
			var mission:MeteoMission = new MeteoMission(NaN, 0.45);
			
			blocks = mission.rawMap.map;
			center = mission.rawMap.center;
			sprite = null;
			
			resetSprites();
			generateSprite();
		}
		
		//TODO: slowly tumble?
		
		
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
		
		override protected function explode(radius:int):void {
			semigridLoc.x -= direction.x;
			semigridLoc.y -= direction.y;
			gridLoc.x = Math.floor(semigridLoc.x);
			gridLoc.y = Math.floor(semigridLoc.y);
			
			var asteroid:BaseAsteroid, mino:Mino;
			for each (mino in Mino.all_minos)
				if (mino is BaseAsteroid) {
					asteroid = mino as BaseAsteroid;
					break;
				}
			
			var delta:Point = absoluteCenter.subtract(asteroid.absoluteCenter);
			for each (var block:Block in blocks) {
				block.x += delta.x;
				block.y += delta.y;
				
				for each (var otherBlock:Block in asteroid.blocks)
					if (otherBlock.equals(block)) {
						otherBlock.damaged = true;
						break;
					}
				
				asteroid.blocks.push(block);
			}
			
			asteroid.forceSpriteReset();
			Mino.resetGrid();
			for each (mino in Mino.all_minos)
				if (mino.exists && !mino.dangerous)
					mino.addToGrid();
			
			exists = false;
			solid = false;
			dead = true;
		}
	}

}