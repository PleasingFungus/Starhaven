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
			
			MenuThing.menuThings = [];
			if (!C.campaign.missionNo) {
				MenuThing.columns = [];
				
				var leftCol:Array = [];
				leftCol.push(add(new DifficultyThing("Normal", Difficulty.NORMAL)));
				leftCol.push(add(new DifficultyThing("Hard", Difficulty.HARD)));
				MenuThing.addColumn(leftCol, FlxG.width / 8);
				
				var rightCol:Array = [];
				rightCol.push(add(new StateThing("Play", C.campaign.nextMission)));
				rightCol.push(add(new StateThing("Cancel", MenuState)));
				MenuThing.addColumn(rightCol, FlxG.width * 5 / 8);
				
				MenuThing.menuThings[MenuThing.menuThings.indexOf(rightCol[0])].select();
			} else {
				var missionNo:FlxText = new FlxText(10, title.y + title.height + 5,
													FlxG.width - 20, "Mission "+(C.campaign.missionNo + 1)+" - "+C.difficulty.name());
				missionNo.setFormat(C.FONT, 24, 0xffffff, 'center');
				add(missionNo);
			
				var ss_cols:int = 3;
				var ss_buffer:int = 15;
				for (var i:int = 0; i < C.campaign.screenshots.length; i++) {
					var ss:FlxSprite = new FlxSprite();
					ss.x = (i % ss_cols - ss_cols/2) * (Campaign.SCREENSHOT_SIZE.x + ss_buffer) + FlxG.width / 2;
					ss.y = Math.floor(i / ss_cols) * (Campaign.SCREENSHOT_SIZE.y + ss_buffer) + missionNo.y + missionNo.height + ss_buffer;
													 //120 is correct w/o play button
					ss.pixels = C.campaign.screenshots[i];
					ss.frame = 0;
					add(ss);
				}
			
				add(new LevelPreview((i % ss_cols - ss_cols / 2) * (Campaign.SCREENSHOT_SIZE.x + ss_buffer) + FlxG.width / 2,
									 Math.floor(i / ss_cols) * (Campaign.SCREENSHOT_SIZE.y + ss_buffer) + missionNo.y + missionNo.height + ss_buffer,
									 C.campaign.nextMission));
				
				var quitThing:StateThing = new StateThing(C.campaign.missionNo ? "Quit" : "Cancel", MenuState);
				quitThing.setY(FlxG.height - 65);
				add(quitThing);
			}
			
			livesText = new FlxText(10, FlxG.height - 25, FlxG.width - 20, "Lives: " + C.campaign.lives);
			livesText.setFormat(C.FONT, 16, 0xffffff, 'center');
			add(livesText);
			
			FlxG.mouse.show();
		}
		
		override public function update():void {
			super.update();
			if (!C.campaign)
				C.campaign = new Campaign();
			if (!C.campaign.missionNo) {
				C.campaign.lives = C.difficulty.hard ? 1 : 2;
				livesText.text = "Lives: " + C.campaign.lives;
			}
			if (ControlSet.CANCEL_KEY.justPressed())
				FlxG.state = new MenuState;
		}
		
	}

}