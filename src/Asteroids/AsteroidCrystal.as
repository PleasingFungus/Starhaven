package Asteroids {
	import Mining.MineralBlock;
	import Mining.ResourceSource;
	import org.flixel.FlxSprite;
	import org.flixel.FlxPoint;
	import flash.geom.Point;
	import org.flixel.FlxU;
	import HUDs.CollectText;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class AsteroidCrystal extends FlxSprite {
		
		protected var value:int = 5;
		public function AsteroidCrystal(X:int, Y:int, Target:Point) {
			super(X * C.BLOCK_SIZE, Y * C.BLOCK_SIZE , _minerals_sprite);
			color = 0xff4c355b;
			
			x += C.BLOCK_SIZE * 2 * (FlxU.random() - 0.5);
			y += C.BLOCK_SIZE * 2 * (FlxU.random() - 0.5);
			Target = new Point(Target.x * C.BLOCK_SIZE, Target.y * C.BLOCK_SIZE);
			var targetAngle:Number = Math.atan2(Target.y, Target.x) + (FlxU.random() - 0.5) * Math.PI / 3;
			Target = new Point(Target.length * Math.cos(targetAngle), Target.length * Math.sin(targetAngle));
			
			var delta:Point = new Point(Target.x - x, Target.y - y);
			var speed:Number = 120;
			var v:Point = delta.clone();
			v.normalize(speed);
			velocity = new FlxPoint(v.x, v.y);
		}
		
		override public function update():void {
			super.update();
			
			if ((x + width) / C.BLOCK_SIZE < C.B.OUTER_BOUNDS.left || x / C.BLOCK_SIZE > C.B.OUTER_BOUNDS.right ||
				(y + height) / C.BLOCK_SIZE < C.B.OUTER_BOUNDS.top || y / C.BLOCK_SIZE > C.B.OUTER_BOUNDS.bottom)
				exists = false;
			else {
				var grid:Point = new Point(Math.floor((x + width / 2) / C.BLOCK_SIZE), 
										   Math.floor((y + height / 2) / C.BLOCK_SIZE));
				var mino:Mino = Mino.getGrid(grid.x, grid.y);
				if (mino != null && mino.exists && !mino.dead) {
					if (mino is Smino) {
						var smino:Smino = mino as Smino;
						if (smino.transmitsPower && smino.powered) {
							smino.station.mineralsMined += value;
							CollectText.collect(value);
						}
					} else if (mino is ResourceSource) {
						var resourceSource:ResourceSource = mino as ResourceSource;
						var mineralBlock:MineralBlock = resourceSource.resourceAt(grid);
						if (mineralBlock.type > MineralBlock.BEDROCK && mineralBlock.type < MineralBlock.TEAL_MINERALS)
							mineralBlock.type++;
						mino.newlyDamaged = true;
					}
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