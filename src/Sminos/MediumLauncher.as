package Sminos {
	import flash.geom.Point;
	import org.flixel.FlxU;
	/**
	 * ...
	 * @author ...
	 */
	public class MediumLauncher extends Launcher {
		
		public function MediumLauncher(X:int, Y:int) {
			var blocks:Array, center:Point, spr:Class, spr_in:Class;
			
			blocks = [new Block(0, 0), new Block(1, 0), new Block(2, 0),
					  new Block(0, 1),				    new Block(2, 1)];
			spr = _sprite;
			spr_in = _sprite_in;
			
			powerReq = 50;
			crewReq = blocks.length;
			
			super(X, Y, blocks, new Point(1, 0), spr, spr_in);
			
			name = "Launcher";
		}
		
		[Embed(source = "../../lib/art/sminos/med_launch.png")] private static const _sprite:Class;
		[Embed(source = "../../lib/art/sminos/med_launch_in.png")] private static const _sprite_in:Class;
		
	}

}