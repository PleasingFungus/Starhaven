package Options {
	import Controls.ControlSet;
	import org.flixel.*;
	import MainMenu.StateThing;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class SoundState extends FadeState {
		
		override public function create():void {
			super.create();
			
			var t:FlxText;
			
			t = new FlxText(0, 10, FlxG.width, "Volume");
			t.setFormat(C.TITLEFONT, 48, 0xffffff, 'center');
			add(t);
			
			MenuThing.resetThings();
			var backButton:StateThing = new StateThing("Back", OptionsState);
			backButton.setY(FlxG.height - 40);
			add(backButton);
			
			//TODO: add volume sliders
			add(new VolumeSlider(FlxG.height / 2 - 55, null, null));
			add(new VolumeSlider(FlxG.height / 2 - 15, null, null));
			add(new VolumeSlider(FlxG.height / 2 + 25, null, null));
		}
		
		override public function update():void {
			super.update();
			if (ControlSet.CANCEL_KEY.justPressed())
				fadeTo(OptionsState);
		}
		
	}

}