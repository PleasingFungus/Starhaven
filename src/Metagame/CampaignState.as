package Metagame {
	import Controls.ControlSet;
	import MainMenu.*;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class CampaignState extends FadeState {
		
		private var done:Boolean;
		
		private var screenshotGroup:FlxGroup;
		private var statGroup:FlxGroup;
		private var unlockGroup:FlxGroup;
		
		public function CampaignState(Done:Boolean = false) {
			super();
			done = Done;
		}
		
		override public function create():void {
			super.create();
			if (done)
				loadBackground(LOSE_BG, 0.65);
			//loadBackground(done ? LOSE_BG : WIN_BG, 0.65);
			
			C.campaign.refresh();
			
			var title:FlxText = new FlxText(10, 10, FlxG.width - 20, done ? "Game Over" : "Stats");
			title.setFormat(C.TITLEFONT, 48, 0xffffff, 'center');
			add(title);
		
			var statDisplayY:int = title.y + title.height + 55;
			add(screenshotGroup = C.campaign.renderScreenshots(statDisplayY));
			add(statGroup = C.campaign.statblock.createDisplay(statDisplayY, C.accomplishments.bestStats));
			unlockGroup = C.unlocks.createDisplay(statDisplayY);
			if (unlockGroup) {
				add(unlockGroup);
				statGroup.alpha = 0.25;
				screenshotGroup.alpha = 0.25;
			} else
				screenshotGroup.alpha = 0.5;
			
			var hintText:FlxText = new FlxText(10, FlxG.height - 90, FlxG.width -20, "Press " + ControlSet.BOMB_KEY + " to toggle stats.");
			hintText.setFormat(C.FONT, 12, 0xffffff, 'center');
			add(hintText);
			
			MenuThing.resetThings();
			
			var mission:Class = C.campaign.nextMission();
			C.campaign.chooseMission(mission);
			
			if (done)
				MenuThing.addColumn([add(new StateThing("Try Again", FullGameState))], FlxG.width/8);
			else
				MenuThing.addColumn([add(new StateThing("Continue", mission))], FlxG.width/8);
			MenuThing.addColumn([add(new StateThing(done ? "Quit" : "Back to Menu", MenuState))], FlxG.width * 5 / 8);
			
			for each (var option:MenuThing in MenuThing.menuThings)
				option.setY(FlxG.height - 40);
			MenuThing.menuThings[0].select();
			
			C.music.intendedMusic = C.music.MENU_MUSIC;
		}
		
		override public function update():void {
			super.update();
			
			if (ControlSet.CANCEL_KEY.justPressed())
				FlxG.state = new MenuState;
			else if (ControlSet.BOMB_KEY.justPressed())
				switchLayers();
		}
		
		private function switchLayers():void {
			if (unlockGroup) {
				if (unlockGroup.visible) {
					unlockGroup.visible = false;
					statGroup.alpha = 1;
					screenshotGroup.alpha = 0.5;
				} else if (statGroup.visible) {
					statGroup.visible = false;
					screenshotGroup.alpha = 1;
				} else {
					unlockGroup.visible = true;
					statGroup.visible = true;
					statGroup.alpha = 0.25;
					screenshotGroup.alpha = 0.25;
				}
			} else {
				statGroup.visible = !statGroup.visible;
				screenshotGroup.alpha = statGroup.visible ? 0.5 : 1;
			}
		}
		
		[Embed(source = "../../lib/art/backgrounds/menu/menu_bg_x2.jpg")] private const WIN_BG:Class;
		[Embed(source = "../../lib/art/backgrounds/menu/defeat_bg2.jpg")] private const LOSE_BG:Class;
		
	}

}