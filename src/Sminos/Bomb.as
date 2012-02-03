package Sminos {
	import Controls.ControlSet;
	import flash.geom.Point;
	/**
	 * ...
	 * @author ...
	 */
	public class Bomb extends Smino {
		
		protected var radius:int = 3;
		protected var shroud:Mino;
		public var uncle:Smino;
		public function Bomb(Parent:Smino) {
			uncle = Parent;
			super(uncle.absoluteCenter.x, uncle.absoluteCenter.y, [new Block], new Point, 0xff201818, 0xff403030, _sprite, _sprite);
			description = "Bombs explode when you press "+ControlSet.BOMB_KEY+" or on impact. Use them to expose buried mineral pockets!";
			audioDescription = _desc;
			genResourceShroud();
		}
		
		protected function genResourceShroud():void {
			var blocks:Array = [];
			var r2:int = radius * radius;
			for (var X:int = -radius; X <= radius; X++)
				for (var Y:int = - radius; Y <= radius; Y++)
					if (X*X + Y*Y <= r2)
						blocks.push(new Block(X, Y));
			
			shroud = new Mino(gridLoc.x, gridLoc.y, blocks, new Point, 0xffffffff);
			
			shroud.gridLoc = gridLoc;
			shroud.alpha = 1/4;
		}
		
		override public function renderTop(force:Boolean = false):void {
			if (exists && !dead && C.HUD_ENABLED)
				shroud.render();
		}
		
		override protected function anchorTo(Parent:Aggregate):void {
			explode(radius);
		}
		
		public function manuallyDetonate():void {
			explode(radius);
		}
		
		[Embed(source = "../../lib/art/sminos/bomb.png")] private static const _sprite:Class;
		[Embed(source = "../../lib/sound/vo/bombs.mp3")] public static const _desc:Class;
	}

}