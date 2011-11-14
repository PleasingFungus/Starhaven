package MainMenu {
	import org.flixel.*;
	import Scenarios.Puzzles.*;
	
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class PuzzleState extends FlxState {
		
		override public function create():void {
			var t:FlxText;
			
			t = new FlxText(0, 20, FlxG.width, "Puzzles");
			t.setFormat(C.TITLEFONT, 48, 0xffffff, 'center');
			add(t);
			
			var scenarios:Array = [PuzzlePowerEasy];
			MenuThing.menuThings = [];
			for each (var scenario:Class in scenarios)
				add(new StateThing(scenario.name, scenario));
			add(new StateThing("Back", MenuState));
			
			FlxG.mouse.show();
		}
		
	}

}