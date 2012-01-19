package MainMenu {
	import Metagame.Campaign;
	import org.flixel.*;
	import Controls.ControlSet;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class FullGameState extends FadeState {
		
		override public function create():void {
			super.create();
			
			if (C.campaign)
				C.campaign.die();
			C.campaign = new Campaign();
			
			var title:FlxText = new FlxText(10, 20, FlxG.width - 20, "Full Game");
			title.setFormat(C.TITLEFONT, 48, 0xffffff, 'center');
			add(title);
			
			MenuThing.resetThings();
			
			C.difficulty.setting = 2;
			var leftCol:Array = [];
			for (var i:int = 0; i < C.difficulty.MAX_DIFFICULTY; i++)
				leftCol.push(add(new DifficultyThing(C.difficulty.name(i), i)));
			MenuThing.addColumn(leftCol, FlxG.width/8);
			
			
			var mission:Class = C.campaign.nextMission();
			C.campaign.chooseMission(mission);
			var rightCol:Array = [];
			rightCol.push(add(new StateThing("Play!", mission)));
			MenuThing.addColumn(rightCol, FlxG.width * 5 / 8);
			
			MenuThing.menuThings[MenuThing.menuThings.indexOf(rightCol[0])].select();
			
			//C.music.intendedMusic = Music.MENU_MUSIC;
			var cancelButton:StateThing = new StateThing("Cancel", MenuState);
			cancelButton.setY(FlxG.height - 60);
			add(cancelButton);
		}
		
		override public function update():void {
			super.update();
			
			if (ControlSet.CANCEL_KEY.justPressed())
				fadeTo(MenuState);
			//C.music.update();
		}
		
	}

}