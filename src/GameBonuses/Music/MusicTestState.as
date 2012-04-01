package GameBonuses.Music 
{
	import Helpers.KeyHelper;
	import MainMenu.StateThing;
	import Musics.MusicTrack;
	import org.flixel.*;
	import MainMenu.MemoryThing;
	import Controls.ControlSet;
	import GameBonuses.BonusState;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MusicTestState extends FadeState 
	{
		
		private var tracks:Vector.<MusicTrack>
		public function MusicTestState() {
			tracks = new Vector.<MusicTrack>;
			tracks.push(C.music.MENU_MUSIC);
			tracks.push(C.music.MOON_MUSIC);
			tracks.push(C.music.SEA_MUSIC);
			tracks.push(C.music.LAND_COMBAT_MUSIC);
			tracks.push(C.music.AST_MUSIC);
			tracks.push(C.music.DUST_MUSIC);
			tracks.push(C.music.SPACE_COMBAT_MUSIC);
			//tracks.push(C.music.VICTORY_MUSIC);
			//tracks.push(C.music.DEFEAT_MUSIC);
		}
		
		override public function create():void {
			super.create();
			//loadBackground(BG, 0.5);
			
			var t:FlxText;
			
			t = new FlxText(0, 10, FlxG.width, "Music Test");
			t.setFormat(C.TITLEFONT, 48, 0xffffff, 'center');
			add(t);
			
			add(new MusicName(0, t.y + t.height + 20, FlxG.width));
			
			//add music togglers (arrows)
			var leftArrow:KeyHelper = new KeyHelper(ControlSet.LEFT_KEY);
			leftArrow.x = 32;
			var rightArrow:KeyHelper = new KeyHelper(ControlSet.RIGHT_KEY);
			rightArrow.x = FlxG.width - rightArrow.width - 32;
			leftArrow.y = rightArrow.y = t.y + t.height + 60;
			add(leftArrow);
			add(rightArrow);
			
			//add art
			add(new TrackArt(80, 120));
			
			//TODO: add musician credits
			
			MenuThing.resetThings();
			var backButton:MenuThing = new StateThing("Back", BonusState);
			backButton.setY(FlxG.height - 50);
			add(backButton);
		}
		
		override public function update():void {
			super.update();
			if (ControlSet.CANCEL_KEY.justPressed())
				fadeBackTo(BonusState);
			else if (ControlSet.LEFT_KEY.justPressed())
				C.music.forceSwap(tracks[(tracks.indexOf(C.music.normalMusic) + tracks.length - 1) % tracks.length]);
			else if (ControlSet.RIGHT_KEY.justPressed())
				C.music.forceSwap(tracks[(tracks.indexOf(C.music.normalMusic) + 1) % tracks.length]);
			
			if (C.music.done)
				C.music.forceSwap(tracks[tracks.indexOf(C.music.normalMusic)]);
		}
	}

}