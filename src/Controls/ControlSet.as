package Controls {
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class ControlSet {
		
		public static const LEFT_KEY:Key = new Key("LEFT");
		public static const UP_KEY:Key = new Key("UP");
		public static const RIGHT_KEY:Key = new Key("RIGHT");
		public static const DOWN_KEY:Key = new Key("DOWN");
		public static const DIRECTION_KEYS:Array = [LEFT_KEY, UP_KEY, RIGHT_KEY, DOWN_KEY];
		
		public static const CONFIRM_KEY:Key = new Key("ENTER");
		public static const CANCEL_KEY:Key = new Key("ESCAPE");
		
		
		public static const MINO_CCW_KEY:Key = new Key(null);
		public static const MINO_CW_KEY:Key = new Key(null);
		public static const MINO_L_KEY:Key = new Key(null);
		public static const MINO_R_KEY:Key = new Key(null);
		public static const FASTFALL_KEY:Key = new Key(null);
		
		public static const ST_CCW_KEY:Key = new Key(null);
		public static const ST_CW_KEY:Key = new Key(null);
		public static const BOMB_KEY:Key = new Key(null);
		
		public static const MINO_HELP_KEY:Key = new Key(null);
		
		
		public static const DEBUG_DESTRUCT_KEY:Key = new Key("Q");
		public static const DEBUG_SKIP_KEY:Key = new Key("K");
		public static const DEBUG_ASTEROIDS_KEY:Key = new Key("I");
		public static const DEBUG_DIE_KEY:Key = new Key("U");
		public static const DEBUG_WIN_KEY:Key = new Key("Y");
		public static const DEBUG_PRINT_KEY:Key = new Key("E");
		public static const DEBUG_END_KEY:Key = new Key("W");
		public static const DEBUG_ROCKET_KEY:Key = new Key("L");
		public static const DISABLE_HUD_KEY:Key = new Key("SEMICOLON");
		public static const ZOOM_KEY:Key = new Key("QUOTE");
		
		public static var ROTATE_INERTIA:Boolean = false;
		public static var KEYBOARD_TARGETING_OK:Boolean = true;
		
		public static const CONFIGURABLE_CONTROLS:Array = [MINO_CCW_KEY, MINO_CW_KEY, MINO_L_KEY, MINO_R_KEY, FASTFALL_KEY, ST_CCW_KEY, ST_CW_KEY,
														   BOMB_KEY];
		
		
		private static const keyListeners:Array = [];
		public static function registerKeyListener(func:Function):void {
			keyListeners.push(func);
		}
		
		public static function deregisterKeyListener(func:Function):void {
			var i:int = keyListeners.indexOf(func);
			if (i > -1)
				keyListeners.splice(i, 1);
		}
		
		public static function onKeyUp(keycode:int, shiftKey:Boolean):void {
			for each (var listener:Function in keyListeners)
				listener(keycode, shiftKey);
		}
		
		public static function save():void {
			var savedKeys:Array = [];
			for each (var key:Key in CONFIGURABLE_CONTROLS)
				savedKeys.push(key.key + '+' + key.modified);
			C.save.write("Controls", savedKeys);
			C.save.write("RotateInertia", ROTATE_INERTIA);
			C.save.write("KeyboardTargeting", !KEYBOARD_TARGETING_OK); //invert for default
		}
		
		public static function load():void {
			reset();
			
			var savedKeys:Array = C.save.read("Controls") as Array;
			if (savedKeys)
				for (var i:int = 0; i < savedKeys.length && i < CONFIGURABLE_CONTROLS.length; i++) {
					var rawstr:String = savedKeys[i];
					var splitstr:Array = rawstr.split('+');
					var keystr:String = splitstr[0];
					var modbool:Boolean = splitstr[1] == 'true';
					
					if (keystr == "null")
						CONFIGURABLE_CONTROLS[i].key = null;
					else {
						CONFIGURABLE_CONTROLS[i].key = keystr;
						CONFIGURABLE_CONTROLS[i].modified = modbool;
					}
				}
			
			ROTATE_INERTIA = C.save.read("RotateInertia") as Boolean;
			KEYBOARD_TARGETING_OK = !(C.save.read("KeyboardTargeting") as Boolean); //invert for default
		}
		
		public static function reset():void {
			MINO_CCW_KEY.key = "UP";
			MINO_CW_KEY.key = null;
			MINO_L_KEY.key = "LEFT";
			MINO_R_KEY.key = "RIGHT";
			FASTFALL_KEY.key = "DOWN";
			
			ST_CCW_KEY.key = "C";
			ST_CW_KEY.key = "X";
		
			BOMB_KEY.key = "SPACE";
			MINO_HELP_KEY.key = "H";
			//ZOOM_KEY.key = "Z";
			
			ROTATE_INERTIA = false;
			KEYBOARD_TARGETING_OK = true;
		}
	}

}