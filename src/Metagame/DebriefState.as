package Metagame {
	import MainMenu.MenuState;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author ...
	 */
	public class DebriefState extends FlxState {
		
		private var endCause:int;
		private var mineralsMined:int;
		private var mineralsSent:int;
		private var totalGain:int;
		public function DebriefState(MineralsMined:int, MineralsSent:int, EndCause:int = MISSION_ABORTED) {
			super();
			mineralsMined = MineralsMined;
			mineralsSent = MineralsSent;
			endCause = EndCause;
			totalGain = mineralsMined * .5 + mineralsSent;
			
			if (C.campaign) {
				C.campaign.missions ++;
				C.campaign.minerals += totalGain;
			}
		}
		
		override public function create():void {
			var endMissionText:String = missionFailed ? "Mission Over" : "Mission Won";
			
			var title:FlxText = new FlxText(10, 10, FlxG.width - 20, endMissionText);
			title.setFormat(C.TITLEFONT, 48, 0xffffff, 'center');
			add(title);
			
			
			makeNumericField(80, "Minerals Sent: ", mineralsSent + "");
			makeNumericField(100, "Minerals Mined: ", mineralsMined + " * 50% = " + Math.floor(mineralsMined / 2));
			makeNumericField(120, "Minerals Gained: ", totalGain + "");
			if (C.campaign) {
				makeNumericField(140, "Previous Minerals: ", (C.campaign.minerals - totalGain) + "");
				makeNumericField(160, "Total Minerals: ", C.campaign.minerals+"");
			}
			
			var prompt:FlxText = new FlxText(10, FlxG.height - 40, FlxG.width - 20, "Click or 'enter' to continue");
			prompt.setFormat(C.FONT, 16, 0xffffff, 'center');
			add(prompt);
			
			//C.music.intendedMusic = Music.MENU_MUSIC;
			FlxG.mouse.show();
		}
		
		private function makeNumericField(Y:int, Label:String, Value:String):void {
			var label:FlxText = new FlxText(10, Y, FlxG.width - 50, Label);
			var value:FlxText = new FlxText(10, Y, FlxG.width - 50, Value);
			
			label.font = value.font = C.FONT;
			label.size = value.size = 16;
			value.alignment = 'right';
			
			add(label);
			add(value);
		}
		
		private function get missionFailed():Boolean {
			return endCause == MISSION_ABORTED || endCause == MISSION_EXPLODED;
		}
		
		override public function update():void {
			super.update();
			if (FlxG.mouse.justPressed() || FlxG.keys.anyKey()) {
				if (C.campaign)
					FlxG.state = new MissionSelectState;
				else
					FlxG.state = new MenuState;
			}
			//C.music.update();
		}
		
		public static const MISSION_ABORTED:int = 0;
		public static const MISSION_TIMEOUT:int = 1;
		public static const MISSION_MINEDOUT:int = 2;
		public static const MISSION_EXPLODED:int = 3;
	}

}