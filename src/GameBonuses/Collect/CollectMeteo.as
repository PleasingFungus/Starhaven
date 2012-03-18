package GameBonuses.Collect {
	import Meteoroids.Meteoroid;
	import flash.geom.Point;
	import Mining.BaseAsteroid;
	import Mining.MineralBlock;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class CollectMeteo extends Meteoroid {
		
		public function CollectMeteo(X:int, Y:int, Target:Point = null, speedFactor:Number = 1, HasBeard:Boolean = false) {
			super(X, Y, Target, speedFactor, HasBeard);
			
			var mission:MeteoMission = new MeteoMission(NaN, 0.4);
			
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
		
		override protected function checkIntersect():void {
			if (intersects())
				for each (var mino:Mino in Mino.all_minos)
					if (intersect(mino)) {
						if (mino is BaseAsteroid)
							anchorTo(mino);
						else
							mino.takeExplodeDamage( -1, -1, this);
					}
		}
		
		override protected function anchorTo(hit:Mino):void {
			semigridLoc.x -= direction.x;
			semigridLoc.y -= direction.y;
			gridLoc.x = Math.floor(semigridLoc.x);
			gridLoc.y = Math.floor(semigridLoc.y);
			
			var asteroid:BaseAsteroid = hit as BaseAsteroid;
			
			var absCen:Point = absoluteCenter;
			var delta:Point = absCen.subtract(asteroid.absoluteCenter);
			for each (var block:Block in blocks) {
				if (!C.B.OUTER_BOUNDS.containsPoint(block.add(absCen)))
					continue;
				
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
			for each (var mino:Mino in Mino.all_minos)
				if (mino.exists && !mino.dangerous)
					mino.addToGrid();
			
			FlxG.quake.start(0.045, 0.25);
			C.sound.play(C.randomChoice(THUD_ROCKS), 1);
			
			exists = false;
			solid = false;
			dead = true;
		}
		
		[Embed(source = "../../../lib/sound/game/thud_rock_1.mp3")] protected const _THUD_ROCK_1:Class;
		[Embed(source = "../../../lib/sound/game/thud_rock_2.mp3")] protected const _THUD_ROCK_2:Class;
		[Embed(source = "../../../lib/sound/game/thud_rock_3.mp3")] protected const _THUD_ROCK_3:Class;
		protected const THUD_ROCKS:Array = [_THUD_ROCK_1, _THUD_ROCK_2, _THUD_ROCK_3];
	}

}