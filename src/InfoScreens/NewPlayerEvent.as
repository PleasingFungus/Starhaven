package InfoScreens {
	import Controls.ControlSet;
	import org.flixel.*;
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class NewPlayerEvent extends InfoScreen {
		
		public function NewPlayerEvent(Name:String, Descr:String, Scale:Number = 1) {
			super();
			bg.alpha = .65;
			
			var title:FlxText = new FlxText(0, 10, FlxG.width, Name);
			title.setFormat(C.TITLEFONT, 32, 0xffffff, 'center');
			add(title);
			
			FlxG.quake.stop(); //so the screen doesn't vibrate while you're trying to read!
			
			var description:FlxText = new FlxText(40, title.y + title.height + 15, FlxG.width - 80, Descr);
			description.setFormat(C.BLOCKFONT, 16 * Scale, 0xffffff);
			add(description);
		}
		
		public static function onFirstDisconnect():NewPlayerEvent {
			var title:String = "Module Not Connected To Grid";
			var description:String = "The module you just dropped is darkened, and maybe even showing a red NO POWER icon.\n\n";
			description += "This is because it's not connected to the grid! To be powered, a module needs to be adjacent to a powered conduit, or to a power source, such as a solar panel or the station's core reactor.\n\n";
			description += "But don't panic! Just hook up a powered conduit to the module, it'll start working properly.";
			
			seen[DISCONNECT] = true;
			saveSeen();
			
			return new NewPlayerEvent(title, description);
		}
		
		public static function onFirstUncrewed():NewPlayerEvent {
			var title:String = "Inadequate Staff";
			var description:String = "The module you just dropped is darkened, and maybe even showing a red NO CREW icon.\n\n";
			description += "It needs crew. But don't panic! Drop a barracks next to it, and once both this module and the barracks are powered, crew will automatically move over and start to work.";
			description += "Piece of cake!";
			
			seen[DECREW] = true;
			saveSeen();
			
			return new NewPlayerEvent(title, description);
		}
		
		public static function onFirstSubmerged():NewPlayerEvent {
			var title:String = "Module Underwater!";
			var description:String = "The module you just dropped is darkened, and has a red water drop over it.\n\n";
			description += "That's because you put it underwater! Modules can't get power underwater. They'd short out!\n\n";
			description += "Scoops work without power, but everything else should stay above the water line.";
			
			seen[SUBMERGE] = true;
			saveSeen();
			
			return new NewPlayerEvent(title, description);
		}
		
		public static function onFirstAsteroids():NewPlayerEvent {
			var title:String = "Asteroids!";
			var description:String = "Oh no! A wave of asteroids is hurling straight toward your station! Soon red dots will start appearing all around, showing the direction they're coming from. But their destination is always the same: your station's core! And if they hit it - well, that's GAME OVER.\n\n";
			description += "Any Defense Beams you've powered and crewed will fire at asteroids automatically - try to position them to fire on asteroids, by rotating the station [if applicable.]\n\n";
			description += "Barring that, you may be able to rotate the station to put something inessential between the incoming asteroids and your core.\n\n";
			description += "Best of luck!\n\n"
			
			seen[ASTEROIDS] = true;
			saveSeen();
			
			return new NewPlayerEvent(title, description);
		}
		
		public static function miningTutorial():NewPlayerEvent {
			var title:String = "Mining and Power!";
			var description:String = "You control power conduits and drills that will start falling from the sky as soon as you press " + ControlSet.CONFIRM_KEY + ". ";
			description += "Use the drills to harvest minerals from the purple mineral clusters in the ground, and the conduits to connect to the drills to the station core and collect their minerals. ";
			description += "\n\nIf you make a mistake, each drill comes with a single bomb, dropped with '" + ControlSet.BOMB_KEY + "'; you can use those to blow up misplaced parts. (But don't blow up the station core!) ";
			description += "\n\nTo succeed, just collect 75% of the minerals present; you can check your progress in the bottom-left. Go to it!";
			
			return new NewPlayerEvent(title, description, 0.8);
		}
		
		public static function housingTutorial():NewPlayerEvent {
			var title:String = "Housing and Launching!";
			var description:String = "Once you collect minerals, you need to launch them back to your home-base (offscreen).\n\n";
			description += "To do this, you'll need to use two new modules. Blue barracks, which provide crew to adjacent modules, and green launchers, which provide one-man mineral rockets.\n\n";
			description += "Power both, use them together, and you'll be done in no time!";
			
			return new NewPlayerEvent(title, description, 0.8);
		}
		
		public static const DISCONNECT:int = 0;
		public static const DECREW:int = 1;
		public static const SUBMERGE:int = 2;
		public static const ASTEROIDS:int = 6;
		
		private static function saveSeen():void {
			if (!(C.DEBUG && C.FORGET_EVENTS))
				C.save.write("Seen Events", seen);
		}
		
		public static var seen:Array;
		public static function init():void {
			if (!(C.DEBUG && C.FORGET_EVENTS))
				seen = C.save.read("Seen Events") as Array;
			if (!seen)
				seen = [];
		}
	}

}