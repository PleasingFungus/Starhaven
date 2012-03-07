package Options {
	import Controls.ControlSet;
	import org.flixel.*;
	import MainMenu.MemoryThing;
	import MainMenu.MenuState;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class OptionsState extends FadeState {
		
		private var glowThing:MenuThing;
		override public function create():void {
			super.create();
			loadBackground(BG, 0.65);
			
			var t:FlxText;
			
			t = new FlxText(0, 10, FlxG.width, "Options");
			t.setFormat(C.TITLEFONT, 48, 0xffffff, 'center');
			add(t);
			
			MenuThing.resetThings();
			add(new MemoryThing("Controls", ControlsState));
			add(new MemoryThing("Sound", SoundState));
			add(new MemoryThing("Unlocks", UnlocksState));
			add(glowThing = new MenuThing("Glow: " + (C.DRAW_GLOW ? "ON" : "OFF"), toggleGlow, false));
			add(new MemoryThing("Back", MenuState));
			
			
		}
		
		override public function update():void {
			super.update();
			if (ControlSet.CANCEL_KEY.justPressed()) {
				fadeBackTo(MenuState);
			}
		}
		
		private function toggleGlow(_:String):void {
			C.toggleGlow();
			glowThing.init("Glow: " + (C.DRAW_GLOW ? "ON" : "OFF"));
		}
		
		[Embed(source = "../../lib/art/backgrounds/menu/menu_bg_1s.jpg")] private const BG:Class;
		
	}

}