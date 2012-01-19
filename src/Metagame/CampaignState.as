package Metagame {
	import Controls.ControlSet;
	import MainMenu.*;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class CampaignState extends FlxState {
		
		private var done:Boolean;
		public function CampaignState(Done:Boolean = false) {
			super();
			done = Done;
		}
		
		private var livesText:FlxText;
		override public function create():void {
			C.campaign.refresh();
			
			var title:FlxText = new FlxText(10, 10, FlxG.width - 20, done ? "Mission Over!" : "Stats");
			title.setFormat(C.TITLEFONT, 48, 0xffffff, 'center');
			add(title);
		
			var screenshotGroup:FlxGroup = C.campaign.renderScreenshots(title.y + title.height + 80);
			var statGroup:FlxGroup = C.campaign.statblock.createDisplay(title.y + title.height + 40);
			add(screenshotGroup);
			add(statGroup);
			screenshotGroup.alpha = 0.5;
			
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
			
			FlxG.mouse.show();
		}
		
		override public function update():void {
			super.update();
			
			if (ControlSet.CANCEL_KEY.justPressed())
				FlxG.state = new MenuState;
		}
		
	}

}