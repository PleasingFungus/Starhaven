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
		
		override public function create():void {
			super.create();
			
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
			leftCol.push(add(new ControlMenuThing("Rotate CW: ", ControlSet.MINO_CW_KEY)));
			MenuThing.addColumn(leftCol, 15);
			
			var rightCol:Array = [];
			//rightCol.push(add(new ControlMenuThing("No Priority: ", ControlSet.PR_GEN_KEY)));
			//rightCol.push(add(new ControlMenuThing("Infrastructure Priority: ", ControlSet.PR_STR_KEY)));
			//rightCol.push(add(new ControlMenuThing("Economic Priority: ", ControlSet.PR_ECN_KEY)));
			//rightCol.push(add(new ControlMenuThing("Defense Priority: ", ControlSet.PR_DEF_KEY)));
			//rightCol.push(add(new ControlMenuThing("Scroll Priority Up: ", ControlSet.PR_UP_KEY)));
			//rightCol.push(add(new ControlMenuThing("Scroll Priority Down: ", ControlSet.PR_DOWN_KEY)));
			rightCol.push(add(new ControlMenuThing("Rotate Station CCW: ", ControlSet.ST_CCW_KEY)));
			rightCol.push(add(new ControlMenuThing("Rotate Station CW: ", ControlSet.ST_CW_KEY)));
			rightCol.push(add(new ControlMenuThing("Drop Bomb: ", ControlSet.BOMB_KEY)));
			rightCol.push(add(new ControlMenuThing("Info: ", ControlSet.MINO_HELP_KEY)));
			rightCol.push(add(new ControlMenuThing("Toggle Zoom: ", ControlSet.ZOOM_KEY)));
			rightCol.push(add(new ResetMenuThing()));
			MenuThing.addColumn(rightCol, FlxG.width / 2 + 15);
			
			
			MenuThing.menuThings[0].select();
			
			
			
			//t = new FlxText(0, FlxG.height - 25, FlxG.width, "Arrow keys navigate, enter selects, escape exits.");
			//t.setFormat(C.FONT, 12, 0xffffff, 'center');
			//add(t);
		}
		
		override public function update():void {
			super.update();
			if (ControlSet.CANCEL_KEY.justPressed()) {
				fadeBackTo(OptionsState);
			}
		}
	}

}