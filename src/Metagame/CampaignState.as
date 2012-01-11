package Metagame {
	import Controls.ControlSet;
	import MainMenu.LevelPreview;
	import org.flixel.*;
	import MainMenu.StateThing;
	import MainMenu.MenuState;
	import MainMenu.DifficultyThing;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class CampaignState extends FlxState {
		
		private var livesText:FlxText;
		override public function create():void {
			if (!C.campaign)
				C.campaign = new Campaign();
			else
				C.campaign.refresh();
			
			var title:FlxText = new FlxText(10, 10, FlxG.width - 20, "Campaign");
			title.setFormat(C.TITLEFONT, 48, 0xffffff, 'center');
			add(title);
			
			var quitThing:StateThing;
			
			var mission:Class = C.campaign.nextMission();
			C.campaign.chooseMission(mission);
			C.difficulty.setting = 0;
			
			MenuThing.resetThings();
			if (!C.campaign.missionNo) {
				add(new LevelPreview(FlxG.width / 2 - Campaign.SCREENSHOT_SIZE.x/2,
									 FlxG.height / 2 - Campaign.SCREENSHOT_SIZE.y/2,
									 mission));
				
				var midCol:Array = [];
				quitThing = new StateThing("Cancel", MenuState);
				midCol.push(add(quitThing));
				MenuThing.addColumn(midCol, FlxG.width * 7 / 16);
				quitThing.setY(FlxG.height - 65);
			} else {
				var missionNo:FlxText = new FlxText(10, title.y + title.height + 5,
													FlxG.width - 20, "Mission "+(C.campaign.missionNo + 1)+" - "+C.difficulty.name());
				missionNo.setFormat(C.FONT, 24, 0xffffff, 'center');
				add(missionNo);
			
				var ss_cols:int = 3;
				var ss_buffer:int = 15;
				var first_ss:int = Math.max(0, C.campaign.screenshots.length - 5);
				for (var i:int = first_ss; i < C.campaign.screenshots.length; i++) {
					var ss:FlxSprite = new FlxSprite();
					
					var adjusted_i:int = i - first_ss;
					ss.x = (adjusted_i % ss_cols - ss_cols/2) * (Campaign.SCREENSHOT_SIZE.x + ss_buffer) + FlxG.width / 2;
					ss.y = Math.floor(adjusted_i / ss_cols) * (Campaign.SCREENSHOT_SIZE.y + ss_buffer) + missionNo.y + missionNo.height + ss_buffer;
													 //120 is correct w/o play button
					ss.pixels = C.campaign.screenshots[i];
					ss.frame = 0;
					add(ss);
				}
			
				adjusted_i = i - first_ss;
				add(new LevelPreview((adjusted_i % ss_cols - ss_cols / 2) * (Campaign.SCREENSHOT_SIZE.x + ss_buffer) + FlxG.width / 2,
									 Math.floor(adjusted_i / ss_cols) * (Campaign.SCREENSHOT_SIZE.y + ss_buffer) + missionNo.y + missionNo.height + ss_buffer,
									 mission));
				
				quitThing = new StateThing("Quit", MenuState);
				quitThing.setY(FlxG.height - 65);
				add(quitThing);
			}
			
			FlxG.mouse.show();
		}
		
		override public function update():void {
			super.update();
			if (!C.campaign)
				C.campaign = new Campaign();
			
			if (ControlSet.CANCEL_KEY.justPressed())
				FlxG.state = new MenuState;
		}
		
	}

}