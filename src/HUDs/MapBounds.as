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
			
			
			hstripe = new FlxSprite().createGraphic(C.B.OUTER_BOUNDS.width * C.BLOCK_SIZE + STRIPE_WIDTH * 2, STRIPE_WIDTH, 0xffff8080);
			vstripe = new FlxSprite().createGraphic(STRIPE_WIDTH, C.B.OUTER_BOUNDS.height * C.BLOCK_SIZE, 0xffff8080);
			
			var label:FlxText = new FlxText(0, 0, FlxG.width, "DANGER - MAP EDGE - ").setFormat(C.FONT, 24);
			for (var x:int = 5; x < hstripe.width + label.textWidth; x += label.textWidth)
				hstripe.draw(label, x, hstripe.height / 2 - label.height / 2);
			hstripe.frame = 0;
			
			var splitText:String = "";
			for (var i:int = 0; i < label.text.length; i++)
				splitText += label.text.charAt(i) + "\n";
			label.text = splitText;
			for (var y:int = 10; y < vstripe.height + label.height; y += label.height - 30)
				vstripe.draw(label, vstripe.width / 2 - label.textWidth / 2 - 5, y);
			vstripe.frame = 0;
			
			hstripe.blend = vstripe.blend = "lighten";
			hstripe.alpha = vstripe.alpha = alphaFraction;
		}
		
		override public function render():void {
			if (!C.HUD_ENABLED)
				return;
			
			vstripe.y = C.B.OUTER_BOUNDS.top * C.BLOCK_SIZE + C.B.drawShift.y;
			if (C.B.OUTER_BOUNDS.left + PROX_LIMIT >= C.B.StationBounds.left) {
				vstripe.x = C.B.OUTER_BOUNDS.left * C.BLOCK_SIZE + C.B.drawShift.x - vstripe.width;
				vstripe.alpha = 1 - (C.B.StationBounds.left - C.B.OUTER_BOUNDS.left) / PROX_LIMIT;
				vstripe.render();
			} else vstripe.render();
			if (C.B.StationBounds.right + PROX_LIMIT >= C.B.OUTER_BOUNDS.right) {
				vstripe.x = C.B.OUTER_BOUNDS.right * C.BLOCK_SIZE + C.B.drawShift.x;
				vstripe.alpha = 1 - (C.B.OUTER_BOUNDS.right - C.B.StationBounds.right) / PROX_LIMIT;
				vstripe.render();
			}
			
			hstripe.x = C.B.OUTER_BOUNDS.left * C.BLOCK_SIZE + C.B.drawShift.x - vstripe.width;
			if (C.B.OUTER_BOUNDS.top + PROX_LIMIT >= C.B.StationBounds.top) {
				hstripe.y = C.B.OUTER_BOUNDS.top * C.BLOCK_SIZE + C.B.drawShift.y - hstripe.height;
				hstripe.alpha = 1 - (C.B.StationBounds.top - C.B.OUTER_BOUNDS.top) / PROX_LIMIT;
				hstripe.render();
			}
			//hstripe.y = C.B.OUTER_BOUNDS.bottom * C.BLOCK_SIZE + C.B.drawShift.y;
			//hstripe.render(); //irrelevant, never rendered
		}
		
		public function set alpha(a:Number):void {
			hstripe.alpha = vstripe.alpha = a * alphaFraction;
		}
		
		protected const alphaFraction:Number = 1;
		protected const PROX_LIMIT:Number = 8;
		protected const STRIPE_WIDTH:int = C.BLOCK_SIZE * 3;
	}

}