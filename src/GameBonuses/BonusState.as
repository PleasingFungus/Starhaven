package GameBonuses {
	import GameBonuses.Attack.AttackScenario;
	import GameBonuses.Attack.AttackState;
	import GameBonuses.Collect.CollectScenario;
	import GameBonuses.Music.MusicTestState;
	import MainMenu.MysteryThing;
	import org.flixel.*;
	import MainMenu.MemoryThing;
	import MainMenu.MenuState;
	import Controls.ControlSet;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class BonusState extends FadeState {
		
		override public function create():void {
			super.create();
			loadBackground(BG, 0.5);
			
			var t:FlxText;
			
			t = new FlxText(0, 10, FlxG.width, "Bonuses");
			t.setFormat(C.TITLEFONT, 48, 0xffffff, 'center');
			add(t);
			
			MenuThing.resetThings();
			addBonus("Reverse Mode!", AttackState);
			if (C.DEBUG)
				addBonus("Collect Mode!", CollectScenario);
			addBonus("Music Test", MusicTestState);
			add(new MemoryThing("Back", MenuState));
		}
		
		protected function addBonus(name:String, bonus:Class):void {
			if (C.unlocks.bonusUnlocked(bonus) || C.UNLOCKS_DISABLED)
				add(new MemoryThing(name, bonus));
			else
				add(new MysteryThing());
		}
		
		override public function update():void {
			super.update();
			if (ControlSet.CANCEL_KEY.justPressed()) {
				fadeBackTo(MenuState);
			}
		}
		
		[Embed(source = "../../lib/art/backgrounds/menu/menu_bg_bonus.jpg")] private const BG:Class;
		
	}

}