package GameBonuses.Collect.Sminos {
	import flash.geom.Point;
	import org.flixel.FlxU;
	import Sminos.Launcher;
	/**
	 * ...
	 * @author ...
	 */
	public class MediumLauncherC extends Launcher {
		
		public function MediumLauncherC(X:int, Y:int) {
			var blocks:Array, center:Point, spr:Class, spr_in:Class;
			
			blocks = [new Block(0, 0), new Block(1, 0), new Block(2, 0),
					  new Block(0, 1), new Block(1, 1), new Block(2, 1)];
			spr = _sprite;
			spr_in = _sprite_in;
			
			powerReq = 50;
			crewReq = blocks.length;
			
			super(X, Y, blocks, new Point(1, 0), spr, spr_in);
			
			name = "Launcher-C";
		}
		
		[Embed(source = "../../../../lib/art/sminos/med_launch_3.png")] private static const _sprite:Class;
		[Embed(source = "../../../../lib/art/sminos/med_launch_in_3.png")] private static const _sprite_in:Class;
		
	}

}