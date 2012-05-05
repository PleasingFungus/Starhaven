package Sminos {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.flixel.*;
	import SFX.RailgunShot;
	import SFX.Pyrotechnic;
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class AsteroidGun extends Smino {
		
		protected var charge:Number = 0;
		protected var chargeTime:Number = 1.4;
		protected var range:int = 20;
		
		protected var shot:RailgunShot;
		protected var shotTimer:Number = 0;
		protected var flashTime:Number = 1;
		
		public var target:Mino = null;
		protected var losToTarget:Boolean;
		
		protected var debugFiringArea:FlxSprite;
		
		public function AsteroidGun(X:int, Y:int) {
			var blocks:Array = [new Block(0, 0), new Block(1, 0), new Block(2, 0),
												 new Block(1, 1)];
			
			crewReq = 2;
			powerReq = 100;
			
			super(X, Y, blocks, new Point(1, 1), 0xff6b2020, 0xffb32828, _sprite, _sprite_in);
			
			name = "Defense Beam";
			description = "Defense Beams shoot down dangerous incoming meteoroids! Crew and power them, point them outward and keep their fields of fire clear for best effect.";			
			shot = new RailgunShot(gridLoc.clone(), new Point(gridLoc.x + 1, gridLoc.y), this); //harmless, won't render
			if (C.DEBUG && C.DISPLAY_FIRE_AREA)
				generateDebugFiringArea();
		}
		
		
		private function generateDebugFiringArea():void {
			var fa:Rectangle = getFieldOfFire();
			debugFiringArea = new FlxSprite(fa.x * C.BLOCK_SIZE + C.B.drawShift.x - 1,
											fa.y * C.BLOCK_SIZE + C.B.drawShift.y - 1);
			debugFiringArea.createGraphic(fa.width * C.BLOCK_SIZE + 2, fa.height * C.BLOCK_SIZE + 2, 0xafff0000);
			debugFiringArea.pixels.fillRect(new Rectangle(1, 1,
													   debugFiringArea.width - 2, debugFiringArea.height - 2), 0xff000000);
		}
		
		
		
		override protected function rotate(clockwise:Boolean):void {
			super.rotate(clockwise);
			shot.alpha = 0;
			
			if (C.DEBUG && C.DISPLAY_FIRE_AREA)
				generateDebugFiringArea();
		}
		
		
		override public function update():void {
			if (operational) {
				if (target && losToTarget)
					checkTarget();
				
				if (shotTimer <= 0 && !(target && losToTarget))
					targetSeek();
				
				if (target) {
					chargeUp();
					
					if (charge == 1 && target && losToTarget)
						fireOn(target);
				} else {
					charge = 0;
					//ISweepMyLaserBackAndForth();
				}
			}
			
			super.update();
			updateShot();
		}
		
		protected function checkTarget():void {
			if (target.dead) {
				target = null;
				return;
			}
			
			losToTarget = lineOfFire(target);
		}
		
		protected function targetSeek():void {
			target = null;
			var closestDist:int = int.MAX_VALUE;
			
			for each (var mino:Mino in all_minos)
				if (mino.exists && !mino.dead && mino.dangerous) {
					var delta:Point = gridLoc.subtract(mino.targetCenter);
					if (delta.length > range)
						continue; //out of range!
					
					if (Math.floor(delta.length) > closestDist)
						continue; //already found someone closer!
					
					if (!inFieldOfFire(delta))
						continue; //target is behind you!
					
					target = mino; //found someone!
					
					losToTarget = lineOfFire(target); //real target!
					if (losToTarget)
						closestDist = delta.length; //look for someone closer
				}
		}
		
		protected function lineOfFire(mino:Mino):Boolean {
			shot.pointTo(mino.targetCenter, gridLoc);
			var intersects:Boolean = shot.truncateToIntersection();
			return !intersects;
		}
		
		protected function chargeUp():void {
			if (charge < 1)
				charge += FlxG.elapsed / chargeTime;
			if (charge > 1)
				charge = 1;
		}
		
		protected function fireOn(mino:Mino):void {
			var intersect:Point = shot.findIntersect(target);
			explodeTarget(intersect, 1, target);
			
			charge = 0;
			target = null;
			losToTarget = false;
			
			shotTimer = flashTime;
			shot.alpha = 1;
		}
		
		protected function explodeTarget(explosionOrigin:Point, radius:int, target:Mino):void {
			for (var X:int = explosionOrigin.x - radius; X <= explosionOrigin.x + radius; X++)
				for (var Y:int = explosionOrigin.y - radius; Y <= explosionOrigin.y + radius; Y++)
					if (Math.abs(X - explosionOrigin.x) + Math.abs(Y - explosionOrigin.y) <= radius)
						target.takeExplodeDamage(X, Y, this);
			
			for (var i:int = 0; i < 4; i++)
				FlxG.state.add(new Pyrotechnic(explosionOrigin.x, explosionOrigin.y, i));
		}
		
		protected function updateShot():void {
			if (!operational)
				shot.alpha = 0;
			else if (shotTimer > 0)
				shotTimer -= FlxG.elapsed;
			else if (target && !target.dead)
				shot.alpha = charge * .5 + .1;
			else
				shot.alpha = 0;
		}
		
		
		
		
		
		
		
		
		
		override public function render():void {
			if (debugFiringArea)
				debugFiringArea.render();
			
			super.render();
		}
		
		override public function renderTop(force:Boolean = false):void {
			super.renderTop();
			if (shot && Scenario.substate != Scenario.SUBSTATE_ROTPAUSE && exists)
				shot.render();
		}
		
		
		
		
		
		protected function inFieldOfFire(delta:Point):Boolean {
			
			switch (facing) {
				case LEFT: return delta.x >= 0;
				case UP: return delta.y >= 0;
				case RIGHT: return delta.x <= 0;
				case DOWN:  return delta.y <= 0;
			}
			
			return true;
		}
		
		public function getFieldOfFire():Rectangle {
			var field:Rectangle = new Rectangle();
			
			switch (facing & 3) {
				default: C.log("Invalid turret facing!");
						return null;
				case RIGHT:
					field.x = bounds.left;
					field.y = C.B.PlayArea.top;
					field.width = C.B.PlayArea.right - field.x;
					field.height = C.B.PlayArea.height;
					break;
				case UP:
					field.x = C.B.PlayArea.left;
					field.y = bounds.top;
					field.width = C.B.PlayArea.width;
					field.height = C.B.PlayArea.bottom - field.y;
					break;
				case LEFT:
					field.x = bounds.right;
					field.y = C.B.PlayArea.top;
					field.width = field.x - C.B.PlayArea.left;
					field.height = C.B.PlayArea.height;
					break;
				case DOWN:
					field.x = C.B.PlayArea.left;
					field.y = bounds.bottom;
					field.width = C.B.PlayArea.width;
					field.height = field.y - C.B.PlayArea.top;
					break;
			}
			
			return field;
		}
		
		[Embed(source = "../../lib/art/sminos/agun.png")] private static const _sprite:Class;
		[Embed(source = "../../lib/art/sminos/agun_in.png")] private static const _sprite_in:Class;
		[Embed(source = "../../lib/sound/vo/agun.mp3")] public static const _desc:Class;
		
		
		
		
		/*protected var sweepAngle:Number = 0;
		protected var sweepDirection:int = Math.PI;
		protected var sweepPeriod:Number = 3;
		protected function ISweepMyLaserBackAndForth():void {
			var adjustedAngle:Number = sweepAngle - (facing + 1) * Math.PI / 2;
			var range:int = 8;
			var sweepTarget:Point = new Point(gridLoc.x - center.x + Math.cos(adjustedAngle) * range,
											  gridLoc.y - center.y + Math.sin(adjustedAngle) * range);
			shot.pointTo(sweepTarget, gridLoc);
			shot.truncateToIntersection();
			
			sweepAngle += sweepDirection * FlxG.elapsed / sweepPeriod;
			if (sweepAngle < 0) {
				sweepAngle = 0;
				sweepDirection *= -1;
			} else if (sweepAngle > Math.PI) {
				sweepAngle = Math.PI;
				sweepDirection *= -1;
			}
		}*/
	}

}