package Meteoroids {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.flixel.FlxSave;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	import org.flixel.FlxG;
	import SFX.Pyrotechnic;
	import Icons.IconLeech;
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class Meteoroid extends Mino {
		
		protected var semigridLoc:Point;
		protected var target:Point;
		protected var direction:Point;
		protected var rotation:int;
		protected var explosionRadius:int = 3;
		public function Meteoroid(X:int, Y:int, Target:Point = null, speedFactor:Number = 1) {
			var blocks:Array = [new Block(0, 0), new Block(1, 0),
								new Block(0, 1), new Block(1, 1)];
			super(X, Y, blocks, new Point(0, 0), 0xff8e4b35, _sprite);
			dangerous = true;
			cycleSpeed = speedFactor / period;
			
			semigridLoc = new Point(gridLoc.x, gridLoc.y);
			if (!Target)
				Target = new Point;
			target = Target;
			direction = new Point(Target.x - gridLoc.x, Target.y - gridLoc.y);
			direction.normalize(1);
			
			rotation = FlxU.random() * 3;
			C.hudLayer.add(new IconLeech(null, renderTop));
			setupWarning();
			
			all_minos.push(this);
			name = "Meteoroid";
		}
		
		override protected function executeCycle():void {
			semigridLoc.x += direction.x * C.difficulty.meteoroidSpeedFactor;
			semigridLoc.y += direction.y * C.difficulty.meteoroidSpeedFactor;
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
				C.sound.play(GROUND_EXPLODE_NOISE, 0.75);
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
			
			//C.log("Meteoroid @" + gridLoc, exists, active, !dead, dangerous);
		}
		
		public function get dirVec():Point {
			var cycleFreq:Number = C.CYCLE_TIME * cycleSpeed;
			var dvec:Point = direction.clone();
			dvec.x /= cycleFreq;
			dvec.y /= cycleFreq;
			return dvec;
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
		
		override public function canIntersect(other:Mino):Boolean {
			return super.canIntersect(other) && other != C.fluid;
		}
		
		protected var fadeTimer:Number = 0;
		protected const FADE_TIME:Number = 0.5;
		override public function render():void {
			if (fadeTimer < FADE_TIME) {
				alpha = fadeTimer / FADE_TIME;
				fadeTimer += FlxG.elapsed;
			}
			
			super.render();
			
			//if (outsideScreenArea() || (C.DEBUG && C.ALWAYS_SHOW_INCOMING))
				//renderWarning();
		}
		
		override public function renderTop(force:Boolean = false):void {
			if (!exists)
				return;
			else if (/*outsideScreenArea() || */(C.DEBUG && C.ALWAYS_SHOW_INCOMING) || !visible)
				renderWarning();
		}
		
		protected var warningSprite:FlxSprite;
		protected function setupWarning():void {
			warningSprite = new FlxSprite().loadGraphic(_warning_sprite);
		}
		
		protected var warningPulseTimer:Number = 0;
		protected var warningPulseUp:Boolean = false;
		protected const WARNING_PULSE_PERIOD:Number = 0.4;
		protected function renderWarning():void {
			var screenLoc:Point = C.B.blocksToScreen(gridLoc.x, gridLoc.y);
			var screenCenter:Point = C.B.blocksToScreen(target.x, target.y);
			var screenDelta:Point = screenCenter.subtract(screenLoc);
			var angleToScreen:Number = Math.atan2(screenDelta.y, screenDelta.x);
			
			warningSprite.angle = angleToScreen * 180 / Math.PI;
			
			var margin:int = 10;
			//var adjustedAngle:Number = angleToScreen;
			//if (adjustedAngle < 0) adjustedAngle += Math.PI * 2;
			//var side:int = Math.floor((adjustedAngle + Math.PI / 4) / (Math.PI * 2)) % 4;
			//adjustedAngle -= Math.PI / 4 + side * Math.PI * 2;
			//var warnX:int, warnY:int;
			//
			//switch (side) {
				//case 0:
					//warnX = margin;
					//warnY = Math.tan(adjustedAngle) * -FlxG.width / 2;
					//break;
				//case 1:
					//warnY = margin;
					//warnX = Math.tan(adjustedAngle) * -FlxG.height / 2;
					//break;
				//case 2:
					//warnX = FlxG.width - (margin + warningSprite.width);
					//warnY = Math.tan(adjustedAngle) * FlxG.width / 2;
					//break;
				//case 3:
					//warnY = FlxG.height - (margin + warningSprite.height);
					//warnX = Math.tan(adjustedAngle) * FlxG.height / 2;
					//break;
			//}
			
			var warnX:int = (Math.cos(Math.PI + angleToScreen) + 1) * (FlxG.width - margin*2);
			var warnY:int = (Math.sin(Math.PI + angleToScreen) + 1) * (FlxG.height - margin*2);
			
			warningSprite.x = warnX * C.B.scale;
			warningSprite.y = warnY * C.B.scale;
			
			if (warningPulseUp)
				warningSprite.alpha = 0.5 + 0.5 * warningPulseTimer / WARNING_PULSE_PERIOD;
			else
				warningSprite.alpha = 1 - 0.5 * warningPulseTimer / WARNING_PULSE_PERIOD;
			warningPulseTimer += FlxG.elapsed;
			if (warningPulseTimer >= WARNING_PULSE_PERIOD) {
				warningPulseTimer -= WARNING_PULSE_PERIOD;
				warningPulseUp = !warningPulseUp;
			}
			warningSprite.render();
		}
		
		override protected function explode(radius:int):void {
			super.explode(radius);
			solid = false;
			dead = true;
		}
		
		
		override public function takeExplodeDamage(X:int, Y:int, Source:Mino):void {
			if (!dead) {
				newlyDamaged = dead = true;
				MeteoroidTracker.kills++;
			}
		}
		
		override protected function beDamaged():void {
			explode(1);
			C.sound.play(SPACE_EXPLODE_NOISE, 1);
			var crystalNum:int = 2;
			if (!C.IN_TUTORIAL)
				for (var i:int = 0; i < crystalNum; i++)
					Mino.layer.add(new MeteoroidCrystal(absoluteCenter.x, absoluteCenter.y, target));
		}
		
		public static function get period():Number {
			return 1 / 3;
		}
		
		[Embed(source = "../../lib/art/other/asteroid_agon.png")] private static const _sprite:Class;
		[Embed(source = "../../lib/art/other/arrow.png")] private static const _warning_sprite:Class;
		[Embed(source = "../../lib/sound/game/explosion_meteo_space.mp3")] protected const SPACE_EXPLODE_NOISE:Class;
		[Embed(source = "../../lib/sound/game/explosion_meteo_ground.mp3")] protected const GROUND_EXPLODE_NOISE:Class;
	}

}