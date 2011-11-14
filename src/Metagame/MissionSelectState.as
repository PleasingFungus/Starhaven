package Metagame {
	import Controls.ControlSet;
	import MainMenu.MenuState;
	import MainMenu.StateThing;
	import Mining.MineralBlock;
	import org.flixel.*;
	import Scenarios.NebulaScenario;
	import Scenarios.PlanetScenario;
	import Scenarios.AsteroidScenario;
	import Mining.Terrain;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MissionSelectState extends FlxState {
		
		protected const SCENARIO_TYPES:Array = [PlanetScenario, AsteroidScenario, NebulaScenario];
		
		override public function create():void {
			if (!C.campaign)
				C.campaign = new Campaign();
			else
				C.campaign.refresh();
			
			var title:FlxText = new FlxText(10, 10, FlxG.width - 20, "Mission Select");
			title.setFormat(C.TITLEFONT, 48, 0xffffff, 'center');
			add(title);
			
			var missionNo:FlxText = new FlxText(FlxG.width / 2, title.y + title.height + 5,
												FlxG.width/2 - 10, "Mission "+(C.campaign.missions + 1) + "/"+C.campaign.TOTAL_MISSIONS);
			missionNo.setFormat(C.FONT, 24, 0xffffff, 'right');
			add(missionNo);
			
			var collected:FlxText = new FlxText(FlxG.width / 2, missionNo.y + missionNo.height + 5,
												FlxG.width/2 - 10, "Mined: $"+C.campaign.minerals);
			collected.setFormat(C.FONT, 24, 0xffffff, 'right');
			add(collected);
			
			var goal:FlxText = new FlxText(FlxG.width / 2, collected.y + collected.height + 5,
												FlxG.width/2 - 10, "Goal: $"+C.campaign.goal);
			goal.setFormat(C.FONT, 24, 0xffffff, 'right');
			add(goal);
			
			//MenuThing.menuThings = []; //shenanagains
			for (var i:int = 0; i < 3; i++)
				addMission(i);
			
			//C.music.intendedMusic = Music.MENU_MUSIC;
			add(new StateThing("Cancel", MenuState));
		}
		
		protected function addMission(index:int):void {
			var randomScenario:int = FlxU.random() * SCENARIO_TYPES.length;
			add(new MissionChoice(SCENARIO_TYPES[randomScenario], 30, FlxG.height * (1/4) * (1 + index)));
		}
		
		
		override public function update():void {
			super.update();
			
			if (ControlSet.CANCEL_KEY.justPressed())
				FlxG.state = new MenuState;
			//C.music.update();
		}
	}

}