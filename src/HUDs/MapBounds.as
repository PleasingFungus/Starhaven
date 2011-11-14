package HUDs {
	import org.flixel.*;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MapBounds extends FlxObject {
		
		private var hstripe:FlxSprite;
		private var vstripe:FlxSprite;
		public function MapBounds() {
			super();
			
			//hstripe = new FlxSprite().createGraphic(FlxG.width, C.BLOCK_SIZE * 3, 0xffff8080);
			//vstripe = new FlxSprite().createGraphic(C.BLOCK_SIZE * 3, FlxG.height, 0xffff8080);
			
			hstripe = new FlxSprite().createGraphic(C.B.OUTER_BOUNDS.width * C.BLOCK_SIZE, C.BLOCK_SIZE * 3, 0xffff8080);
			vstripe = new FlxSprite().createGraphic(C.BLOCK_SIZE * 3, C.B.OUTER_BOUNDS.height * C.BLOCK_SIZE, 0xffff8080);
			hstripe.blend = vstripe.blend = "lighten";
		}
		
		override public function render():void {
			vstripe.x = C.B.OUTER_BOUNDS.left * C.BLOCK_SIZE + C.B.drawShift.x - vstripe.width;
			vstripe.render();
			vstripe.x = C.B.OUTER_BOUNDS.right * C.BLOCK_SIZE + C.B.drawShift.x;
			vstripe.render();
			//var offX:Number = C.scale * C.drawShift.x;
			//vstripe.x = C.B.OUTER_BOUNDS.left * C.BLOCK_SIZE * C.scale - vstripe.width + offX;
			//vstripe.render();
			//vstripe.x = C.B.OUTER_BOUNDS.right * C.BLOCK_SIZE * C.scale + offX;
			//vstripe.render();
			
			hstripe.y = C.B.OUTER_BOUNDS.top * C.BLOCK_SIZE + C.B.drawShift.y - hstripe.height;
			hstripe.render();
			hstripe.y = C.B.OUTER_BOUNDS.bottom * C.BLOCK_SIZE + C.B.drawShift.y;
			hstripe.render();
			//var offY:Number = C.scale * C.drawShift.y;
			//hstripe.y = C.B.OUTER_BOUNDS.top * C.BLOCK_SIZE * C.scale - hstripe.height + offY;
			//hstripe.render();
			//hstripe.y = C.B.OUTER_BOUNDS.bottom * C.BLOCK_SIZE * C.scale + offY;
			//hstripe.render();
		}
		//}
	}

}