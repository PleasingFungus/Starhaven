package Options {
	import Credits.TitledColumn;
	import MainMenu.StateThing;
	import org.flixel.*;
	import Controls.ControlSet;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class UnlocksState extends FadeState {
		
		override public function create():void {
			super.create();
			loadBackground(BG, 0.8);
			
			var t:FlxText;
			
			t = new FlxText(0, 10, FlxG.width, "Unlocks");
			t.setFormat(C.TITLEFONT, 48, 0xffffff, 'center');
			add(t);
			
			MenuThing.resetThings();
			var backButton:StateThing = new StateThing("Back", OptionsState);
			backButton.setY(FlxG.height - 40);
			add(backButton);
			
			genVisibleUnlocks();
			genUnlockOption();
		}
		
		protected function genVisibleUnlocks():void {
			var text:String;
			
			var scenarios:TitledColumn = new TitledColumn(FlxG.width / 4, FlxG.height * 3/16, "Scenarios");
			text = C.ALL_UNLOCKED ? "All Unlocked" : C.unlocks.unlockedScenarios() + "/" + (C.scenarioList.LAST_SCENARIO_INDEX - C.scenarioList.FIRST_SCENARIO_INDEX + 1);
			scenarios.addCol(text);
			add(scenarios);
			
			var difficulties:TitledColumn = new TitledColumn(FlxG.width * 3 / 4, FlxG.height * 3/16, "Difficulties");
			text = C.ALL_UNLOCKED ? "All Unlocked" : C.unlocks.unlockedDifficulties() + "/" + C.difficulty.MAX_DIFFICULTY;
			difficulties.addCol(text);
			add(difficulties);
			
			var sizes:TitledColumn = new TitledColumn(FlxG.width * 1 / 4, FlxG.height * 3/8, "Sizes");
			text = C.ALL_UNLOCKED ? "All Unlocked" : C.unlocks.unlockedSizes() + "/" + C.difficulty.MAX_SIZE;
			sizes.addCol(text);
			add(sizes);
			
			var other:TitledColumn = new TitledColumn(FlxG.width * 3 / 4, FlxG.height * 3/8, "Other");
			text = C.unlocks.unlockedBonuses() + "/" + C.unlocks.maxBonuses();
			other.addCol(text);
			add(other);
			
		}
		
		
		protected function genUnlockOption():void {
			var warningText:String = "Warning: using the 'unlock all' button will disable saving! " +
									 "(And may spoil the fun of unlocking things yourself.)";
			var advisoryText:String = "Pressing this button will re-enable saving and return you to whatever you had previously unlocked.";
			var warning:FlxText = new FlxText(10, FlxG.height * 19/32, FlxG.width - 20, C.ALL_UNLOCKED ? advisoryText : warningText);
			warning.setFormat(C.FONT, 16, 0xffffff, 'center');
			add(warning);
			
			var unlockButton:MenuThing = new MenuThing(C.ALL_UNLOCKED ? "Return to Normal" : "Unlock All", toggleUnlock);
			unlockButton.setFormat(C.FONT, 24);
			unlockButton.setY(FlxG.height * 24/32);
			add(unlockButton);
		}
		
		protected function toggleUnlock(_:String):void {
			C.ALL_UNLOCKED = !C.ALL_UNLOCKED;
			C.save.write("ALL_UNLOCKED", C.ALL_UNLOCKED);
			C.netStats.toggleUnlocks();
			defaultGroup.members = [];
			FlxG.state = new UnlocksState
		}
		
		override public function update():void {
			super.update();
			if (ControlSet.CANCEL_KEY.justPressed()) {
				fadeBackTo(OptionsState);
			}
		}
		
		[Embed(source = "../../lib/art/backgrounds/menu/menu_bg_5s.jpg")] private const BG:Class;
	}

}