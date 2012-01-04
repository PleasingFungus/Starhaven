package  {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.sampler.NewObjectSample;
	import flash.utils.Dictionary;
	import Icons.IconLeech;
	import Icons.NoCrewIcon;
	import Icons.NoPowerIcon;
	import Mining.BaseAsteroid;
	import org.flixel.*;
	import flash.geom.Point;
	import SFX.ExplosionSpark;
	import Sminos.Barracks;
	
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class Mino extends FlxSprite {
		
		public var blocks:Array;
		public var gridLoc:Point;
		public var center:Point;
		public var blockDim:Point;
		public var parent:Aggregate;
		
		public var falling:Boolean = true;
		public var cycleTime:Number = 0;
		public var cycleSpeed:Number = 1;
		protected var touchedHorizontally:Boolean;
		
		public var dangerous:Boolean;
		public var current:Boolean;
		protected var sidewaysAttachable:Boolean = true;
		public var storedMinerals:int = 0;
		
		public var damaged:Boolean;
		public var newlyDamaged:Boolean;
		public var exploded:Boolean;
		protected var damagedBy:Mino;
		
		protected var topLeft:Point;
		protected var sprite:Class;
		private var debugOutline:FlxSprite;
		public var name:String;
		public var cladeName:String;
		public function Mino(X:int, Y:int, Blocks:Array, Center:Point, 
							 Color:uint = 0xffa0a0a0, Sprite:Class = null) {
			super();
			
			gridLoc = new Point(X, Y);
			blocks = Blocks;
			center = Center;
			sprite = Sprite;
			
			facing = DOWN;
			generateSprite();
			
			if (!sprite)
				color = Color;
		}
		
		protected var sprites:Array = [];
		protected function generateSprite(forceGen:Boolean = false):void {
			//runSanityCheck();
			calculateDimensions();
			
			_ct = null;
			
			if (forceGen || !sprites[facing])
				createSprite();
			else
				pixels = sprites[facing];
			
			if (!sprite)
				if((_alpha != 1) || (_color != 0x00ffffff)) _ct = new ColorTransform(Number(_color>>16)/255,Number(_color>>8&0xff)/255,Number(_color&0xff)/255,_alpha);
			calcFrame();
			
			offset.x = -topLeft.x * C.BLOCK_SIZE;
			offset.y = -topLeft.y * C.BLOCK_SIZE;
			
			if (C.DEBUG && C.DISPLAY_BOUNDS)
				generateDebugOutline();
		}
		
		protected function createSprite():void {
			var backColor:uint = (C.DEBUG && C.DISPLAY_DRAW_AREA) ? C.DEBUG_COLOR : 0x0/*1000000*/;
			if (sprite) {
				loadGraphic(sprite);
				rotateSprite(facing);
				
			} else {
				createGraphic(C.BLOCK_SIZE * blockDim.x, C.BLOCK_SIZE * blockDim.y, backColor, true);
			}
			
			if (!sprite)
				drawBlocks();
			
			if (sprites[facing])
				sprites[facing].dispose();
			sprites[facing] = pixels;
		}
		
		protected function drawBlocks():void {
			var Stamp:FlxSprite = new FlxSprite().createGraphic(C.BLOCK_SIZE, C.BLOCK_SIZE);
			
			for each (var block:Block in blocks) {
				var X:int = (block.x - topLeft.x) * C.BLOCK_SIZE;
				var Y:int = (block.y - topLeft.y) * C.BLOCK_SIZE;
				draw(Stamp, X, Y);
			}
		}
		
		private function rotateSprite(facing:int):void {
			/*if (facing == DOWN)
				return;*/
			var newWidth:int = C.BLOCK_SIZE * blockDim.x;
			var newHeight:int = C.BLOCK_SIZE * blockDim.y;
			var backColor:uint = (C.DEBUG && C.DISPLAY_DRAW_AREA) ? C.DEBUG_COLOR : 0x0;
			var temp:BitmapData = new BitmapData(newWidth, newHeight, true, backColor);
			
			_mtx.identity();
			_mtx.translate( -width / 2, -height / 2);
			_mtx.rotate((facing + 1) * Math.PI / 2);
			_mtx.translate(newWidth / 2, newHeight / 2);
			
			temp.draw(pixels, _mtx);
			pixels = temp;
			calcFrame();
		}
		
		protected function resetSprites():void {
			for each (var sprite:BitmapData in sprites)
				sprite.dispose();
			sprites = [];
		}
		
		protected function calculateDimensions():void {
			topLeft = new Point(int.MAX_VALUE, int.MAX_VALUE);
			var bottomRight:Point = new Point(int.MIN_VALUE, int.MIN_VALUE);
			for each (var block:Point in blocks) {
				if (block.x > bottomRight.x)
					bottomRight.x = block.x;
				if (block.x < topLeft.x)
					topLeft.x = block.x;
				
				if (block.y > bottomRight.y)
					bottomRight.y = block.y;
				if (block.y < topLeft.y)
					topLeft.y = block.y;
			}
			
			blockDim = new Point(bottomRight.x - topLeft.x + 1, bottomRight.y - topLeft.y + 1);
		}
		
		private function generateDebugOutline():void {
			debugOutline = new FlxSprite(topLeft.x * C.BLOCK_SIZE - 1, topLeft.y * C.BLOCK_SIZE - 1);
			debugOutline.createGraphic(blockDim.x * C.BLOCK_SIZE + 2, blockDim.y * C.BLOCK_SIZE + 2, 0xafff0000);
			debugOutline.pixels.fillRect(new Rectangle(1, 1,
													   debugOutline.width - 2, debugOutline.height - 2), 0xff000000);
		}
		
		public function forceSpriteReset():void {
			resetSprites();
			generateSprite(true);
		}
		
		
		
		
		override public function update():void {
			if (newlyDamaged)
				beDamaged();
			
			super.update();
			
			runCycle();
			if (current)
				C.B.centerDrawShiftOn(gridLoc, true);
		}
		
		protected function runCycle():void {
			cycleTime += FlxG.elapsed * cycleSpeed;
			if (cycleTime >= C.CYCLE_TIME) {
				cycleTime -= C.CYCLE_TIME;
				executeCycle();
			}
			
			if (GlobalCycleTimer.justDropped)
				executeDropCycle();
		}
		
		protected function executeCycle():void {
			if (falling)
				fall();
		}
		
		protected function fall():void {
			var hit:Mino = moveDown();
			if (hit && hit.parent)
				anchorTo(hit.parent);
		}
		
		protected function anchorTo(Parent:Aggregate):void { }
		
		public function addToGrid():void {
			var absCenter:Point = absoluteCenter;
			for each (var block:Block in blocks)
				if (!block.damaged)
					setGrid(absCenter.x + block.x, absCenter.y + block.y, this);
		}
		
		public function removeFromGrid():void {
			var absCenter:Point = absoluteCenter;
			for each (var block:Block in blocks)
				if (getGrid(absCenter.x + block.x, absCenter.y + block.y) == this)
					setGrid(absCenter.x + block.x, absCenter.y + block.y, null);
		}
		
		public function executeDropCycle():void { }
		
		public function takeExplodeDamage(X:int, Y:int, Source:Mino):void { }
		public function beHit(Source:Mino):void { }
		
		protected function beDamaged():void { }
		
		
		
		
		public function moveDown(forced:Boolean = false):Mino {
			gridLoc.y += 1;
			
			var hit:Mino = intersects();
			if (hit)
				gridLoc.y -= 1;
			if (hit && forced) {
				anchorTo(hit.parent);
			}
			touchedHorizontally = false;
			return hit;
		}
		
		public function moveUp():Mino {
			gridLoc.y -= 1;
			
			var hit:Mino = intersects();
			if (hit)
				gridLoc.y += 1;
			return hit;
		}
		
		public function moveLeft():Mino {
			gridLoc.x -= 1;
			
			if (outsidePlayArea()) {
				gridLoc.x += 1;
				return this;
			}
			
			var hit:Mino = intersects();
			if (hit) {
				gridLoc.x += 1;
				if (sidewaysAttachable) {
					if (touchedHorizontally)
						anchorTo(hit.parent);
					else
						touchedHorizontally = true;
				}
			}
			return hit;
		}
		
		public function moveRight():Mino {
			gridLoc.x += 1;
			
			if (outsidePlayArea()) {
				gridLoc.x -= 1;
				return this;
			}
			
			var hit:Mino = intersects();
			if (hit) {
				gridLoc.x -= 1;
				if (sidewaysAttachable) {
					if (touchedHorizontally)
						anchorTo(hit.parent);
					else
						touchedHorizontally = true;
				}
			}
			return hit;
		}
		
		public function rotateClockwise(Force:Boolean = false):Mino {
			rotate(true);
			
			if (Force)
				return null;
			
			if (outsidePlayArea()) {
				rotate(false);
				return this;
			}
			
			var hit:Mino = intersects();
			if (hit)
				rotate(false);
			return hit;
		}
		
		public function rotateCounterclockwise(Force:Boolean = false):Mino {
			rotate(false);
			
			if (Force)
				return null;
			
			if (outsidePlayArea()) {
				rotate(true);
				return this;
			}
			
			var hit:Mino = intersects();
			if (hit)
				rotate(true);
			return hit;
		}
		
		protected function rotate(clockwise:Boolean):void {
			var factor:Point = clockwise ? new Point(1, -1) : new Point( -1, 1);
			
			for each (var block:Point in blocks) {
				block.x -= center.x;
				block.y -= center.y;
				
				var newLoc:Point = new Point(block.y * factor.x, block.x * factor.y);
				block.x = newLoc.x;
				block.y = newLoc.y;
				
				block.x += center.x;
				block.y += center.y;
			}
			
			facing = (facing + (clockwise ? 3 : 1)) & 3;
			generateSprite();
		}
		
		public function rotateAbout(targetCenter:Point, clockwise:Boolean):void {
			var factor:Point = clockwise ? new Point(1, -1) : new Point( -1, 1);
			rotate(clockwise);
			
			gridLoc.x -= targetCenter.x;
			gridLoc.y -= targetCenter.y;
			
			gridLoc = new Point(gridLoc.y * factor.x, gridLoc.x * factor.y);
			
			gridLoc.x += targetCenter.x;
			gridLoc.y += targetCenter.y;
		}
		
		
		
		
		
		override public function render():void {
			x = (gridLoc.x - center.x) * C.BLOCK_SIZE;
			y = (gridLoc.y - center.y) * C.BLOCK_SIZE;
			
			if (debugOutline) {
				var p:FlxPoint = getScreenXY(_point);
				debugOutline.x = (topLeft.x + gridLoc.x - center.x) * C.BLOCK_SIZE - 1 + C.B.drawShift.x;
				debugOutline.y = (topLeft.y + gridLoc.y - center.y) * C.BLOCK_SIZE - 1 + C.B.drawShift.y;
				debugOutline.render();
			}
			
			super.render();
		}
		
		public function forceRender():void {
			super.render();
		}
		
		public function renderTop(force:Boolean = false):void { }
		
		override public function getScreenXY(point:FlxPoint=null):FlxPoint {
			point = super.getScreenXY(point);
			point.x += C.B.drawShift.x;
			point.y += C.B.drawShift.y;
			return point;
		}
		
		
		
		
		
		
		
		
		
		
		public function intersectsPoint(point:Point, oPoint:Point = null):Boolean {
			if (!oPoint)
				oPoint = new Point();
			
			for each (var block:Block in blocks) {
				if (block.damaged)
					continue;
				
				oPoint.x = block.x + gridLoc.x - center.x;
				oPoint.y = block.y + gridLoc.y - center.y;
				if (oPoint.equals(point))
					return true;
			}
			
			return false;
		}
		
		public function canIntersect(other:Mino):Boolean {
			return other &&
				  other != this &&
				  (!parent || other.parent != parent) &&
				  other.exists &&
				  other.solid &&
				  (!falling || !other.falling);
		}
		
		public function intersect(other:Mino):Boolean {
			if (!canIntersect(other))
				return false;
			
			var otherBounds:Rectangle = other.bounds;
			if (bounds.intersection(otherBounds).width == 0)
				return false;
			
			var loc:Point = new Point();
			var oLoc:Point = new Point();
			for each (var block:Block in blocks) {
				if (block.damaged)
					continue;
				
				loc.x = block.x + gridLoc.x - center.x;
				loc.y = block.y + gridLoc.y - center.y;
				if (otherBounds.containsPoint(loc))
					if (other.intersectsPoint(loc, oLoc))
						return true;
			}
			
			return false;
		}
		
		public function intersects():Mino {
			for each(var mino:Mino in all_minos)
				if (intersect(mino))
					return mino;
			return null;
		}
		
		//public function intersects():Mino {
			//for each (var block:Block in blocks) {
				//if (
			//}
		//}
		
		
		public function adjacent(other:Mino):Boolean {
			var expandedBounds:Rectangle = bounds;
			expandedBounds.x -= 1;
			expandedBounds.y -= 1;
			expandedBounds.width += 2;
			expandedBounds.height += 2;
			
			if (expandedBounds.intersection(other.bounds).width == 0)
				return false;
			
			
			var loc:Point = new Point();
			var oLoc:Point = new Point();
			for each (var oblock:Point in other.blocks) {
				oLoc.x = oblock.x + other.gridLoc.x - other.center.x;
				oLoc.y = oblock.y + other.gridLoc.y - other.center.y;
				if (expandedBounds.containsPoint(oLoc)) //broken w/neg. block points?
					for each (var block:Point in blocks) {
						loc.x = block.x + gridLoc.x - center.x;
						loc.y = block.y + gridLoc.y - center.y;
						if (Math.abs(oLoc.x - loc.x) + Math.abs(oLoc.y - loc.y) == 1)
							return true;
					}
			}
			
			return false;
		}
		
		public function mergeNeighbors():void {
			for each (var mino:Mino in Mino.all_minos)
				if (mino.exists && mino.parent && mino.parent != parent && adjacent(mino))
					mino.parent.merge(parent);
		}
		
		
		public function outsidePlayArea():Boolean {
			return !C.B.PlayArea.containsRect(bounds);
		}
		
		public function outsideOuterBounds():Boolean {
			return !C.B.OUTER_BOUNDS.containsRect(bounds);
		}
		
		public function outsideScreenArea():Boolean {
			var db:Rectangle = getDrawBounds();
			db.x /= C.B.scale;
			db.y /= C.B.scale;
			db.width /= C.B.scale;
			db.height /= C.B.scale;
			return !C.B.screenArea.containsRect(db);
		} //TODO: TESTME
		
		
		
		public function get bounds():Rectangle {
			return new Rectangle(topLeft.x + gridLoc.x - center.x, topLeft.y + gridLoc.y - center.y,
								 blockDim.x, blockDim.y);
		}
		
		public function get absoluteCenter():Point { //broken?
			return new Point(gridLoc.x - center.x, gridLoc.y - center.y);
		} //?
		
		public function get targetCenter():Point {
			return gridLoc.clone();
		}
		
		public function getDrawBounds():Rectangle {
			var b:Rectangle = bounds;
			b.x = b.x * C.BLOCK_SIZE + C.B.drawShift.x;
			b.y = b.y * C.BLOCK_SIZE + C.B.drawShift.y;
			b.width = b.width * C.BLOCK_SIZE;
			b.height = b.height * C.BLOCK_SIZE;
			return b;
		}
		
		public function minimapColor(block:Block=null):uint {
			return color;
		}
		
		
		
		
		protected function explode(radius:int):void {
			var explosionOrigin:Point = absoluteCenter;//new Point(topLeft.x + gridLoc.x - center.x, topLeft.y + gridLoc.y - center.y);
			//var explosionBounds:Rectangle = getExplosionBounds(explosionOrigin, radius);
			
			exploded = true;
			
			//for each (var mino:Mino in all_minos) {
				//if (!mino.exists || mino == this || mino.exploded)
					//continue;
				//
				//var intersection:Rectangle = explosionBounds.intersection(mino.bounds);
				//if (intersection.width && intersection.height)
					//mino.beExploded(explosionOrigin, radius, intersection);
			//}
			
			//for (var X:int = explosionBounds.x; X <= explosionBounds.right; X++)
				//for (var Y:int = explosionBounds.y; Y <= explosionBounds.bottom; Y++)
			
			for (var X:int = explosionOrigin.x - radius; X <= explosionOrigin.x + radius; X++)
				for (var Y:int = explosionOrigin.y - radius; Y <= explosionOrigin.y + radius; Y++)
					//if (Math.abs(X - explosionOrigin.x) + Math.abs(Y - explosionOrigin.y) <= radius) {
					if (Math.sqrt((X - explosionOrigin.x) * (X - explosionOrigin.x) + (Y - explosionOrigin.y) * (Y - explosionOrigin.y)) <= radius) {
						var victim:Mino = getVictim(X, Y);
						if (victim)
							victim.takeExplodeDamage(X, Y, this);
						Mino.layer.add(new ExplosionSpark(X, Y));
					}
			
			FlxG.quake.start(0.01 * radius, 0.05 * radius * radius);
			
			exists = falling = false;
		}
		
		protected function getVictim(X:int, Y:int):Mino {
			return getGrid(X, Y);
		}
		
		protected function getExplosionBounds(explosionOrigin:Point, radius:int):Rectangle {
			return new Rectangle(explosionOrigin.x - (radius - 1), explosionOrigin.y - (radius - 1),
								 radius * 2 - 1, radius * 2 - 1);
		}
		
		public function serialize():String {
			var str:String = name + DELIMITER + gridLoc.x + DELIMITER + gridLoc.y + DELIMITER + facing;
			
			for (var i:int = 0; i < blocks.length; i++)
				if (blocks[i].damaged)
					str += "," + i;
			
			return str;
		}
		
		public static const DELIMITER:String = ",";
		
		
		
		
		public static function getGrid(X:int, Y:int):Mino {
			if (!grid) return null;
			return grid[getCoord(X,Y)];
		}
		public static function setGrid(X:int, Y:int, mino:Mino):Mino {
			if (!grid) return null;
			grid[getCoord(X,Y)] = mino;
			return mino;
		}
		public static function resetGrid():void {
			grid = new Array(C.B.maxDim.x * C.B.maxDim.y);
		}
		
		private static function getCoord(X:int, Y:int):int {
			return (X - (C.B.maxDim.x >> 1)) + (Y - (C.B.maxDim.y >> 1)) * C.B.maxDim.x;
		}
		
		//public static function rotateGridAbout(centerMino:Mino, clockwise:Boolean):void {
			//var center:Point = new Point(centerMino.gridLoc.x - centerMino.center.x, centerMino.gridLoc.y - centerMino.center.y);
			//var newGrid:Dictionary = new Dictionary(true);
			//for (var coord:String in grid) {
				//var coords:Array = coord.split(',');
				//var X:int = coords[0];
				//var Y:int = coords[1];
				//newGrid(
			//}
		//}
		
		protected static var grid:Array;
		public static var all_minos:Array;
		public static var layer:FlxGroup;
		
		
		[Embed(source = "../lib/art/other/lattice.png")] protected static const _damage_block:Class;
		[Embed(source = "../lib/art/other/latticev2.png")] protected static const _damage_block_v:Class;
	}

}