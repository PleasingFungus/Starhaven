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
		public function CampaignState(Done:Boolean = false) {
			super();
			done = Done;
		}
		
		private var screenshotGroup:FlxGroup;
		private var statGroup:FlxGroup;
		override public function create():void {
			super.create();
			
			C.campaign.refresh();
			
			var title:FlxText = new FlxText(10, 10, FlxG.width - 20, done ? "Game Over" : "Stats");
			title.setFormat(C.TITLEFONT, 48, 0xffffff, 'center');
			add(title);
		
			add(screenshotGroup = C.campaign.renderScreenshots(title.y + title.height + 55));
			add(statGroup = C.campaign.statblock.createDisplay(title.y + title.height + 20));
			screenshotGroup.alpha = 0.5;
			
			var hintText:FlxText = new FlxText(10, FlxG.height - 95, FlxG.width -20, "Press " + ControlSet.BOMB_KEY + " to toggle stats.");
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
		}
		
		override public function update():void {
			super.update();
			
			if (ControlSet.CANCEL_KEY.justPressed())
				FlxG.state = new MenuState;
			else if (ControlSet.BOMB_KEY.justPressed())
				switchLayers();
		}
		
		private function switchLayers():void {
			statGroup.visible = !statGroup.visible;
			screenshotGroup.alpha = statGroup.visible ? 0.5 : 1;
		}
		
	}

}