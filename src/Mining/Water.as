package Mining {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class Water extends Mino {
		
		protected var surfaceLevel:int;
		public function Water(SurfaceLevel:int) {
			surfaceLevel = SurfaceLevel;
			var depth:int = C.B.OUTER_BOUNDS.height - SurfaceLevel;
			var blocks:Array = new Array(C.B.OUTER_BOUNDS.width * depth);
			for (var x:int = C.B.OUTER_BOUNDS.left; x < C.B.OUTER_BOUNDS.right; x++)
				for (var y:int = SurfaceLevel; y < C.B.OUTER_BOUNDS.bottom; y++)
					blocks[x + y * C.B.OUTER_BOUNDS.width] = new Block(x, y);
			
			var center:Point = new Point(C.B.OUTER_BOUNDS.left + Math.floor(C.B.OUTER_BOUNDS.width / 2),
										 SurfaceLevel + Math.floor(depth / 2))
			
			name = "Water";
			super(0, center.y, blocks, center, 0xff8aaee3);
			C.iconLeeches.push(this);
			
			falling = false;
			//addToGrid();
			C.fluid = this;
		}
		
		override public function intersectsPoint(point:Point, oPoint:Point = null):Boolean {
			return point.y > surfaceLevel;
		}
		
		override public function intersect(other:Mino):Boolean {
			if (!canIntersect(other))
				return false;
			
			var otherBounds:Rectangle = other.bounds;
			return otherBounds.bottom > surfaceLevel;
		}
		
		private var normalSpr:BitmapData;
		private var bgSpr:BitmapData;
		override protected function drawBlocks():void {
			var Stamp:FlxSprite = new FlxSprite().createGraphic(C.BLOCK_SIZE, C.BLOCK_SIZE);
			
			for each (var block:Block in blocks) {
				var X:int = (block.x - topLeft.x) * C.BLOCK_SIZE;
				var Y:int = (block.y - topLeft.y) * C.BLOCK_SIZE;
				
				var depth:Number = (block.y - topLeft.y) / blockDim.y;
				var depthColor:uint = C.interpolateColors(0x0e0d31, 0x8aaee3, depth);
				Stamp.color = depthColor;
				//Stamp.alpha = (depthColor >> 24) / 255;
				
				draw(Stamp, X, Y);
			}
			
			//normalSpr = _framePixels;
			//bgSpr = _framePixels.clone();
			//bgSpr.colorTransform(new Rectangle(0, 0, width, height), new ColorTransform(1, 1, 1, 1, 0, 0, 0, 255));
		}
		
		override public function render():void {
			alpha = 1;
			//_framePixels = bgSpr;
			super.render();
			//_framePixels = normalSpr;
		}
		
		override public function renderTop(__:Boolean, _:Boolean = false):void {
			alpha = 0.5;
			super.render();
			
		}
		
	}

}