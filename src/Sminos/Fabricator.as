package Sminos {
	import flash.geom.Point;
	import org.flixel.FlxU;
	/**
	 * ...
	 * @author ...
	 */
	public class Fabricator extends Launcher {
		
		public function Fabricator(X:int, Y:int) {
			var blocks:Array, center:Point, spr:Class, spr_in:Class;
			if (FlxU.random() > 0.5) {
				blocks = [new Block(0, 0), new Block(1, 0), new Block(2, 0),
						  new Block(0, 1), 					new Block(2, 1)];
				center = new Point(1, 0);
				spr = _sprite;
				spr_in = _sprite_in;
			} else {
				blocks = [									new Block(2, 0),
						  new Block(0, 1), new Block(1, 1), new Block(2, 1),
															new Block(2, 2)];
				center = new Point(1, 1);
				spr = _sprite_2;
				spr_in = _sprite_2_in;
			}
			powerReq = 50;
			crewReq = blocks.length;
			
			super(X, Y, blocks, center, spr, spr_in);
			
			name = "Launcher";
			description = "When fully crewed and powered, Launchers send minerals you've gathered back to your home base (score!)!";
		}
		
		[Embed(source = "../../lib/art/sminos/med_launch.png")] private static const _sprite:Class;
		[Embed(source = "../../lib/art/sminos/med_launch_in.png")] private static const _sprite_in:Class;
		[Embed(source = "../../lib/art/sminos/med_launch_2.png")] private static const _sprite_2:Class;
		[Embed(source = "../../lib/art/sminos/med_launch_2_in.png")] private static const _sprite_2_in:Class;
		
	}

}