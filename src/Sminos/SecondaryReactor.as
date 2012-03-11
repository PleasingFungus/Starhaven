package Sminos {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import SFX.Fader;
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class SecondaryReactor extends PowerGen {
		
		public var blastRadius:int = 4;
		public function SecondaryReactor(X:int, Y:int) {
			var blocks:Array = [new Block(0, 0), new Block(1, 0), new Block(2, 0),
							    new Block(0, 1), new Block(1, 1), new Block(2, 1),
								new Block(0, 2), new Block(1, 2), new Block(2, 2)];
			super(X, Y, blocks, new Point(2, 0), 600, 0, _sprite, _sprite_in);
			name = "Secondary Reactor";
			description = "Secondary Reactors produce a large amount of power, but beware: if struck, they explode violently!";
		}
		
		override public function takeExplodeDamage(X:int, Y:int, Source:Mino):void {
			damaged = dead = newlyDamaged = true;
			damagedBy = Source;
		}
		
		override protected function beDamaged():void {
			super.beDamaged();
			explode(blastRadius);
		}
		
		[Embed(source = "../../lib/art/sminos/secrec.png")] private static const _sprite:Class;
		[Embed(source = "../../lib/art/sminos/secrec_in.png")] private static const _sprite_in:Class;
	}

}