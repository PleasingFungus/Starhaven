package Helpers {
	import org.flixel.*;
	import flash.geom.Rectangle;
	import Controls.ControlSet;
	
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class StationHint extends FlxGroup {
		
		private var leftKey:KeyHelper, rightKey:KeyHelper;
		public var parent:Aggregate;
		public var presses:int;
		
		private static var done:Boolean;
		
		public function StationHint(Parent:Aggregate) {
			add(leftKey = ControlSet.ST_CW_KEY.generateKeySprite());
			add(rightKey = ControlSet.ST_CCW_KEY.generateKeySprite());
			
			parent = Parent;
			
			exists = !done;
		}
		
		override public function update():void {
			if (!FlxG.timeScale)
				return;
			
			var parentBounds:Rectangle = parent.getDrawBounds();
			var scale:Number = leftKey.scale.x;
			
			
			leftKey.x = parentBounds.x - BUFFER * scale - leftKey.width;
			leftKey.y = parentBounds.y + parentBounds.height / 2 - leftKey.height / 2;
			
			rightKey.x = parentBounds.right + BUFFER * scale;
			rightKey.y = parentBounds.y + parentBounds.height / 2 - rightKey.height / 2;
			
			
			super.update();
			visible = C.HUD_ENABLED;
			
			if (leftKey.key.justPressed())
				presses++;
			if (rightKey.key.justPressed())
				presses++;
			exists = presses < PRESS_LIMIT;
			done = !exists;
		}
		
		protected static const BUFFER:int = 6;
		protected static const PRESS_LIMIT:int = 8;
		
	}

}