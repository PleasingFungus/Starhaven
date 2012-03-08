package InfoScreens {
	import Controls.ControlSet;
	import flash.utils.Dictionary;
	import org.flixel.*;
	import Sminos.Barracks;
	import Sminos.Conduit;
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class NewPieceInfo extends InfoScreen {
		
		
		protected var visibilityTimer:Number = 0;
		protected var visibilityTime:Number = 0.5;
		protected var mino:Smino;
		
		protected var title:FlxText;
		protected var description:FlxText;
		protected var audioDescription:FlxSound;
		protected var htext:FlxText;
		public function NewPieceInfo(mino:Smino, SetInfopauseState:Function) {
			super(SetInfopauseState);
			
			this.mino = mino;
			
			var name:String = getPieceName(mino);
			title = new FlxText(0, 10, FlxG.width, name);
			title.setFormat(C.TITLEFONT, 28, 0xffffff/*, 'center'*/);
			//add(title);
			
			description = new FlxText(40, title.y + title.height + 30, 275, mino.description);
			description.setFormat(C.BLOCKFONT, 16, 0xffffff);
			//add(description);
			
			//TODO: autogen'd iconography! (oooo)
			
			htext = new FlxText( 0, -1, FlxG.width, ControlSet.MINO_HELP_KEY.toString()+" to see this screen again later");
			htext.setFormat(C.FONT, 12, 0xffffff, 'center');
			if (C.AUDIO_DESCRIPTIONS && mino.audioDescription) {
				audioDescription = new FlxSound();
				audioDescription.loadEmbedded(mino.audioDescription);
				audioDescription.play();
				FlxG.state.add(audioDescription);
			}
			if (!seenPieces[name]) {
				visible = false;
				saveSeen(mino);
			} else
				deploy();
		}
		
		override protected function create():void { }
		
		override public function update():void {
			if (audioDescription) {
				if (!mino.current) {
					audioDescription.stop();
					exists = false;
				} else if (!audioDescription.playing)
					exists = false;
			} else if (visible) {
				super.update();
			} else if (C.B.PlayArea.containsRect(mino.bounds)) {
				visibilityTimer += FlxG.elapsed;
				if (visibilityTimer >= visibilityTime)
					deploy();
			} else
				visibilityTimer = 0;
		}
		
		private function saveSeen(piece:Mino):void {
			seenPieces[getPieceName(piece)] = true;
			
			var archivalPieces:Array = [];
			for (var name:String in seenPieces)
				archivalPieces.push(name);
			
			C.save.write("Seen Pieces", archivalPieces);
		}
		
		protected function deploy():void {
			super.create();
			
			visible = true;
			//bg.alpha = 1;
			
			mino.x = FlxG.width / 2 - mino.width / 2;
			mino.y = FlxG.height / 2 - mino.height / 2;
			
			//title = new FlxText( 10, -1, FlxG.width - 60 - mino.x, getPieceName(mino));
			//title.setFormat(C.FONT, 32, 0xffffff, 'right');
			add(title);
			
			title.x = mino.x - (title.textWidth + 10);
			title.y = mino.y + mino.height / 2 - title.height / 2;
			
			description.x = mino.x + mino.width + 10;
			description.width = FlxG.width - description.x - 10;
			
			description = new FlxText(mino.x + mino.width + 10, -1, FlxG.width - description.x - 5, mino.description);
			description.setFormat(C.BLOCKFONT, 16, 0xffffff);
			
			description.y = mino.y + mino.height / 2 - description.height / 2;
			add(description);
			
			continueText.y = mino.y + mino.height + 60;
			
			htext.y = continueText.y + continueText.height + 20;
			add(htext);
		}
		
		public static var seenPieces:Dictionary;
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
		
		override public function render():void {
			super.render();
			
			mino.x = FlxG.width * .5 - mino.getDrawBounds().width / 2 - C.B.drawShift.x;
			mino.y = FlxG.height / 2 - mino.getDrawBounds().height / 2 - C.B.drawShift.y;
			mino.forceRender();
		}
	}

}