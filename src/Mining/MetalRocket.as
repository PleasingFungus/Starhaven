package Mining {
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MetalRocket extends FlxSprite {
		
		public function MetalRocket(X:int, Y:int) {
			super(X * C.BLOCK_SIZE, Y * C.BLOCK_SIZE);
			loadGraphic(_sprite);
			
			//if (Math.abs(X) > Math.abs(Y))
				//facing = X > 0 ? RIGHT : LEFT;
			//else
				//facing = Y > 0 ? DOWN : UP;
			//
			//switch (facing) {
				//case LEFT:
					//acceleration.x = -ACCEL; angle = 180; y -= height / 2; break;
				//case UP:
					//acceleration.y = -ACCEL; angle = 270; x -= width / 2; break;
				//case RIGHT:
					//acceleration.x = ACCEL; angle = 0; y -= height / 2; break;
				//case DOWN:
					//acceleration.y = ACCEL; angle = 90; x -= width / 2; break;
			//}
			acceleration.y = -ACCEL;
			x -= C.BLOCK_SIZE / 2;
		}
		
		private var vanishTimer:Number = 0;
		override public function update():void {
			super.update();
			vanishTimer += FlxG.elapsed;
			if (vanishTimer >= 5)
				exists = false;
		}
		
		override public function render():void {
			offset.x = -C.B.drawShift.x - C.BLOCK_SIZE/2;
			offset.y = -C.B.drawShift.y// - C.BLOCK_SIZE/2;
			super.render();
		}
		
		private const ACCEL:Number = 200;
		
		[Embed(source = "../../lib/art/other/rocket_generic_2.png")] private static const _sprite:Class;
	}

}