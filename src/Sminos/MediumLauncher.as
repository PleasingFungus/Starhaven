package Sminos {
	import flash.geom.Point;
	import org.flixel.FlxU;
	/**
	 * ...
	 * @author ...
	 */
	public class MediumLauncher extends Launcher {
		
		public function MediumLauncher(X:int, Y:int) {
			var blocks:Array, center:Point, spr:Class, spr_in:Class, spr_d:Class;
			if (C.BEAM_DEFENSE) {
				blocks = [new Block(0, 0), new Block(1, 0), new Block(2, 0),
						  new Block(0, 1), 					new Block(2, 1)];
				spr = _sprite;
				spr_in = _sprite_in;
				spr_d = _sprite_danger;
			} else {
				blocks = [new Block(0, 0), new Block(1, 0), new Block(2, 0),
						  new Block(0, 1), new Block(1, 1), new Block(2, 1)];
				spr = _sprite_2;
				spr_in = _sprite_in_2;
				spr_d = _sprite_danger_2;
			}
			powerReq = 50;
			crewReq = blocks.length;
			
			super(X, Y, blocks, new Point(1, 0), spr, spr_in, spr_d);
			
			name = "Launcher";
		}
		
		[Embed(source = "../../lib/art/sminos/med_launch.png")] private static const _sprite:Class;
		[Embed(source = "../../lib/art/sminos/med_launch_in.png")] private static const _sprite_in:Class;
		[Embed(source = "../../lib/art/sminos/med_launch_danger.png")] private static const _sprite_danger:Class;
		//[Embed(source = "../../lib/art/sminos/med_launch_2.png")] private static const _sprite_2:Class;
		//[Embed(source = "../../lib/art/sminos/med_launch_2_in.png")] private static const _sprite_2_in:Class;
		//[Embed(source = "../../lib/art/sminos/med_launch_2_danger.png")] private static const _sprite_2_danger:Class;
		
		[Embed(source = "../../lib/art/sminos/med_launch_3.png")] private static const _sprite_2:Class;
		[Embed(source = "../../lib/art/sminos/med_launch_in_3.png")] private static const _sprite_in_2:Class;
		[Embed(source = "../../lib/art/sminos/med_launch_danger_3.png")] private static const _sprite_danger_2:Class;
		
	}

}