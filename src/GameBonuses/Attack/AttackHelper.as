package GameBonuses.Attack {
	import Helpers.KeyHelper;
	import org.flixel.FlxGroup;
	import Controls.ControlSet;
	import flash.geom.Rectangle;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class AttackHelper extends FlxGroup {
		
		private var leftKey:KeyHelper;
		private var rightKey:KeyHelper;
		public var parent:Smino;
		public var presses:int;
		
		public function AttackHelper(Parent:Smino) {
			add(leftKey = ControlSet.MINO_L_KEY.generateKeySprite());
			add(rightKey = ControlSet.MINO_R_KEY.generateKeySprite());
			
			parent = Parent;
		}
		
		override public function update():void {
			if (!FlxG.timeScale)
				return;
			
			var parentBounds:Rectangle = parent.getDrawBounds();
			var scale:Number = leftKey.scale.x * leftKey.scale.x;
			
			
			leftKey.x = parentBounds.x - BUFFER * scale - leftKey.width;
			leftKey.y = parentBounds.y + parentBounds.height / 2 - leftKey.height / 2;
			
			rightKey.x = parentBounds.right + BUFFER * scale;
			rightKey.y = parentBounds.y + parentBounds.height / 2 - rightKey.height / 2;
			
			if (ControlSet.MINO_L_KEY.justPressed() || ControlSet.MINO_R_KEY.justPressed())
				presses++;
			
			super.update();
			
			if (parent.falling && presses >= PRESS_LIMIT)
				exists = false;
		}
		
		protected static const BUFFER:int = 4;
		protected static const PRESS_LIMIT:int = 6;
		
	}

}