package Meteoroids {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.flixel.*;
	import SFX.ExplosionSpark;
	
	/**
	 * ...
	 * @author azazoth
	 */
	public class CombatRocket extends FlxSprite{
		
		public var gridLoc:Point;
		public var semigridLoc:Point;
		public var gridVelocity:Point;
		public var gridAcceleration:Point;
		public var gridMaxVelocity:Number;
		public var gridAngle:Number;
		public var fuel:Number;
		protected var flame:FlxSprite;
		public function CombatRocket(Loc:Point, Direction:int) {
			super()
			loadRotatedGraphic(_sprite);
			//loadGraphic(_sprite);
			
			gridLoc = Loc.clone();
			semigridLoc = gridLoc.clone();
			
			if (Direction == LEFT) Direction = RIGHT;
			else if (Direction == RIGHT) Direction = LEFT;
			gridAngle = -Direction * Math.PI / 2;
			//frame = Math.floor((gridAngle / (2*Math.PI) + 0.75) * 16);
			
			gridVelocity = new Point(Math.cos(gridAngle) * ACCELERATION / 10, Math.sin(gridAngle) * ACCELERATION / 10);
			gridAcceleration = new Point;
			gridMaxVelocity = ACCELERATION / 3;
			fuel = 8;
		}
		
		override public function update():void {
			super.update();
			findTarget();
			move();
			checkCollide();
			checkBounds();
			checkExpiration();
		}
		
		protected function findTarget():void {
			var target:Mino = null;
			var closestDist:int = int.MAX_VALUE;
			for each (var mino:Mino in Mino.all_minos)
				if (mino.exists && mino.active && !mino.dead && mino.dangerous && !mino.outsideOuterBounds()) {
					var delta:Point = gridLoc.subtract(mino.gridLoc);
					var dist:int = Math.abs(Math.round(delta.length));
					if (dist < closestDist) {
						closestDist = dist;
						target = mino;
					}
				}
			
			if (target)
				angleTarget(target);
			else
				gridAcceleration.x = gridAcceleration.y = 0;
		}
		
		protected function simpleTarget(target:Mino):void {
			var delta:Point = target.gridLoc.subtract(gridLoc);
			delta.normalize(ACCELERATION);
			gridAcceleration = delta;
			gridAngle = Math.atan2(delta.y, delta.x);
		}
		
		protected function anticipateTarget(target:Mino):void {
			var currentDelta:Point = target.gridLoc.subtract(gridLoc);
			var dirVec:Point = (target as Meteoroid).dirVec;
			
			var effectiveDist:Number = Math.abs(currentDelta.length);
			effectiveDist += Math.abs(Math.sin(C.innerAngle(gridVelocity, dirVec)) * gridVelocity.length);
			var dt:Number = effectiveDist * 10 / ACCELERATION;
			
			dirVec.x *= dt;
			dirVec.y *= dt;
			var anticipatedPos:Point = target.gridLoc.add(dirVec);
			
			var delta:Point = anticipatedPos.subtract(gridLoc);
			delta.normalize(ACCELERATION);
			gridAcceleration = delta;
			gridAngle = Math.atan2(delta.y, delta.x);
		}
		
		protected function angleTarget(target:Mino):void {
			var delta:Point = target.gridLoc.subtract(gridLoc);
			var angleTo:Number = Math.atan2(delta.y, delta.x);
			var deltaAngle:Number = angleTo - gridAngle;
			var absDelta:Number = Math.abs(deltaAngle);
			if (absDelta >= Math.PI)
				absDelta = Math.PI * 2 - absDelta;
			var turn:Number = TURN * FlxG.elapsed;
			
			if (absDelta <= turn)
				gridAngle = angleTo;
			else {
				if (deltaAngle < -Math.PI)
					deltaAngle += Math.PI * 2;
				else if (deltaAngle > Math.PI)
					deltaAngle -= Math.PI * 2;
				
				if (deltaAngle > 0)
					gridAngle += turn;
				else
					gridAngle -= turn;
			}
			
			absDelta -= turn;
			
			var accel:Number;
			if (absDelta >= Math.PI / 3)
				accel = 0;
			//else if (absDelta > 0)
				//accel = ACCELERATION * Math.cos(absDelta * 2);
			else
				accel = ACCELERATION;
			
			//gridAcceleration.x = Math.cos(gridAngle) * accel;
			//gridAcceleration.y = Math.sin(gridAngle) * accel;
			if (accel) {
				gridVelocity.x = Math.cos(gridAngle) * accel * 0.75; //slowdown for direct-velocity nonsense
				gridVelocity.y = Math.sin(gridAngle) * accel * 0.75;
				gridAcceleration.x = gridAcceleration.y = 0;
			}
		}
		
		
		
		
		protected function move():void {
			gridVelocity.x += gridAcceleration.x * FlxG.elapsed;
			gridVelocity.y += gridAcceleration.y * FlxG.elapsed;
			if (Math.abs(gridVelocity.length) > gridMaxVelocity)
				gridVelocity.normalize(gridMaxVelocity);
			semigridLoc.x += gridVelocity.x * FlxG.elapsed;
			semigridLoc.y += gridVelocity.y * FlxG.elapsed;
			gridLoc.x = Math.round(semigridLoc.x);
			gridLoc.y = Math.round(semigridLoc.y);
		}
		
		protected function checkCollide():void {
			for each (var mino:Mino in Mino.all_minos)
				if (mino.exists && mino.active && !mino.dead && mino.dangerous && mino != C.fluid;
					&& mino.intersectsPoint(gridLoc)) {
					explode();
					break;
				}
		}
		
		protected function checkExpiration():void {
			fuel -= FlxG.elapsed;
			if (fuel < 0 || !Scenario.dangeresque)
				explode();
		}
		
		protected function explode():void {
			var explosionOrigin:Point = gridLoc;
			var radius:int = 1;
			for (var X:int = explosionOrigin.x - radius; X <= explosionOrigin.x + radius; X++)
				for (var Y:int = explosionOrigin.y - radius; Y <= explosionOrigin.y + radius; Y++)
					if (Math.abs(X - explosionOrigin.x) + Math.abs(Y - explosionOrigin.y) <= radius) {
					//if (Math.sqrt((X - explosionOrigin.x) * (X - explosionOrigin.x) + (Y - explosionOrigin.y) * (Y - explosionOrigin.y)) <= radius) {
						var victim:Mino = getVictim(X, Y);
						if (victim)
							victim.takeExplodeDamage(X, Y, null);
						Mino.layer.add(new ExplosionSpark(X, Y));
					}
			
			exists = false;
			dead = true;
		}
		
		protected function getVictim(X:int, Y:int):Mino {
			for each (var mino:Mino in Mino.all_minos)
				if (mino.exists && mino.active && !mino.dead && mino.dangerous
					&& mino.intersectsPoint(new Point(X, Y)))
					return mino;
			return null;
		}
		
		protected function checkBounds():void {
			_flashRect2.x = gridLoc.x;
			_flashRect2.y = gridLoc.y;
			_flashRect2.width = 1;
			_flashRect2.height = 1;
			if (!C.B.OUTER_BOUNDS.containsRect(_flashRect2))
				explode();
		}
		
		override public function render():void {
			x = semigridLoc.x * C.BLOCK_SIZE;
			y = semigridLoc.y * C.BLOCK_SIZE;
			angle = gridAngle * 180 / Math.PI;
			super.render();
		}
		
		override public function getScreenXY(point:FlxPoint=null):FlxPoint {
			point = super.getScreenXY(point);
			point.x += C.B.drawShift.x;
			point.y += C.B.drawShift.y;
			return point;
		}
		
		protected const ACCELERATION:Number = 70;
		protected const TURN:Number = Math.PI * 0.5;
		
		[Embed(source = "../../lib/art/other/rocket_combat.png")] private static const _sprite:Class;
	}

}