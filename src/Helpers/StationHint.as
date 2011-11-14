package Helpers {
	import org.flixel.*;
	import flash.geom.Rectangle;
	import Controls.ControlSet;
	
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class StationHint extends FlxGroup {
		
		private var leftKey:FlxSprite, rightKey:FlxSprite;
		public var parent:Aggregate;
		public var presses:int;
		
		public function StationHint(Parent:Aggregate) {
			add(leftKey = ControlSet.ST_CCW_KEY.generateKeySprite());
			add(rightKey = ControlSet.ST_CW_KEY.generateKeySprite());
			leftKey.alpha = rightKey.alpha = .5;
			
			parent = Parent;
		}
		
		override public function update():void {
			if (!FlxG.timeScale)
				return;
			
			var parentBounds:Rectangle = parent.getDrawBounds();
			var scale:Number = leftKey.scale.x;
			
			
			leftKey.x = parentBounds.x - BUFFER * scale - leftKey.width;
			leftKey.y = parentBounds.y + parentBounds.height / 2 - leftKey.height / 2;
			if (ControlSet.ST_CCW_KEY.justPressed()) {
				presses++;
				leftKey.alpha = 1;
			} else if (!ControlSet.ST_CCW_KEY.pressed())
				leftKey.alpha = .5;
			
			rightKey.x = parentBounds.right + BUFFER * scale;
			rightKey.y = parentBounds.y + parentBounds.height / 2 - rightKey.height / 2;
			if(ControlSet.ST_CW_KEY.justPressed()) {
				rightKey.alpha = 1;
				presses++;
			} else if (!ControlSet.ST_CW_KEY.pressed())
				rightKey.alpha = .5;
			
			
			super.update();
			visible = C.HUD_ENABLED;
			
			exists = presses < PRESS_LIMIT;
		}
		
		protected static const BUFFER:int = 6;
		protected static const PRESS_LIMIT:int = 8;
		
	}

}