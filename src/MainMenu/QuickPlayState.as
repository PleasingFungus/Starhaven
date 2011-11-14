package MainMenu {
	import org.flixel.*;
	import Scenarios.*;
	import Controls.ControlSet;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class QuickPlayState extends FlxState {
		
		override public function create():void {
			var title:FlxText = new FlxText(10, 20, FlxG.width - 20, "Quick Play");
			title.setFormat(C.TITLEFONT, 48, 0xffffff, 'center');
			add(title);
			
			MenuThing.menuThings = [];
			MenuThing.columns = [];
			var leftCol:Array = [];
			leftCol.push(add(new DifficultyThing("Normal", Difficulty.NORMAL)));
			leftCol.push(add(new DifficultyThing("Hard", Difficulty.HARD)));
			MenuThing.addColumn(leftCol, FlxG.width/8);
			
			
			var rightCol:Array = [];
			rightCol.push(add(new StateThing("Asteroid", AsteroidScenario)));
			rightCol.push(add(new StateThing("Planet", PlanetScenario)));
			rightCol.push(add(new StateThing("Nebula", NebulaScenario)));
			rightCol.push(add(new StateThing("Water", WaterScenario)));
			//rightCol.push(add(new StateThing("Trench", TrenchScenario)));
			//rightCol.push(add(new StateThing("Derelict", ShipScenario)));
			rightCol.push(add(new StateThing("Belt", BeltScenario)));
			MenuThing.addColumn(rightCol, FlxG.width * 5 / 8);
			
			
			MenuThing.menuThings[MenuThing.menuThings.indexOf(rightCol[0])].select();
			
			//var info:FlxText = new FlxText(0, FlxG.height - 25, FlxG.width, "Use arrow keys to navigate and enter to select.");
			//info.setFormat(C.FONT, 12, 0xffffff, 'center');
			//add(info);
			
			//C.music.intendedMusic = Music.MENU_MUSIC;
			var cancelButton:StateThing = new StateThing("Cancel", MenuState);
			cancelButton.setY(FlxG.height - 60);
			add(cancelButton);
		}
		
		override public function update():void {
			super.update();
			
			if (ControlSet.CANCEL_KEY.justPressed())
				FlxG.state = new MenuState;
			//C.music.update();
		}
	}

}