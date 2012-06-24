package InfoScreens {
	import Controls.ControlSet;
	import org.flixel.*;
	import Sminos.LongDrill;
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class NewPlayerEvent extends InfoScreen {
		
		public function NewPlayerEvent(Name:String, Descr:String, Scale:Number = 1) {
			super(SetInfopauseState);
			
			var title:FlxText = new FlxText(0, 10, FlxG.width, Name);
			title.setFormat(C.TITLEFONT, 32, 0xffffff, 'center');
			add(title);
			
			FlxG.quake.stop(); //so the screen doesn't vibrate while you're trying to read!
			
			var description:FlxText = new FlxText(40, title.y + title.height + 15, FlxG.width - 80, Descr);
			description.setFormat(C.BLOCKFONT, 16 * Scale, 0xffffff);
			add(description);
		}
		
		override public function render():void {
			alpha = 1;
			bg.alpha = 0.75;
			super.render();
		}
		
		private static function onFirstDisconnect():NewPlayerEvent {
			var title:String = "Module Not Connected To Grid";
			var description:String = "The module you just dropped is darkened, and maybe even showing a red NO POWER icon.\n\n";
			description += "This is because it's not connected to the grid! To be powered, a module needs to be adjacent to a powered conduit, or to a power source, such as a solar panel or the station's core reactor.\n\n";
			description += "But don't panic! Just hook up a powered conduit to the module, it'll start working properly.";
			
			return new NewPlayerEvent(title, description);
		}
		
		private static function onFirstUncrewed():NewPlayerEvent {
			var title:String = "Inadequate Staff";
			var description:String = "The module you just dropped is darkened, and maybe even showing a red NO CREW icon.\n\n";
			description += "It needs crew. But don't panic! Drop a barracks next to it, and once both this module and the barracks are powered, crew will automatically move over and start to work. ";
			description += "Piece of cake!";
			
			return new NewPlayerEvent(title, description);
		}
		
		private static function onFirstSubmerged():NewPlayerEvent {
			var title:String = "Module Underwater!";
			var description:String = "The module you just dropped is darkened, and has a red water drop over it.\n\n";
			description += "That's because you put it underwater! Modules can't get power underwater. They'd short out!\n\n";
			description += "Scoops work without power, but everything else should stay above the water line.";
			
			return new NewPlayerEvent(title, description);
		}
		
		private static function onFirstMeteoroids():NewPlayerEvent {
			var title:String = "Meteors Incoming!";
			var description:String = "Red arrows are about to appear in the sky. They indicate where the meteors will come from, and where they're going.\n\n"
			description += "Use mouse or keyboard to position your targeting cursor, and then fire by clicking or pressing "+ControlSet.BOMB_KEY+" to launch a rocket from the nearest gun.\n\n";
			description += "Try aiming ahead of the meteors to detonate the rockets where they will be, not where they are!";
			
			return new NewPlayerEvent(title, description);
		}
		
		public static function miningTutorial():NewPlayerEvent {
			var tut:NewPlayerEvent = new NewPlayerEvent(" ", " ");
			tut.add(Mino.layer.add(new LongDrill(3, 3)));
			
			return tut;
		}
		
		public static function housingTutorial():NewPlayerEvent {
			var tut:NewPlayerEvent = new NewPlayerEvent(" ", " ");
			tut.add(new FlxSprite().loadGraphic(_launching_glyphs));
			return tut;
		}
		
		public static function defenseTutorial():NewPlayerEvent {
			var tut:NewPlayerEvent = new NewPlayerEvent(" ", " ");
			tut.add(new FlxSprite().loadGraphic(_meteo_glyphs));
			return tut;
		}
		
		public static function rotationMinitutorial():NewPlayerEvent {
			var title:String = "Station Rotation!";
			var description:String = "When mining in deep space - as you are now - you can rotate your entire station at will. ";
			description += "Do so by holding " + ControlSet.ST_CW_KEY + " or " + ControlSet.ST_CCW_KEY + ".\n\n";
			if (C.NO_COMBAT_ROTATING)
				description += "This ability is temporarily disabled during meteoroid showers, so plan accordingly!";
			
			return new NewPlayerEvent(title, description);
		}
		
		public static function nebulaMinitutorial():NewPlayerEvent {
			var title:String = "Nebulas!";
			var description:String = "Nebulas are filled with mineral-rich gasses, thin enough to pass through but rife with precious elements. ";
			description += "To mine them, you must use Accumulators - when anchored, they suck up all minerals within their radius.\n\n";
			
			return new NewPlayerEvent(title, description);
		}
		
		public static function waterMinitutorial():NewPlayerEvent {
			var title:String = "Water and Scoops!";
			var description:String = "Mining beneath an alien sea is a tricky business. Many modules, including barracks, launchers, and drills, simply won't work, though thankfully your conduits ARE waterproofed.\n\n";
			description += "So instead of drills, you'll use scoops - designed to sink to the bottom of the sea, then drill through rock and liberate the minerals within to float to the surface.\n\n";
			description += "And once the minerals hit the surface, you can collect them with any powered module!";
			
			return new NewPlayerEvent(title, description);
		}
		
		public static function fire(event:int):void {
			if (!seen[event]) {
				C.hudLayer.add(EVENTS[event]());	
				
				seen[event] = true;
				saveSeen();
			}
		}
		
		public static const DISCONNECT:int = 0;
		public static const DECREW:int = 1;
		public static const SUBMERGE:int = 2;
		public static const METEOROIDS:int = 6;
		public static const ROTATEABLE:int = 11;
		public static const NEBULA:int = 12;
		public static const WATER:int = 13;
		private static const EVENTS:Vector.<Function> = new Vector.<Function>(20);
		
		public static var SetInfopauseState:Function;
		
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
			
			EVENTS[DISCONNECT] = onFirstDisconnect;
			EVENTS[DECREW] = onFirstUncrewed;
			EVENTS[SUBMERGE] = onFirstSubmerged;
			EVENTS[METEOROIDS] = onFirstMeteoroids;
			EVENTS[ROTATEABLE] = rotationMinitutorial;
			EVENTS[NEBULA] = nebulaMinitutorial;
			EVENTS[WATER] = waterMinitutorial;
		}
		
		//[Embed(source = "../../lib/art/tutorial/mining_tutorial_drill.png")] private static const _mining_tutorial_drill:Class;
		[Embed(source = "../../lib/art/tutorial/mining_glyphs.png")] private static const _mining_glyphs:Class;
		[Embed(source = "../../lib/art/tutorial/launching_glyphs.png")] private static const _launching_glyphs:Class;
		[Embed(source = "../../lib/art/tutorial/meteo_glyphs.png")] private static const _meteo_glyphs:Class;
	}

}