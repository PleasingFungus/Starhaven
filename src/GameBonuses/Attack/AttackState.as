package GameBonuses.Attack {
	import MainMenu.MemoryThing;
	import org.flixel.*;
	import Controls.ControlSet;
	import GameBonuses.BonusState;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class AttackState extends FadeState {
		
		override public function create():void {
			super.create();
			loadBackground(BG, 0.5);
			
			var t:FlxText;
			
			t = new FlxText(0, 10, FlxG.width, "Reverse Mode!");
			t.setFormat(C.TITLEFONT, 48, 0xffffff, 'center');
			add(t);
			
			MenuThing.resetThings();
			add(new MemoryThing("Level 1", AttackLevelOne));
			add(new MemoryThing("Level 2", AttackLevelTwo));
			add(new MemoryThing("Back", BonusState));
		}
		
		override public function update():void {
			super.update();
			if (ControlSet.CANCEL_KEY.justPressed()) {
				fadeBackTo(BonusState);
			}
		}
		
		[Embed(source = "../../../lib/art/backgrounds/menu/menu_bg_bonus.jpg")] private const BG:Class;
		
	}

}