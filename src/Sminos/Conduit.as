package Sminos {
	import flash.geom.Point;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class Conduit extends Smino {
		
		protected var rippleblock:int;
		public function Conduit(X:int, Y:int, Blocks:Array, Center:Point,
								Sprite:Class = null, InopSprite:Class = null) {
			super(X, Y, Blocks, Center, 0xffa0a0a0, 0xfff8fb89, Sprite, InopSprite);
			transmitsPower = true;
			waterproofed = true;
			
			cladeName = "Conduit";
			description = "Conduits transmit power from the station core, powering other pieces.";
			audioDescription = _desc;
		}
		
		override protected function executeCycle():void {
			super.executeCycle();
			if (operational) {
				var blockDelta:int = rippleUp ? blocks.length - 1 : 1;
				rippleblock = (rippleblock + blockDelta) % blocks.length;
				cycleSpeed = 2;
			}
		}
		
		protected function get rippleUp():Boolean {
			switch (facing) {
				case LEFT: return gridLoc.x > parent.core.gridLoc.x;
				case DOWN: return gridLoc.y < parent.core.gridLoc.y;
				case RIGHT: return gridLoc.x < parent.core.gridLoc.x;
				case UP: return gridLoc.y > parent.core.gridLoc.y;
			}
			return false;
		}
		
		override public function render():void {
			super.render();
			if (operational)
				renderRipple();
		}
		
		protected var glowsprite:FlxSprite;
		protected function renderRipple():void {
			var block:Point = blocks[rippleblock].add(absoluteCenter);
			if (!glowsprite) {
				glowsprite = new FlxSprite().createGraphic(C.BLOCK_SIZE, C.BLOCK_SIZE);
				//glowsprite.blend = "add";
				glowsprite.alpha = 0.5;
			}
			glowsprite.x = block.x * C.BLOCK_SIZE + C.B.drawShift.x;
			glowsprite.y = block.y * C.BLOCK_SIZE + C.B.drawShift.y;
			glowsprite.render();
		}
		
		[Embed(source = "../../lib/sound/vo/conduits.mp3")] public static const _desc:Class;
	}

}