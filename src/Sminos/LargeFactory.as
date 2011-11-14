package Sminos {
	import flash.geom.Point;
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class LargeFactory extends Launcher {
		
		public function LargeFactory(X:int, Y:int) {
			var blocks:Array = [new Block(0, 0),				 new Block(2, 0),
								new Block(0, 1),new Block(1, 1), new Block(2, 1),
								new Block(0, 2),				 new Block(2, 2)];
			powerReq = 150;
			crewReq = blocks.length;
			
			super(X, Y, blocks, new Point(2, 1), _sprite, _sprite_in);
			
			name = "Large Fabricator";
		}
		
		[Embed(source = "../../lib/art/sminos/lg_launch.png")] private static const _sprite:Class;
		[Embed(source = "../../lib/art/sminos/lg_launch_in.png")] private static const _sprite_in:Class;
		
	}

}