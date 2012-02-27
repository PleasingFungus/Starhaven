package  {
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import org.flixel.*;
	import Mining.ResourceSource;
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class Aggregate extends FlxObject {
		
		public var core:Mino;
		public var members:Array = [];
		
		public var rotation:Number;
		public var centroidOffset:Point;
		public var forcedRotate:Boolean;
		public var forcedRotationDirection:Number;
		public var initialRotationDirection:Number;
		public var justRotated:Boolean;
		
		
		protected var rotateSpeed:Number;
		protected const initRotSpeed:Number = Math.PI / 6;
		protected const finalRotSpeed:Number = Math.PI * 9 / 6;
		protected const spinupTime:Number = 0.25;
		private var wasForced:Boolean;
		
		public function Aggregate(Core:Mino) {
			super();
			add(core = Core);
			
			rotation = 0;
			centroidOffset = new Point;
			rotateSpeed = 0;
			forcedRotationDirection = NaN;
		}
		
		public function add(mino:Mino):Mino {
			mino.parent = this;
			mino.falling = false;
			members.push(mino);
			return mino;
		}
		
		public function merge(other:Aggregate):void {
			if (other is Station) {
				other.merge(this);
				return;
			}
			
			for each (var mino:Mino in other.members)
				add(mino);
			other.exists = false;
		}
		
		
		
		public function smoothRotateClockwise():void {
			setRotate( 1);
		}
		
		public function smoothRotateCounterclockwise():void {
			setRotate( -1);
		}
		
		private function setRotate(direction:Number):void {
			if (forcedRotationDirection != direction)
				rotateSpeed = initRotSpeed;
			
			forcedRotationDirection = direction;
			if (!initialRotationDirection)
				initialRotationDirection = direction;
			forcedRotate = true;
			Scenario.substate = Scenario.SUBSTATE_ROTPAUSE;
			for each (var mino:Mino in members)
				mino.visible = false;
		}
		
		override public function update():void {
			if (Scenario.substate == Scenario.SUBSTATE_ROTPAUSE)
				rotateSmoothly();
			else
				justRotated = false;
			super.update();
		}
		
		public function rotateSmoothly():void {
			justRotated = false;
			
			
			var curRot:Number = rotation;
			var rotationDirection:Number = forcedRotate ? forcedRotationDirection : -initialRotationDirection;
			
			if (wasForced != forcedRotate)
				rotateSpeed = initRotSpeed;
			else if (rotateSpeed < finalRotSpeed)
				rotateSpeed += FlxG.elapsed * (finalRotSpeed - initRotSpeed) / spinupTime;
			
			var dR:Number = rotationDirection * FlxG.elapsed * rotateSpeed;
			rotation += dR;
			
			
			var clockwise:Boolean = rotationDirection == 1;
			var reverting:Boolean = clockwise ? curRot < 0 : curRot > 0;
			var divider:Number;
			var crossedDivider:Boolean;
			
			if (clockwise) {
				divider = reverting ? 0 : Math.PI / 2;
				crossedDivider = rotation > divider;
			} else {
				divider = reverting ? 0 : -Math.PI / 2;
				crossedDivider = rotation < divider;
			}
			
			if (crossedDivider) {
				var hit:Mino;
				
				if (reverting)
					hit = null;
				else if (clockwise)
					hit = rotateCounterclockwise(); //visible rotation backwards from actual rotation
				else
					hit = rotateClockwise();
				
				if (hit) {
					rotation = curRot; //bump! revert to last rotation
				} else {
					//rotation = section * Math.PI / 2;
					rotation = 0; //redundant with piecewise rotation otherwise
					if (forcedRotate)
						initialRotationDirection = forcedRotationDirection;
					else {
						justRotated = true;
						Scenario.substate = Scenario.SUBSTATE_NORMAL;
						for each (var mino:Mino in members)
							mino.visible = true;
						forcedRotationDirection = initialRotationDirection = NaN;
						FlxG.quake.start(0.02, 0.075);
						C.sound.play(END_ROTATE_NOISE)//, 1/3);
					}
				}
			}
			
			wasForced = forcedRotate;
			forcedRotate = false; //require continuous presses to keep rotating!
		}
		
		protected function rotateClockwise():Mino {
			var hit:Mino = rotate(true);
			if (!hit)
				C.sound.play(ROTATE_NOISE, 2/3)//, 1/2);
			return hit;
		}
		
		protected function rotateCounterclockwise():Mino {
			var hit:Mino = rotate(false);
			if (!hit)
				C.sound.play(ROTATE_NOISE, 2/3)//, 1/2);
			return hit;
		}
		
		protected function rotate(clockwise:Boolean):Mino {
			var rotateCenter:Point = core.gridLoc.add(centroidOffset);
			for each (var mino:Mino in members)
				if (mino && mino.exists)
					mino.rotateAbout(rotateCenter, clockwise);
			
			var hit:Mino = intersects();
			if (hit) {
				for each (mino in members)
					if (mino && mino.exists)
						mino.rotateAbout(rotateCenter, !clockwise);
			} else {
				rotateCentroid(clockwise);
				for each (mino in members)
					if (mino && mino.exists)
						mino.mergeNeighbors(); //this should probably be optimized
			}
			
			return hit;
		}
		
		protected function rotateCentroid(clockwise:Boolean):void {
			if (clockwise)
				centroidOffset = new Point( centroidOffset.y, -centroidOffset.x);
			else
				centroidOffset = new Point( -centroidOffset.y, centroidOffset.x);
		}
		
		public function intersects():Mino {
			for each (var mino:Mino in members)
				if (mino) {
					var hit:Mino = mino.intersects();
					if (hit)
						return hit;
				}
			
			return null;
		}
		
		public function get bounds():Rectangle {
			var min:Point = new Point(int.MAX_VALUE, int.MAX_VALUE);
			var max:Point = new Point(int.MIN_VALUE, int.MIN_VALUE);
			for each (var mino:Mino in members) {
				if (!mino) continue;
				
				var minoBounds:Rectangle = mino.bounds;
				if (min.x > minoBounds.left)
					min.x = minoBounds.left;
				if (max.x < minoBounds.right)
					max.x = minoBounds.right;
				
				if (min.y > minoBounds.top)
					min.y = minoBounds.top;
				if (max.y < minoBounds.bottom)
					max.y = minoBounds.bottom;
			}
			
			return new Rectangle(min.x, min.y, max.x - min.x, max.y - min.y);
		}
		
		public function getDrawBounds():Rectangle {
			var b:Rectangle = bounds;
			b.x = b.x * C.BLOCK_SIZE + C.B.drawShift.x;
			b.y = b.y * C.BLOCK_SIZE + C.B.drawShift.y;
			b.width = b.width * C.BLOCK_SIZE;
			b.height = b.height * C.BLOCK_SIZE;
			return b;
		}
		
		
		
		override public function render():void {
			if (Scenario.substate == Scenario.SUBSTATE_ROTPAUSE)
				renderRotated();
			
			if (C.DEBUG && C.DISPLAY_BOUNDS)
				renderDebugOutline();
		}
		
		//transform:
			//db.left - core.left, db.top - core.top
			//rotate
			//core.left - db.left, core.top - db.top
			//db.left, db.top
		
		private var _buffer:BitmapData;
		private var _bufferRect:Rectangle = new Rectangle(0, 0, 640, 480);
		private var _matrix:Matrix = new Matrix();
		private function renderRotated():void {
			//get true drawbounds (minus drawshift)
			var drawBounds:Rectangle = getDrawBounds();
			drawBounds.x -= C.B.drawShift.x;
			drawBounds.y -= C.B.drawShift.y;
			
			_bufferRect.setEmpty();
			_bufferRect.inflate(drawBounds.width, drawBounds.height);
			
			if (!_buffer || drawBounds.width != FlxG.buffer.width || drawBounds.height != FlxG.buffer.height) {
				if (_buffer)
					_buffer.dispose();
				_buffer = new BitmapData(drawBounds.width, drawBounds.height, true, 0x0);
			} else
				_buffer.fillRect(_bufferRect, 0x0);
			
			var realBuffer:BitmapData = FlxG.buffer;
			FlxG.buffer = _buffer;
			
			var realShift:Point = C.B.drawShift;
			C.B.drawShift = new Point( -drawBounds.x, -drawBounds.y);
			for each (var mino:Mino in members)
				if (mino.exists)
					mino.render();
			for each (mino in members)
				if (mino.exists)
					mino.renderTop(true);
			C.B.drawShift = realShift;
			
			var coreX:int = (core.gridLoc.x + centroidOffset.x + .5) * C.BLOCK_SIZE;
			var coreY:int = (core.gridLoc.y + centroidOffset.y + .5) * C.BLOCK_SIZE;
			
			_matrix.identity();
			_matrix.translate(drawBounds.x - coreX, drawBounds.y - coreY);
			_matrix.rotate(rotation);
			_matrix.translate(coreX + C.B.drawShift.x, coreY + C.B.drawShift.y);
			
			realBuffer.draw(_buffer, _matrix, null, null, null, true);
			FlxG.buffer = realBuffer
		
		}
			//var rotateCenter:Point = new Point(C.BLOCK_SIZE * (core.gridLoc.x + .5) + C.B.drawShift.x,
												//C.BLOCK_SIZE * (core.gridLoc.y + .5) + C.B.drawShift.y);
			//
			//_matrix.identity();
			//_matrix.translate(-rotateCenter.x, -rotateCenter.y);
			//_matrix.rotate(rotation);
			//_matrix.translate(rotateCenter.x, rotateCenter.y);
			//
			//var realBuffer:BitmapData = FlxG.buffer;
			//if (!_buffer || _buffer.width != realBuffer.width || _buffer.height != realBuffer.height) {
				//if (_buffer)
					//_buffer.dispose();
				//_buffer = new BitmapData(realBuffer.width, realBuffer.height, true, 0x0);
				//_bufferRect.setEmpty();
				//_bufferRect.inflate(_buffer.width, _buffer.height);
			//}
			//FlxG.buffer = _buffer;
			//_buffer.fillRect(_bufferRect, 0x00000000);
			//
			//for each (var mino:Mino in members)
				//if (mino.exists)
					//mino.render();
			//for each (mino in members)
				//if (mino.exists)
					//mino.renderTop(true);
			//
			//realBuffer.draw(_buffer, _matrix, null, null, null, true);
			//FlxG.buffer = realBuffer;
		//}
		
		private function renderDebugOutline():void {
			var b:Rectangle = bounds;
			
			var debugOutline:FlxSprite = new FlxSprite(b.x * C.BLOCK_SIZE + C.B.drawShift.x - 2,
													   b.y * C.BLOCK_SIZE + C.B.drawShift.y - 2);
			debugOutline.createGraphic(b.width * C.BLOCK_SIZE + 4,
										b.height * C.BLOCK_SIZE + 4, 0xff00ffff);
			debugOutline.pixels.fillRect(b, 0xff000000);
			debugOutline.render();
		}
		
		//[Embed(source = "../lib/sound/game/thudcw.mp3")] protected const ROTATE_NOISE:Class;
		//[Embed(source = "../lib/sound/game/thudccw.mp3")] protected const END_ROTATE_NOISE:Class;
		[Embed(source = "../lib/sound/game/rotate_rock.mp3")] protected const ROTATE_NOISE:Class;
		[Embed(source = "../lib/sound/game/end_rotate_rock.mp3")] protected const END_ROTATE_NOISE:Class;
	}

}