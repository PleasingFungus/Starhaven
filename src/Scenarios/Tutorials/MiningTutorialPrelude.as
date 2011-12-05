package Scenarios.Tutorials {
	import Controls.ControlSet;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class MiningTutorialPrelude extends FlxState {
		
		override public function create():void {
			
		}
		
		override public function update():void {
			super.update();
			if (ControlSet.CONFIRM_KEY.justPressed())
				FlxG.state = new MiningTutorial();
		}
	}

}