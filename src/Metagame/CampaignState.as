package Metagame {
	import org.flixel.*;
	import MainMenu.StateThing;
	import MainMenu.MenuState;
	import MainMenu.DifficultyThing;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class CampaignState extends FlxState {
		
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
				
				add(new StateThing("Play", C.campaign.nextMission));
				add(new StateThing("Quit", MenuState));
			}
			
			
		}
		
	}

}