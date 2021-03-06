package Options {
	//import MainMenu.MenuState;
	import MainMenu.StateThing;
	import org.flixel.*;
	import Controls.ControlSet;
	
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class ControlsState extends FadeState {
		
		private var inertiaButton:MenuThing;
		private var keyTargetButton:MenuThing;
		override public function create():void {
			super.create();
			loadBackground(BG, 0.75);
			
			var t:FlxText;
			
			t = new FlxText(0, 10, FlxG.width, "Controls");
			t.setFormat(C.TITLEFONT, 48, 0xffffff, 'center');
			add(t);
			
			
			
			MenuThing.resetThings();
			var leftCol:Array = [];
			leftCol.push(add(new StateThing("Back to Menu", OptionsState).setFormat(C.FONT, 12)));
			leftCol.push(add(new ControlMenuThing("Move Left: ", ControlSet.MINO_L_KEY)));
			leftCol.push(add(new ControlMenuThing("Move Right: ", ControlSet.MINO_R_KEY)));
			leftCol.push(add(new ControlMenuThing("Fastfall: ", ControlSet.FASTFALL_KEY)));
			leftCol.push(add(new ControlMenuThing("Rotate CCW: ", ControlSet.MINO_CCW_KEY)));
			MenuThing.addColumn(leftCol, 15);
			
			var rightCol:Array = [];
			rightCol.push(add(new ControlMenuThing("Rotate CW: ", ControlSet.MINO_CW_KEY)));
			rightCol.push(add(new ControlMenuThing("Rotate Station CCW: ", ControlSet.ST_CCW_KEY)));
			rightCol.push(add(new ControlMenuThing("Rotate Station CW: ", ControlSet.ST_CW_KEY)));
			rightCol.push(add(new ControlMenuThing("Drop Bomb: ", ControlSet.BOMB_KEY)));
			rightCol.push(add(new ResetMenuThing()));
			MenuThing.addColumn(rightCol, FlxG.width / 2 + 15);
			
			add(inertiaButton = new MenuThing("Rotation Inertia: " + (ControlSet.ROTATE_INERTIA ? "On" : "Off"), setRotateInertia, false));
			inertiaButton.setFormat(C.FONT, 12);
			MenuThing.addColumn([inertiaButton], FlxG.width * 1 / 16);
			inertiaButton.setY(FlxG.height * 3 / 4);
			
			add(keyTargetButton = new MenuThing("Keyboard Targeting: " + (ControlSet.KEYBOARD_TARGETING_OK ? "On" : "Off"), setKeyboardTargeting, false));
			keyTargetButton.setFormat(C.FONT, 12);
			MenuThing.addColumn([keyTargetButton], FlxG.width * 9 / 16);
			keyTargetButton.setY(FlxG.height * 3 / 4);
			
			
			MenuThing.menuThings[0].select();
			
			
			
			//t = new FlxText(0, FlxG.height - 25, FlxG.width, "Arrow keys navigate, enter selects, escape exits.");
			//t.setFormat(C.FONT, 12, 0xffffff, 'center');
			//add(t);
		}
		
		protected function setRotateInertia(_:String):void {
			ControlSet.ROTATE_INERTIA = !ControlSet.ROTATE_INERTIA;
			inertiaButton.init("Rotation Inertia: " + (ControlSet.ROTATE_INERTIA ? "On" : "Off"));
			inertiaButton.setY(FlxG.height * 3 / 4);
			ControlSet.save();
		}
		
		protected function setKeyboardTargeting(_:String):void {
			ControlSet.KEYBOARD_TARGETING_OK = !ControlSet.KEYBOARD_TARGETING_OK;
			keyTargetButton.init("Keyboard Targeting: " + (ControlSet.KEYBOARD_TARGETING_OK ? "On" : "Off"));
			keyTargetButton.setY(FlxG.height * 3 / 4);
			ControlSet.save();
		}
		
		override public function update():void {
			super.update();
			if (ControlSet.CANCEL_KEY.justPressed()) {
				fadeBackTo(OptionsState);
			}
		}
		
		[Embed(source = "../../lib/art/backgrounds/menu/menu_bg_2s.jpg")] private const BG:Class;
	}

}