package Missions {
	import flash.display.BitmapData;
	import org.flixel.FlxG;
	import Mining.MineralBlock;
	import Mining.Terrain;
	import flash.geom.Point;
	import Sminos.*;
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class LoadedMission extends Mission {
		
		public static const ALL_SMINOS:Array = [HookConduit, LeftHookConduit, LongConduit,
										 MediumBarracks, SmallBarracks, MediumLauncher, SmallLauncher,
										 NebularAccumulator, Scoop, LongDrill,
										 RocketGun];
		
		public static const SMINO_NAMES:Array = ["Hook-Conduit", "LeftHook-Conduit", "Long-Conduit",
										  "Barracks", "Small Barracks", "Launcher", "Small Launcher",
										  "Nebular Accumulator", "Scoop", "Long Drill",
										  "Rocket Gun"];
		
		protected const PIXEL_OPACITY_FACING_LEFT:int = 63;
		protected const PIXEL_OPACITY_FACING_UP:int = 127;
		protected const PIXEL_OPACITY_FACING_RIGHT:int = 191;
		protected const PIXEL_OPACITY_FACING_DOWN:int = 255;
		
		[Embed(source = "../../lib/data/piece_colors.txt", mimeType = "application/octet-stream")] protected const PIECE_COLORS:Class;
		
		public function LoadedMission(MissionImage:Class) {
			super(NaN, 1);
			
			var image:BitmapData = FlxG.addBitmap(MissionImage);
			var blocks:Array = [];
			for (var x:int = 0; x < image.width; x++)
				for (var y:int = 0; y < image.width; y++) {
					var pixelColor:uint = image.getPixel32(x, y)
					var blockType:int = MineralBlock.typeOfColor(pixelColor);
					if (blockType >= MineralBlock.BEDROCK)
						blocks.push(new MineralBlock(x, y, 5, blockType));
				}
			
			rawMap = new Terrain(blocks, new Point(Math.ceil(image.width/2), Math.ceil(image.height /*/ 2*/)));
			fullMapSize = new Point(Math.ceil(image.width/2), Math.ceil(image.height / 2));
		}
		
		protected function parseColorListFromFile(file:Class):Object
		{
			var pieceColorText:String = new file;
			var pieceColorDict:Object = { };
			var pieces:Array = pieceColorText.split("\n")
			for each (var piece:String in pieces)
			{
				var namesAndColors:Array = piece.split(":");
				var name:String = namesAndColors[0];
				var colors:Array = namesAndColors[1].split(",");
				var red:int = colors[0];
				var green:int = colors[1];
				var blue:int = colors[2];
				pieceColorDict[(red << 16) | (green << 8) | blue] = name;
			}
			return pieceColorDict;
		}
		
		protected function findPieceFromColor(color:uint, colorList:Object, log:Boolean = false):Class
		{
			var pixelColor:uint = 0xffffff & color;
			if ((0xff & (color >> 24)) == 191) 			// correction for weirdass opacity reading bugthing
				pixelColor += 0x010100;
			var pieceNameIndex:int = SMINO_NAMES.indexOf(colorList[pixelColor]);
			
			if (log)
				C.log(color, colorList, SMINO_NAMES, pieceNameIndex, pixelColor);
			
			if (pieceNameIndex)
			{
				return ALL_SMINOS[pieceNameIndex];
			}
			else
			{
				return null;
			}
		}
		
		protected function findPieceRotationFromColor(color:uint):int
		{
			var pixelOpacity:uint = 0xff & (color >> 24);
			if (pixelOpacity != 0 && pixelOpacity != 255)
				C.log(pixelOpacity, color);
			switch (pixelOpacity)
			{
				case PIXEL_OPACITY_FACING_LEFT:
					return FlxSprite.LEFT;
					break;
				case PIXEL_OPACITY_FACING_UP:
					return FlxSprite.UP;
					break;
				case PIXEL_OPACITY_FACING_RIGHT:
					return FlxSprite.RIGHT;
					break;
				case PIXEL_OPACITY_FACING_DOWN:
					return FlxSprite.DOWN;
					break;
			}
			return FlxSprite.DOWN;
		}
		
		protected function addPiece(x:int, y:int, type:Class, facing:int):Smino
		{
			var smino:Smino = new type(x - C.B.OUTER_BOUNDS.width / 2, y - C.B.OUTER_BOUNDS.height / 2);
			while (smino.facing != facing)
				smino.rotateClockwise(true);
			return smino;
		}
		
		public function loadPieces(MissionImage:Class):Vector.<Smino>
		{
			var pieces:Vector.<Smino> = new Vector.<Smino>;
			
			var pieceColorList:Object = parseColorListFromFile(PIECE_COLORS);
			
			var image:BitmapData = FlxG.addBitmap(MissionImage);
			for (var x:int = 0; x < image.width; x++)
				for (var y:int = 0; y < image.width; y++)
				{
					var pixelColor:uint = image.getPixel32(x, y)
					var pieceType:Class = findPieceFromColor(pixelColor, pieceColorList);
					var rotation:int = findPieceRotationFromColor(pixelColor);
					if (x == 8 && y == 17)
						//C.log(pixelColor, pieceType, rotation, pieceColorList);
						findPieceFromColor(pixelColor, pieceColorList, true);
					if (pieceType)
					{
						pieces.push(addPiece(x, y + 1, pieceType, rotation));
					}
				}
			return pieces;
		}
		
	}

}