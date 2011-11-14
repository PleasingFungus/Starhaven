package Asteroids {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	import org.flixel.FlxG;
	import SFX.Pyrotechnic;
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class Asteroid extends Mino {
		
		protected var semigridLoc:Point;
		protected var target:Point;
		protected var direction:Point;
		protected var rotation:int;
		protected var explosionRadius:int = 3;
		public function Asteroid(X:int, Y:int, Target:Point = null) {
			var blocks:Array = [new Block(0, 0), new Block(1, 0),
								new Block(0, 1), new Block(1, 1)];
			super(X, Y, blocks, new Point(0, 0), 0xff8e4b35, _sprite);
			dangerous = true;
			cycleSpeed = 1 / period;
			
			semigridLoc = new Point(gridLoc.x, gridLoc.y);
			if (!Target)
				Target = new Point;
			target = Target;
			direction = new Point(Target.x - gridLoc.x, Target.y - gridLoc.y);
			direction.normalize(1);
			
			rotation = FlxU.random() * 3;
			
			all_minos.push(this);
			name = "Asteroid";
		}
		
		override protected function executeCycle():void {
			semigridLoc.x += direction.x;
			semigridLoc.y += direction.y;
			gridLoc.x = Math.floor(semigridLoc.x);
			gridLoc.y = Math.floor(semigridLoc.y);
			
			if (outsideOuterBounds() && gridLoc.x * direction.x >= 0 && gridLoc.y * direction.y >= 0) {
				dead = true;
				exists = false;
				return;
			}
			
			var hit:Mino = intersects();
			if (hit) {
				explode(explosionRadius);
				exists = false;
			}
			
			if (C.fluid && C.fluid.intersect(this)) {
				explode(explosionRadius - 1);
				exists = false;
				for each (var block:Block in blocks) {
					var absBlock:Point = block.add(absoluteCenter);
					Mino.layer.add(new Pyrotechnic(absBlock.x, absBlock.y, UP, 0xbec0c0c0));
				}
			}
		}
		
		override public function intersects():Mino {
			for each (var block:Block in blocks) {
				var adjustedBlock:Point = block.add(absoluteCenter);
				if (C.B.OUTER_BOUNDS.containsPoint(adjustedBlock)) {
					var inGrid:Mino = Mino.getGrid(adjustedBlock.x, adjustedBlock.y);
					if (canIntersect(inGrid))
						return inGrid;
				}
			}
			
			return null;
		}
		
		protected var fadeTimer:Number = 0;
		protected const FADE_TIME:Number = 0.5;
		override public function render():void {
			if (fadeTimer < FADE_TIME) {
				alpha = fadeTimer / FADE_TIME;
				fadeTimer += FlxG.elapsed;
			}
			
			super.render();
			
			if (outsidePlayArea() || (C.DEBUG && C.ALWAYS_SHOW_INCOMING))
				renderWarning();
		}
		
		protected function renderWarning():void {
			var Color:uint = color;
			color = 0xff0000;
			alpha = .75;
			
			var intercept:Point = new Point(target.x - direction.x * C.B.HALFWIDTH, target.y - direction.y * C.B.HALFHEIGHT);
			
			x = (intercept.x - center.x - blockDim.x/2) * C.BLOCK_SIZE;
			y = (intercept.y - center.y - blockDim.y/2) * C.BLOCK_SIZE;
			forceRender();
			
			alpha = 1;
			color = Color;
		}
		
		override protected function explode(radius:int):void {
			super.explode(radius);
			solid = false;
			dead = true;
		}
		
		
		override public function takeExplodeDamage(X:int, Y:int, Source:Mino):void {
			if (!dead)
				newlyDamaged = true;
		}
		
		override protected function beDamaged():void {
			explode(1);
			for (var i:int = 0; i < 4; i++)
				Mino.layer.add(new AsteroidCrystal(absoluteCenter.x, absoluteCenter.y, target));
		}
		
		public static function get period():Number {
			return 1 / 3;
		}
		
		[Embed(source = "../../lib/art/other/asteroid_agon.png")] private static const _sprite:Class;
		//[Embed(source = "../../lib/art/other/silly_asteroid_warning.png")] private static const _warning_sprite:Class;
	}

}