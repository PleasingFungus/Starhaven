package GameBonuses.Collect.Sminos {
	import flash.geom.Point;
	import Sminos.Launcher;
	/**
	 * ...
	 * @author ...
	 */
	public class SmallLauncherC extends Launcher {
		
		public function SmallLauncherC(X:int, Y:int) {
			var blocks:Array, sprite:Class, inactiveSprite:Class;
			
			blocks = [new Block(0, 0), new Block(1, 0),
					  new Block(0, 1), new Block(1, 1)];
			sprite = _sprite;
			inactiveSprite = _sprite_in;
			
			powerReq = 50;
			crewReq = blocks.length;
			
			super(X, Y, blocks, new Point(0, 0), sprite, inactiveSprite);
			
			name = "Small Launcher-C";
		}
		
		[Embed(source = "../../../../lib/art/sminos/small_launch_2.png")] private static const _sprite:Class;
		[Embed(source = "../../../../lib/art/sminos/small_launch_in_2.png")] private static const _sprite_in:Class;
	}

}