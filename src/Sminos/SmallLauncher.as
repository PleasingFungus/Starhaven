package Sminos {
	import flash.geom.Point;
	/**
	 * ...
	 * @author ...
	 */
	public class SmallLauncher extends Launcher {
		
		public function SmallLauncher(X:int, Y:int) {
			var blocks:Array, sprite:Class, inactiveSprite:Class, dangerSprite:Class;
			if (C.BEAM_DEFENSE) {
				blocks = [new Block(0, 0), new Block(1, 0),
						  new Block(0, 1)];
				sprite = _sprite;
				inactiveSprite = _sprite_in;
				dangerSprite = _sprite_danger;
				
			} else {
				blocks = [new Block(0, 0), new Block(1, 0),
						  new Block(0, 1), new Block(1, 1)];
				sprite = _sprite_2;
				inactiveSprite = _sprite_in_2;
				dangerSprite = _sprite_danger_2;
			}
			
			powerReq = 50;
			crewReq = blocks.length;
			
			super(X, Y, blocks, new Point(0, 0), sprite, inactiveSprite, dangerSprite);
			
			name = "Small Launcher";
		}
		
		[Embed(source = "../../lib/art/sminos/small_launch.png")] private static const _sprite:Class;
		[Embed(source = "../../lib/art/sminos/small_launch_in.png")] private static const _sprite_in:Class;
		[Embed(source = "../../lib/art/sminos/small_launch_danger.png")] private static const _sprite_danger:Class;
		
		[Embed(source = "../../lib/art/sminos/small_launch_2.png")] private static const _sprite_2:Class;
		[Embed(source = "../../lib/art/sminos/small_launch_in_2.png")] private static const _sprite_in_2:Class;
		[Embed(source = "../../lib/art/sminos/small_launch_danger_2.png")] private static const _sprite_danger_2:Class;
	}

}