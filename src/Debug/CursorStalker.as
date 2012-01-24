package  {
	import flash.geom.Point;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class CursorStalker extends Mino {
		
		public function CursorStalker() {
			var blocks:Array = [];
			for (var x:int = 0; x < 3; x++)
				for (var y:int = 0; y < 3; y++)
					blocks.push(new Block(x, y));
			super( -1, -1, blocks, new Point(1, 1), C.DEBUG_COLOR);
		}
		
		override public function update():void {
			gridLoc = C.B.screenToBlocks(FlxG.mouse.x, FlxG.mouse.y).subtract(center);
		}
	}

}