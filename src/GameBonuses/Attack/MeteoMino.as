package GameBonuses.Attack {
	import flash.geom.Point;
	import org.flixel.FlxG;
	import SFX.Pyrotechnic;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class MeteoMino extends Smino {
		
		protected var explosionRadius:int = 3;
		public function MeteoMino(X:int, Y:int) {
			var blocks:Array = [new Block(0, 0), new Block(1, 0),
								new Block(0, 1), new Block(1, 1)];
			super(X, Y, blocks, new Point(0, 0), 0xff8e4b35, 0xff8e4b35, _sprite);
			
			dangerous = true;
			cycleSpeed = 1.25;
			
			all_minos.push(this);
			name = "Attack Meteoroid";
		}
		
		override protected function executeCycle():void {
			super.executeCycle();
			if (exists) {
				if (C.fluid && C.fluid.intersect(this)) {
					C.sound.play(SPACE_EXPLODE_NOISE, 1); //would like a steam noise...
					explode(explosionRadius - 1);
					exists = false;
					for each (var block:Block in blocks) {
						var absBlock:Point = block.add(absoluteCenter);
						Mino.layer.add(new Pyrotechnic(absBlock.x, absBlock.y, UP, 0xbec0c0c0));
					}
				}
			}
		}
		
		override protected function anchorTo(target:Mino):void {			
			explode(explosionRadius);
			C.sound.play(GROUND_EXPLODE_NOISE, 0.75);
			exists = false;
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
		
		
		override protected function explode(radius:int):void {
			super.explode(radius);
			solid = false;
			dead = true;
		}
		
		override public function takeExplodeDamage(X:int, Y:int, Source:Mino):void {
			if (!dead)
				newlyDamaged = dead = true;
		}
		
		override protected function beDamaged():void {
			explode(explosionRadius);
			C.sound.play(SPACE_EXPLODE_NOISE, 1);
		}
		
		
		
		protected var fadeTimer:Number = 0;
		protected const FADE_TIME:Number = 0.5;
		override public function render():void {
			if (fadeTimer < FADE_TIME) {
				alpha = fadeTimer / FADE_TIME;
				fadeTimer += FlxG.elapsed;
			}
			
			super.render();
			
			//if (hasBeard)
				//renderBeard();
		}
		
		override protected function thrusterRender():void { } //don't do this!
		
		[Embed(source = "../../../lib/art/other/asteroid_agon.png")] private const _sprite:Class;
		[Embed(source = "../../../lib/sound/game/explosion_meteo_space.mp3")] protected const SPACE_EXPLODE_NOISE:Class;
		[Embed(source = "../../../lib/sound/game/explosion_meteo_ground.mp3")] protected const GROUND_EXPLODE_NOISE:Class;
	}

}