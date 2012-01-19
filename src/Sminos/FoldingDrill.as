package Sminos {
	import flash.geom.Point;
	import Mining.MineralBlock;
	import Mining.ResourceSource;
	import org.flixel.FlxSprite;
	import HUDs.MinedText;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class FoldingDrill extends Drill {
		
		protected var length:int = 1;
		protected var maxLength:int = 8;
		protected var drillDir:Point;
		protected var head:int;
		public function FoldingDrill(X:int, Y:int) {
			var blocks:Array = [new Block(0, 0), new Block(1, 0), new Block(2, 0)];
			head = blocks.length;
			super(X, Y, blocks, new Point(1, 0), _headsprite, _headsprite_in);
			
			name = "Folding Drill";
		}
		
		override protected function anchorTo(Parent:Aggregate):void {
			super.anchorTo(Parent);
			var forward:Point = forwardDir();
			if (station.resourceSource.resourceAt(gridLoc/*.add(center)*/.add(forward)))
				drillDir = forward;
			else if (station.resourceSource.resourceAt(gridLoc/*.add(center)*/.subtract(forward)))
				drillDir = new Point( -forward.x, -forward.y);
			else
				finishDrill();
		}
		
		override protected function drillOne(visual:Boolean = true):Boolean {
			drillDir.normalize(length);
			var bit:Point = gridLoc.add(drillDir)/*.add(center)*/;
			var block:MineralBlock = station.resourceSource.resourceAt(bit);
			if (!(block && !block.damaged &&
				   block.type != MineralBlock.BEDROCK &&
				   length < maxLength))
				return false;
			
			if (block.type > 0)
				storedMinerals += block.value;
			station.resourceSource.mine(bit);
			
			//minePoint(new Point(bit.x - forward.y, bit.y + forward.x));
			//minePoint(new Point(bit.x + forward.y, bit.y - forward.x));
			
			blocks.push(new Block(bit.x - gridLoc.x + center.x, bit.y - gridLoc.y + center.y));
			length++;
			
			if (visual)
				generateDrill();
			
			return true;
		}
		
		override protected function finishDrill():void {
			super.finishDrill();
			generateDrill();
		}
		
		protected function generateDrill():void {
			sprite = inopSprite = null;
			resetSprites();
			generateSprite();
		}
		
		protected var wasOperational:Boolean;
		override public function simpleRender():void {
			if (sprite)
				super.simpleRender();
			else {
				if (wasOperational != operational) {
					resetSprites();
					generateSprite();
				}
				minoRender();
			}
		}
		
		override protected function drawBlocks():void {
			var X:int = (Math.min(blocks[0].x, blocks[head - 1].x) - topLeft.x) * C.BLOCK_SIZE;
			var Y:int = (Math.min(blocks[0].y, blocks[head - 1].y) - topLeft.y) * C.BLOCK_SIZE;
			var headSprite:FlxSprite = new FlxSprite().loadGraphic(operational ? _headsprite : _headsprite_in);
			if (facing == LEFT || facing == RIGHT) {
				headSprite.angle = 90; //cheating a bit here; the sprite is the same rotated 180 degrees
				X -= C.BLOCK_SIZE; //confession: no idea why this is needed
				Y += C.BLOCK_SIZE;
			}
			draw(headSprite, X, Y);
			
			var block:Block;
			
			var shaftStamp:FlxSprite = new FlxSprite().loadGraphic(operational ? _shaftsprite : _shaftsprite_in);
			if (facing == LEFT || facing == RIGHT)
				shaftStamp.angle = 90; //cheating a bit here; the sprite is the same rotated 180 degrees
			
			for (var i:int = head; i < blocks.length - 1; i++) {
				block = blocks[i];
				X = (block.x - topLeft.x) * C.BLOCK_SIZE;
				Y = (block.y - topLeft.y) * C.BLOCK_SIZE;
				draw(shaftStamp, X, Y);
			}
			
			
			block = blocks[blocks.length -1];
			X = (block.x - topLeft.x) * C.BLOCK_SIZE;
			Y = (block.y - topLeft.y) * C.BLOCK_SIZE;
			
			var bitStamp:FlxSprite = new FlxSprite().loadGraphic(operational ? _bitsprite : _bitsprite_in);
			if (block.x < center.x)
				bitStamp.angle = 90;
			else if (block.x > center.x)
				bitStamp.angle = -90;
			else if (block.y < center.y)
				bitStamp.angle = 180;
			
			draw(bitStamp, X, Y);
			
			wasOperational = operational; //?
		}
		
		[Embed(source = "../../lib/art/sminos/drillhead.png")] private static const _headsprite:Class;
		[Embed(source = "../../lib/art/sminos/drillhead_in.png")] private static const _headsprite_in:Class;
		[Embed(source = "../../lib/art/sminos/drillshaft.png")] private static const _shaftsprite:Class;
		[Embed(source = "../../lib/art/sminos/drillshaft_in.png")] private static const _shaftsprite_in:Class;
		[Embed(source = "../../lib/art/sminos/drillbit.png")] private static const _bitsprite:Class;
		[Embed(source = "../../lib/art/sminos/drillbit_in.png")] private static const _bitsprite_in:Class;
	}

}