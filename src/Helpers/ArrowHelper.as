package Helpers {
	import flash.geom.Rectangle;
	import org.flixel.*
	import Controls.ControlSet;
	
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class ArrowHelper extends FlxGroup {
		
		private var keys:Array;
		public var parent:Smino;
		public var presses:Array;
		
		public function ArrowHelper(Parent:Smino) {
			keys = [];
			
			keys.push(add(ControlSet.MINO_L_KEY.generateKeySprite()));
			if (ControlSet.MINO_CCW_KEY.key)
				keys.push(add(ControlSet.MINO_CCW_KEY.generateKeySprite()));
			else
				keys.push(add(ControlSet.MINO_CW_KEY.generateKeySprite()));
			keys.push(add(ControlSet.MINO_R_KEY.generateKeySprite()));
			keys.push(add(ControlSet.FASTFALL_KEY.generateKeySprite()));
			
			parent = Parent;
			presses = [0, 0, 0, 0];
		}
		
		override public function update():void {
			if (!FlxG.timeScale)
				return;
			
			var parentBounds:Rectangle = parent.getDrawBounds();
			var scale:Number = keys[0].scale.x * keys[0].scale.x;
			
			
			keys[FlxSprite.LEFT].x = parentBounds.x - BUFFER * scale - keys[FlxSprite.LEFT].width;
			keys[FlxSprite.LEFT].y = parentBounds.y + parentBounds.height / 2 - keys[FlxSprite.LEFT].height / 2;
			
			keys[FlxSprite.UP].x = parentBounds.x + parentBounds.width / 2 - keys[FlxSprite.UP].width / 2;
			keys[FlxSprite.UP].y = parentBounds.y - BUFFER * scale - keys[FlxSprite.UP].height;
			keys[FlxSprite.UP].visible = parent.rotateable;
			
			keys[FlxSprite.RIGHT].x = parentBounds.right + BUFFER * scale;
			keys[FlxSprite.RIGHT].y = parentBounds.y + parentBounds.height / 2 - keys[FlxSprite.RIGHT].height / 2;
			
			keys[FlxSprite.DOWN].x = parentBounds.x + parentBounds.width / 2 - keys[FlxSprite.DOWN].width / 2;
			keys[FlxSprite.DOWN].y = parentBounds.bottom + BUFFER * scale;
			
			for (var i:int = 0; i < 4; i++)
				if (keys[i].key.justPressed() && (i != FlxSprite.UP || parent.rotateable))
					presses[i]++;
			
			super.update();
			
			if (parent.falling)
				for each (var pressCount:int in presses)
					if (pressCount < PRESS_LIMIT)
						return;
			exists = false;
		}
		
		protected static const BUFFER:int = 4;
		protected static const PRESS_LIMIT:int = 4;
	}

}