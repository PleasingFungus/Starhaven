package Meteoroids {
	import Controls.ControlSet;
	import flash.geom.Point;
	import Helpers.KeyHelper;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class TargetingCursor extends FlxSprite {
		
		protected var lastMouse:Point;
		protected var speed:Number = 0;
		protected var movedLast:Boolean;
		protected var hints:FlxGroup;
		protected var mouse:FlxSprite;
		protected var useTime:Number;
		protected var keyPresses:int;
		public function TargetingCursor() {
			super(FlxG.mouse.x, FlxG.mouse.y);
			loadGraphic(_combat_cursor);
			offset.x = width / 2;
			offset.y = height / 2;
			
			lastMouse = new Point(x, y);
			
			hints = new FlxGroup;
			hints.add(new KeyHelper(ControlSet.LEFT_KEY));
			hints.add(new KeyHelper(ControlSet.UP_KEY));
			hints.add(new KeyHelper(ControlSet.RIGHT_KEY));
			hints.add(new KeyHelper(ControlSet.DOWN_KEY));
			hints.add(new KeyHelper(ControlSet.BOMB_KEY));
			hints.add(mouse = new FlxSprite().loadGraphic(_mouse));
			mouse.alpha = 0.5;
			useTime = 0;
		}
		
		override public function update():void {
			super.update();
			if (lastMouse.x != FlxG.mouse.x + FlxG.quake.x || lastMouse.y != FlxG.mouse.y + FlxG.quake.y)
				moveToMouse();
			else
				checkKeyboard();
			
			if (useTime >= 1.6)
				hints.exists = false;
			
			if (hints.exists)
				updateHints();
		}
		
		protected function moveToMouse():void {
			x = lastMouse.x = FlxG.mouse.x + FlxG.quake.x;
			y = lastMouse.y = FlxG.mouse.y + FlxG.quake.y;
			
			useTime += FlxG.elapsed;
		}
		
		protected function checkKeyboard():void {
			movedLast = false;
			
			for (var i:int = LEFT; i <= DOWN; i++)
				if (ControlSet.DIRECTION_KEYS[i].pressed())
					move(i);
			
			if (movedLast)
				useTime += FlxG.elapsed;
			else
				speed = 0;
		}
		
		protected function move(direction:int):void {
			if (!movedLast)
				speed = Math.min(MAX_SPEED, speed + MAX_SPEED * FlxG.elapsed / ACCEL_TIME); 
			
			var vect:Point = DIRECTIONS[direction];
			x += vect.x * speed * FlxG.elapsed;
			y += vect.y * speed * FlxG.elapsed;
			
			movedLast = true;
		}
		
		protected function updateHints():void {
			for (var i:int = LEFT; i <= DOWN; i++) {
				hints.members[i].x = x - hints.members[i].width/2 + DIRECTIONS[i].x * HINT_SPACING;
				hints.members[i].y = y - hints.members[i].height/2 + DIRECTIONS[i].y * HINT_SPACING;
			}
			hints.members[i].x = x - hints.members[i].width/2; //bomb
			hints.members[i].y = y - hints.members[i].height / 2 + HINT_SPACING * 2;
			mouse.x = x + HINT_SPACING * 2;
			mouse.y = y + height / 2 - mouse.height / 2;
			hints.update();
		}
		
		override public function render():void {
			if (hints.exists)
				hints.render();
			super.render();
		}
		
		protected const ACCEL_TIME:Number = 0.30;
		protected const MAX_SPEED:Number = 300;
		protected const HINT_SPACING:Number = 30;
		
		protected const DIRECTIONS:Array = [new Point( -1, 0), new Point(0, -1), new Point(1, 0), new Point(0, 1)];
		
		[Embed(source = "../../lib/art/ui/target_cursor.png")] private static const _combat_cursor:Class;
		[Embed(source = "../../lib/art/help/mouse.png")] private static const _mouse:Class;
	}

}