package Metagame {
	import Metagame.Stars.Starfield;
	import org.flixel.FlxState;
	import Controls.ControlSet;
	import org.flixel.FlxG;
	import MainMenu.MenuState;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class MapState extends FlxState {
		
		override public function create():void {
			add(new Starfield().render(FlxG.width / 2, FlxG.height / 2));
		}
		
		override public function update():void {
			super.update();
			
			if (ControlSet.CANCEL_KEY.justPressed())
				FlxG.state = new MenuState;
			//C.music.update();
		}
	}

}