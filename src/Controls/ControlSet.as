package Controls {
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class ControlSet {
		
		public static const CONFIRM_KEY:Key = new Key("ENTER");
		public static const CANCEL_KEY:Key = new Key("ESCAPE");
		
		public static const MINO_CCW_KEY:Key = new Key("UP");
		public static const MINO_CW_KEY:Key = new Key("SHIFT");
		public static const MINO_L_KEY:Key = new Key("LEFT");
		public static const MINO_R_KEY:Key = new Key("RIGHT");
		public static const FASTFALL_KEY:Key = new Key("DOWN");
		
		public static const ST_CCW_KEY:Key = new Key("C");
		public static const ST_CW_KEY:Key = new Key("X");
		public static const BOMB_KEY:Key = new Key("SPACE");
		
		public static const MINO_HELP_KEY:Key = new Key("H");
		
		public static const DEBUG_DESTRUCT_KEY:Key = new Key("Q");
		public static const DEBUG_SKIP_KEY:Key = new Key("K");
		public static const DEBUG_ASTEROIDS_KEY:Key = new Key("I");
		public static const DEBUG_DIE_KEY:Key = new Key("U");
		public static const DEBUG_WIN_KEY:Key = new Key("Y");
		public static const DEBUG_PRINT_KEY:Key = new Key("E");
		public static const DEBUG_END_KEY:Key = new Key("W");
		public static const DISABLE_HUD_KEY:Key = new Key("SEMICOLON");
		
		public static const CONFIGURABLE_CONTROLS:Array = [MINO_CCW_KEY, MINO_CW_KEY, MINO_L_KEY, MINO_R_KEY, FASTFALL_KEY, ST_CCW_KEY, ST_CW_KEY,
														   BOMB_KEY, MINO_HELP_KEY];
		
		
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
		}
		
		public static function load():void {
			var savedKeys:Array = C.save.read("Controls") as Array;
			if (savedKeys)
				for (var i:int = 0; i < savedKeys.length; i++) {
					var rawstr:String = savedKeys[i];
					var splitstr:Array = rawstr.split('+');
					var keystr:String = splitstr[0];
					var modbool:Boolean = splitstr[1] == 'true';
					
					CONFIGURABLE_CONTROLS[i].key = keystr;
					CONFIGURABLE_CONTROLS[i].modified = modbool;
				}
			else
				reset();
		}
		
		public static function reset():void {
			MINO_CCW_KEY.key = "UP";
			MINO_CW_KEY.key = "PERIOD";
			MINO_L_KEY.key = "LEFT";
			MINO_R_KEY.key = "RIGHT";
			FASTFALL_KEY.key = "DOWN";
			
			ST_CCW_KEY.key = "C";
			ST_CW_KEY.key = "X";
		
			BOMB_KEY.key = "SPACE";
			MINO_HELP_KEY.key = "H";
		}
	}

}