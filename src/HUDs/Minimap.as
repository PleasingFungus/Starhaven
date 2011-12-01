package HUDs {
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Minimap extends FlxSprite {
		
		private var station:Station;
		private var lastStates:Dictionary;
		private var map:BitmapData;
		private var viewbox:BitmapData;
		public var dirty:Boolean = true;
		public function Minimap(X:int, Y:int, station:Station) {
			super(X, Y);
			this.station = station;
			station.minimap = this;
			
			lastStates = new Dictionary(true);
			
			
			createGraphic(C.B.maxDim.x, C.B.maxDim.y, 0xff000000, true, "minimap"+C.B.maxDim);
			map = pixels.clone();
			
			x += width / 2;
			y += width / 2;
			setScale();
		}
		
		protected function setScale():void {
			if (width * 2 < FlxG.width / 3 && height * 2 < FlxG.height / 3) {
				scale.x = scale.y = 2;
				x = y = width / 2;
			} else {
				scale.x = scale.y = 1;
				x = y = 0;
			}
		}
		
		//public function rotate(clockwise:Boolean):void {
			//_mtx.rotate(clockwise ? 90 : -90);// Math.PI / 2 : -Math.PI / 2);
			//_framePixels.draw(map, _mtx);
			//map.draw(_framePixels);
		//}
		
		override public function update():void {
			for each (var mino:Mino in Mino.all_minos)
				if (mino.exists && !mino.falling && mino is Smino) {
					var smino:Smino = mino as Smino;
					if (lastStates[smino] == null || lastStates[smino] != smino.operational) {
						drawMino(mino);
						lastStates[smino] = smino.operational;
					}
				}
		}
		
		public function drawMino(mino:Mino):void {
			var absCenter:Point = mino.absoluteCenter;
			for each (var block:Block in mino.blocks)
				if (!block.damaged) {
					var X:int = block.x + absCenter.x;
					var Y:int = block.y + absCenter.y;
					map.setPixel(X - C.B.OUTER_BOUNDS.left, Y - C.B.OUTER_BOUNDS.top, mino.minimapColor(block));
				}
		}
		
		protected function resetMap():void {
			map.fillRect(_flashRect, 0xffff0000);
			_flashRect2.x = _flashRect2.y = 1;
			_flashRect2.width = _flashRect.width - 2;
			_flashRect2.height = _flashRect.height - 2;
			map.fillRect(_flashRect2, 0xff000000);
			_flashRect2.x = _flashRect2.y = 0;
			_flashRect2.width = _pixels.width;
			_flashRect2.height = _pixels.height;
			
			if (C.fluid)
				drawMino(C.fluid);
			
			for (var X:int = C.B.OUTER_BOUNDS.left; X < C.B.OUTER_BOUNDS.right; X++)
				for (var Y:int = C.B.OUTER_BOUNDS.top; Y < C.B.OUTER_BOUNDS.bottom; Y++) {
					var mino:Mino = Mino.getGrid(X, Y);
					if (mino && mino.exists) {
						var absCenter:Point = mino.absoluteCenter;
						for each (var block:Block in mino.blocks)
							if (block.x + absCenter.x == X && block.y + absCenter.y == Y)
								break;
						map.setPixel(X - C.B.OUTER_BOUNDS.left, Y - C.B.OUTER_BOUNDS.top, mino.minimapColor(block));
					}
				}
			
			dirty = false;
		}
		
		override public function render():void {
			if (dirty)
				resetMap();
			if (!C.HUD_ENABLED)
				return;
			
			_framePixels.fillRect(_flashRect, 0x40000000);
			_framePixels.draw(map, null, map_ct);
			drawMino(station.core); //deals with issue if station is not center cored, for some reason
			drawCurrent();
			drawViewbox();
			setScale();
			super.render();
		}
		
		protected function drawCurrent():void {
			for each (var mino:Mino in Mino.all_minos)
				if (mino.exists && mino.visible && mino.falling) {
					var absCenter:Point = mino.absoluteCenter;
					for each (var block:Block in mino.blocks) {
						var X:int = block.x + absCenter.x;
						var Y:int = block.y + absCenter.y;
						_framePixels.setPixel(X - C.B.OUTER_BOUNDS.left, Y - C.B.OUTER_BOUNDS.top, mino.minimapColor(block));
					}
				}
		}
		
		protected function drawViewbox():void {
			if (!viewbox || FlxG.width / (C.BLOCK_SIZE * C.B.scale) != viewbox.width) {
				if (viewbox)
					viewbox.dispose();
				generateViewbox();
			}
			
			_mtx.identity();
			_mtx.translate(map.width/2  - C.B.drawShift.x / C.BLOCK_SIZE,
						   map.height/2 - C.B.drawShift.y / C.BLOCK_SIZE);
			_framePixels.draw(viewbox, _mtx);
		}
		
		protected function generateViewbox():void {
			viewbox = new BitmapData(FlxG.width / (C.BLOCK_SIZE * C.B.scale), FlxG.height / (C.BLOCK_SIZE * C.B.scale), true, 0x80ffd000);
			viewbox.fillRect(new Rectangle(1, 1, viewbox.width - 2, viewbox.height - 2), 0x0);
		}
		
		private const map_ct:ColorTransform = new ColorTransform(1, 1, 1, 0.5);
	}

}