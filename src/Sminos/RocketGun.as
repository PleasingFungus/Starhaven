package Sminos {
	import flash.geom.Point;
	import Meteoroids.SlowRocket;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	import SFX.RocketGunTracer;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class RocketGun extends Smino {
		
		protected var rocketsLoaded:int;
		protected var rocketCapacity:int;
		protected var combatRocket:FlxSprite;
		protected var tracer:RocketGunTracer;
		public function RocketGun(X:int, Y:int) {
			var blocks:Array = [new Block(0, 0), new Block(1, 0), new Block(2, 0),
												 new Block(1, 1)];
			
			crewReq = 1;
			powerReq = 100;
			
			super(X, Y, blocks, new Point(1, 1), 0xff6b2020, 0xffb32828, _sprite, _sprite_in);
			rocketCapacity = blocks.length;
			
			name = "Rocket Gun";
			description = "Rocket Guns shoot down dangerous incoming meteoroids! Crew and power them, point them outward and keep their fields of fire clear for best effect.";
			audioDescription = _desc;
			
			tracer = new RocketGunTracer(this);
			tracer.visible = false;
		}
		
		public function loadRockets():void {
			rocketsLoaded = rocketCapacity;
		}
		
		public function unloadRockets():void {
			rocketsLoaded = 0;
		}
		
		public function aimAt(target:Point):void {
			tracer.pointTo(target, fireOrigin);
			tracer.truncateToIntersection();
			tracer.visible = true;
		}
		
		public function canFireOn(target:Point, checkForBlock:Boolean = false):Boolean {
			if (!exists || !operational || !rocketsLoaded)
				return false;
			
			if (!withinArc(target))
				return false;
			
			if (checkForBlock) {
				tracer.pointTo(target, fireOrigin);
				if (tracer.intersects())
					return false;
			}
			
			return true;
		}
		
		protected function withinArc(target:Point):Boolean {
			var delta:Point = target.subtract(fireOrigin);
			var angle:Number = Math.atan2(delta.y, delta.x);
			angle -= Math.PI / 2; //offset segments by 90 degrees
			if (angle < 0) angle = angle + Math.PI * 2;
			var segment:int = Math.floor(angle / (Math.PI / 2));
			return segment == facing || segment == ((facing + 1) & 3);
		}
		
		public function fireOn(target:Point, useAmmo:Boolean = true):void {
			if (useAmmo)
				rocketsLoaded--;
			Mino.layer.add(new SlowRocket(fireOrigin, target, this));
			C.sound.play(LAUNCH_NOISES[int(FlxU.random() * LAUNCH_NOISES.length)], 0.5);
		}
		
		public function get fireOrigin():Point {
			return absoluteCenter.add(blocks[blocks.length - 1]);
		}
		
		override public function renderTop(_:Boolean, force:Boolean = false):void {
			super.renderTop(_, force);
			if (tracer.visible) {
				tracer.render();
				tracer.visible = false;
			}
		}
		
		override protected function renderSupply():void {			
			if (!combatRocket)
				combatRocket = new FlxSprite().loadRotatedGraphic(_combat_rocket_sprite, 4);
			combatRocket.frame = (facing + 2) & 3;
			renderOnBlocks(combatRocket, rocketsLoaded);
			
			super.renderSupply();
		}
		
		protected function renderOnBlocks(sprite:FlxSprite, number:int):void {
			var absCenter:Point = absoluteCenter;
			for (var i:int = 0; i < number; i++ ) {
				var block:Point = absCenter.add(blocks[blocks.length - i - 1]);
				sprite.x = block.x * C.BLOCK_SIZE + C.B.drawShift.x;
				sprite.y = block.y * C.BLOCK_SIZE + C.B.drawShift.y;
				sprite.render();
			}
		}
		
		
		[Embed(source = "../../lib/art/sminos/agun.png")] private static const _sprite:Class;
		[Embed(source = "../../lib/art/sminos/agun_in.png")] private static const _sprite_in:Class;
		[Embed(source = "../../lib/sound/vo/agun.mp3")] public static const _desc:Class;
		[Embed(source = "../../lib/art/other/rocket_combat_unlit_3.png")] private static const _combat_rocket_sprite:Class;
		[Embed(source = "../../lib/sound/game/rocket_gun_1.mp3")] protected const _LAUNCH_NOISE_1:Class;
		[Embed(source = "../../lib/sound/game/rocket_gun_2.mp3")] protected const _LAUNCH_NOISE_2:Class;
		protected const LAUNCH_NOISES:Array = [_LAUNCH_NOISE_1, _LAUNCH_NOISE_2];
	}

}