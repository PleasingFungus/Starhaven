package Meteoroids {
	import org.flixel.*;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class SlowRocket extends FlxSprite {
		
		public var gridLoc:Point;
		public var semigridLoc:Point;
		public var target:Point;
		protected var gridVelocity:Point;
		public function SlowRocket(Origin:Point, Target:Point) {
			super()
			loadRotatedGraphic(_sprite);
			
			gridLoc = Origin.clone();
			semigridLoc = gridLoc.clone();
			target = Target;
			
			gridVelocity = target.subtract(gridLoc);
			gridVelocity.normalize(SPEED);
			angle = Math.atan2(gridVelocity.y, gridVelocity.x) * 180 / Math.PI;
			C.log("Slow Rocket: " + gridLoc, target, gridVelocity, angle); 
		}
		
		override public function update():void {
			super.update();
			move();
			checkCollide();
			checkBounds();
			checkTarget();
		}
		
		protected function move():void {
			semigridLoc.x += (gridVelocity.x / C.BLOCK_SIZE) * FlxG.elapsed;
			semigridLoc.y += (gridVelocity.y / C.BLOCK_SIZE) * FlxG.elapsed;
			gridLoc.x = Math.round(semigridLoc.x);
			gridLoc.y = Math.round(semigridLoc.y);
		}
		
		protected function checkCollide():void {
			for each (var mino:Mino in Mino.all_minos)
				if (mino.exists && mino.active && !mino.dead && mino.dangerous
					&& mino.intersectsPoint(gridLoc)) {
					explode();
					if (mino.dangerous)
						mino.takeExplodeDamage(gridLoc.x, gridLoc.y, null);
					break;
				}
		}
		
		protected function checkBounds():void {
			if (!exists) return;
			_flashRect2.x = gridLoc.x;
			_flashRect2.y = gridLoc.y;
			_flashRect2.width = 1;
			_flashRect2.height = 1;
			if (!C.B.OUTER_BOUNDS.containsRect(_flashRect2))
				explode();
		}
		
		protected function checkTarget():void {
			if (!exists) return;
			var delta:Point = target.subtract(gridLoc);
			if ((delta.x > 0) != (gridVelocity.x > 0) ||
				(delta.y > 0) != (gridVelocity.y > 0))
				explode();
		}
		
		protected function explode():void {
			Mino.layer.add(new KillCloud(gridLoc.x, gridLoc.y));
			exists = false;
		}
		
		override public function render():void {
			x = semigridLoc.x * C.BLOCK_SIZE;
			y = semigridLoc.y * C.BLOCK_SIZE;
			super.render();
		}
		
		override public function getScreenXY(point:FlxPoint=null):FlxPoint {
			point = super.getScreenXY(point);
			point.x += C.B.drawShift.x;
			point.y += C.B.drawShift.y;
			return point;
		}
		
		protected const SPEED:int = 200;
		
		[Embed(source = "../../lib/art/other/rocket_combat_2.png")] private static const _sprite:Class;
	}

}