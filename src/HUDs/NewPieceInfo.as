package HUDs {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.flixel.*;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class NewPieceInfo extends FlxText {
		
		protected var piece:Smino;
		protected var audioDescription:FlxSound;
		public function NewPieceInfo(Piece:Smino) {
			piece = Piece;
			super(0, 0, FlxG.width / 3, piece.description);
			setFormat(C.FONT, 12, 0xffffff, 'center', 0x1);
			
			if (checkSeen()) {
				exists = false;
				return;
			}
			
			if (C.AUDIO_DESCRIPTIONS && piece.audioDescription) {
				audioDescription = new FlxSound();
				audioDescription.loadEmbedded(piece.audioDescription);
				audioDescription.volume = C.sound.volume * 1;
				audioDescription.play();
				FlxG.state.add(audioDescription);
			}
			
			saveSeen();
		}
		
		override public function update():void {
			super.update();
			
			if (!piece.current) {
				exists = false;
				if (audioDescription)
					audioDescription.stop();
			}
		}
		
		override public function render():void {
			var pieceBounds:Rectangle = piece.bounds;
			var screenspaceTarget:Point = C.B.blocksToScreen(pieceBounds.right + 1,
															 pieceBounds.top + pieceBounds.height / 2);
			
			if (screenspaceTarget.x + textWidth > FlxG.width - 5)
				screenspaceTarget.x = C.B.blocksToScreen(pieceBounds.left - 1, -1).x - textWidth;
			
			screenspaceTarget.y -= height / 2;
			screenspaceTarget.y = Math.max(5, screenspaceTarget.y);
			
			x = screenspaceTarget.x;
			y = screenspaceTarget.y;
			super.render();
		}
		
		private function checkSeen():Boolean {
			return seenPieces[getPieceName(piece)];
		}
		
		private function saveSeen():void {
			seenPieces[getPieceName(piece)] = true;
			
			var archivalPieces:Array = [];
			for (var name:String in seenPieces)
				archivalPieces.push(name);
			
			C.save.write("Seen Pieces", archivalPieces);
		}
		
		private static var seenPieces:Dictionary;
		public static function init():void {
			seenPieces = new Dictionary(true);
			
			if (!(C.DEBUG && C.FORGET_PIECES)) {
				var prevSeen:Array = C.save.read("Seen Pieces") as Array;
				if (prevSeen)
					for each (var pieceName:String in prevSeen)
						seenPieces[pieceName] = true;
			}
		}
		
		public static function getPieceName(piece:Mino):String {
			if (piece.cladeName)
				return piece.cladeName;
			return piece.name;
		}
		
	}

}