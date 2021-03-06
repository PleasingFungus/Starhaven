package Mining {
	import flash.geom.Point;
	import HUDs.CollectText;
	import org.flixel.FlxSprite;
	import org.flixel.FlxPoint;
	import HUDs.MinedText;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class WaterMineral extends FlxSprite {
		
		private var type:int;
		private var value:int;
		public function WaterMineral(X:int, Y:int, Type:int, Value:int) {
			super((X + 0.5) * C.BLOCK_SIZE, (Y + 0.5) * C.BLOCK_SIZE, _minerals_sprite);
			x -= width / 2;
			y -= height / 2;
			maxVelocity.y = 100;
			
			type = Type;
			value = Value;
			color = MineralBlock.colorOf(type);
			
			MinedText.mine(Value);
		}
		
		private var popped:Boolean;
		override public function update():void {
			super.update();
			
			var grid:Point = new Point(Math.floor((x + width / 2) / C.BLOCK_SIZE), 
									   Math.floor((y + height / 2) / C.BLOCK_SIZE + 1));
			if (C.fluid.intersectsPoint(grid))
				acceleration.y = -maxVelocity.y * 2.4;
			else {
				acceleration.y = maxVelocity.y * 2.4;
				if (!popped && velocity.y < 0) { //just popped out of water
					velocity.y = -maxVelocity.y - acceleration.y * FlxG.elapsed; //hack to make sure minerals always pop up to max height
					popped = true; //doesn't quite work flawlessly, but seems close enough
				}
			}
			
			var mino:Mino = Mino.getGrid(grid.x, grid.y - 1);
			if (mino && mino.exists && mino is Smino) {
				var smino:Smino = mino as Smino;
				if (/*smino.transmitsPower && */smino.powered) {
					smino.station.mineralsMined += value;
					CollectText.collect(value);
					exists = false;
				}
			}
		}
		
		
		override public function getScreenXY(point:FlxPoint=null):FlxPoint {
			point = super.getScreenXY(point);
			point.x += C.B.drawShift.x;
			point.y += C.B.drawShift.y;
			return point;
		}
		
		[Embed(source = "../../lib/art/other/floatmineral.png")] private static const _minerals_sprite:Class;
	}

}