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
		private var leftKey:FlxSprite, upKey:FlxSprite, rightKey:FlxSprite, downKey:FlxSprite, shiftKey:FlxSprite;
		public var parent:Mino;
		public var presses:Array;
		
		public function ArrowHelper(Parent:Mino) {
			keys = [];
			
			leftKey = ControlSet.MINO_L_KEY.generateKeySprite();
			upKey = ControlSet.MINO_CCW_KEY.generateKeySprite();
			rightKey = ControlSet.MINO_R_KEY.generateKeySprite();
			downKey = ControlSet.FASTFALL_KEY.generateKeySprite();
			//downKey = ControlSet.MINO_CW_KEY.generateKeySprite();
			//shiftKey = ControlSet.FASTFALL_KEY.generateKeySprite();
			
			keys.push(add(leftKey));
			keys.push(add(upKey));
			keys.push(add(rightKey));
			keys.push(add(downKey));
			//keys.push(add(shiftKey));
			
			for each (var key:FlxSprite in keys)
				key.alpha = .5;
			
			parent = Parent;
			presses = [0, 0, 0, 0];
		}
		
		override public function update():void {
			if (!FlxG.timeScale)
				return;
			
			var parentBounds:Rectangle = parent.getDrawBounds();
			var scale:Number = leftKey.scale.x * leftKey.scale.x;
			
			
			leftKey.x = parentBounds.x - BUFFER * scale - leftKey.width;
			leftKey.y = parentBounds.y + parentBounds.height / 2 - leftKey.height / 2;
			if (ControlSet.MINO_L_KEY.justPressed()) {
				presses[FlxSprite.LEFT]++;
				leftKey.alpha = 1;
			} else if (!ControlSet.MINO_L_KEY.pressed())
				leftKey.alpha = .5;
			
			upKey.x = parentBounds.x + parentBounds.width / 2 - upKey.width / 2;
			upKey.y = parentBounds.y - BUFFER * scale - upKey.height;
			if (ControlSet.MINO_CCW_KEY.justPressed()) {
				upKey.alpha = 1;
				presses[FlxSprite.UP]++;
			} else if (!ControlSet.MINO_CCW_KEY.pressed())
				upKey.alpha = .5;
			
			rightKey.x = parentBounds.right + BUFFER * scale;
			rightKey.y = parentBounds.y + parentBounds.height / 2 - rightKey.height / 2;
			if(ControlSet.MINO_R_KEY.justPressed()) {
				rightKey.alpha = 1;
				presses[FlxSprite.RIGHT]++;
			} else if (!ControlSet.MINO_R_KEY.pressed())
				rightKey.alpha = .5;
			
			downKey.x = parentBounds.x + parentBounds.width / 2 - downKey.width / 2;
			downKey.y = parentBounds.bottom + BUFFER * scale;
			if(ControlSet.FASTFALL_KEY.justPressed()) {
				downKey.alpha = 1;
				presses[FlxSprite.DOWN]++;
			} else if (!ControlSet.FASTFALL_KEY.pressed())
				downKey.alpha = .5;
			
			//downKey.x = parentBounds.x + parentBounds.width / 2 - downKey.width / 2;
			//downKey.y = parentBounds.bottom + BUFFER * scale;
			//if(ControlSet.MINO_CW_KEY.justPressed()) {
				//downKey.alpha = 1;
				//presses[FlxSprite.DOWN]++;
			//} else if (!ControlSet.MINO_CW_KEY.pressed())
				//downKey.alpha = .5;
			
			//shiftKey.x = parentBounds.x + parentBounds.width;
			//shiftKey.y = parentBounds.bottom + BUFFER * scale;
			//if(ControlSet.FASTFALL_KEY.justPressed()) {
				//shiftKey.alpha = 1;
				//presses[FlxSprite.DOWN]++;
			//} else if (!ControlSet.FASTFALL_KEY.pressed())
				//shiftKey.alpha = .5;
			
			
			super.update();
			visible = C.HUD_ENABLED;
			
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