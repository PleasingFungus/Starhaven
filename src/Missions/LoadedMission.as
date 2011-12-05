package Missions {
	import flash.display.BitmapData;
	import org.flixel.FlxG;
	import Mining.MineralBlock;
	import Mining.Terrain;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class LoadedMission extends Mission {
		
		public function LoadedMission(MissionImage:Class) {
			super(NaN);
			
			var image:BitmapData = FlxG.addBitmap(MissionImage);
			var blocks:Array = [];
			for (var x:int = 0; x < image.width; x++)
				for (var y:int = 0; y < image.width; y++) {
					var blockType:int = MineralBlock.typeOfColor(image.getPixel32(x, y));
					if (blockType >= MineralBlock.BEDROCK)
						blocks.push(new MineralBlock(x, y, 5, blockType));
				}
			
			rawMap = new Terrain(blocks, new Point(Math.ceil(image.width/2), Math.ceil(image.height /*/ 2*/)));
			fullMapSize = new Point(Math.ceil(image.width/2), Math.ceil(image.height / 2));
		}
		
	}

}