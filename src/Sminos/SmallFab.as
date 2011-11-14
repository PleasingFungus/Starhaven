package Sminos {
	import flash.geom.Point;
	/**
	 * ...
	 * @author ...
	 */
	public class SmallFab extends Launcher {
		
		public function SmallFab(X:int, Y:int) {
			var blocks:Array = [new Block(0, 0), new Block(1, 0),
								new Block(0, 1), 				];
			powerReq = 50;
			crewReq = blocks.length;
			
			super(X, Y, blocks, new Point(0, 0), _sprite, _sprite_in);
			
			name = "Small Fabricator";
		}
		
		[Embed(source = "../../lib/art/sminos/small_launch.png")] private static const _sprite:Class;
		[Embed(source = "../../lib/art/sminos/small_launch_in.png")] private static const _sprite_in:Class;
	}

}