package  {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import Metagame.Accomplishments;
	import Metagame.Campaign;
	import Metagame.ScenarioList;
	import Metagame.Unlocks;
	import Musics.Mp3Music;
	import Musics.M4aMusic;
	import org.flixel.*;
	import Icons.NoCrewIcon;
	import Icons.NoPowerIcon;
	import SFX.EffectSound;
	import InfoScreens.NewPieceInfo;
	import InfoScreens.NewPlayerEvent;
	import Controls.ControlSet;
	import Globals.*;
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class C {
		public static const VERSION:String = "0.917";
		public static const DEBUG:Boolean = false;
		public static const DEBUG_COLOR:uint = 0xffff00ff;
		public static const DEBUG_SEED:Number = NaN;
		public static const BETA:Boolean = true;
		public static const MUSIC_LOCKED:Boolean = true;
		
		public static const DISPLAY_BOUNDS:Boolean = false;
		public static const DISPLAY_COLLISION:Boolean = false;
		public static const DISPLAY_DRAW_AREA:Boolean = false;
		public static const DISPLAY_FIRE_AREA:Boolean = false;
		public static const ALWAYS_SHOW_METEOROIDS:Boolean = false;
		public static const ALWAYS_SHOW_INCOMING:Boolean = false;
		
		public static const ANNOYING_NEW_PIECE_POPUP:Boolean = true;
		public static const AUDIO_DESCRIPTIONS:Boolean = true;
		public static const NO_CREW:Boolean = false;
		public static const NO_COMBAT_ROTATING:Boolean = false;
		public static const NO_REPORTING:Boolean = true;
		
		public static const FORGET_TUTORIALS:Boolean = false;
		public static const FORGET_EVENTS:Boolean = false;
		public static const FORGET_PIECES:Boolean = false;
		public static const FORGET_ACCOMPLISHMENTS:Boolean = false;
		public static const FORGET_UNLOCKS:Boolean = false;
		
		public static var HUD_ENABLED:Boolean = true;
		public static var IN_TUTORIAL:Boolean = false;
		public static var ALL_UNLOCKED:Boolean = false;
		
		public static const RENDER_THRUSTERS:Boolean = true;
		public static const HUD_FLICKERS:Boolean = true;
		public static var DRAW_GLOW:Boolean = true;
		public static var GLOW_SCALE:Number = 6;
		public static const GLOW_ALPHA:Number = 1;
		
		[Embed(source = "../lib/fonts/CryptOfTomorrow.ttf", fontFamily = "FUTUR")] private const _1:String;
		public static const TITLEFONT:String = "FUTUR";
		//[Embed(source = "../lib/fonts/StarPerv.ttf", fontFamily = "BLOCK")] private const _2:String;	//Old
		[Embed(source = "../lib/fonts/CPMono_v07_Plain.otf", fontFamily = "BLOCK")] private const _2:String; //+1
		public static const BLOCKFONT:String = "BLOCK";
		public static const FONT:String = "BLOCK";
		
		
		
		
		
		public static const BLOCK_SIZE:int = 16;
		public static const CYCLE_TIME:Number = .5;
		public static var B:Bounds;
		
		public static var accomplishments:Accomplishments;
		public static var campaign:Campaign;
		public static var difficulty:Difficulty;
		public static var fluid:Mino;
		public static var music:M4aMusic;
		public static var netStats:NetworkStats;
		public static var unlocks:Unlocks;
		public static var save:FlxSave;
		public static var scenarioList:ScenarioList;
		public static var sound:EffectSound;
		public static var timer:PlayTimer;
		
		public static function init():void {
			B = new Bounds;
			music = new M4aMusic;
			difficulty = new Difficulty;
			scenarioList = new ScenarioList;
			accomplishments = new Accomplishments;
			unlocks = new Unlocks;
			sound = new EffectSound;
			timer = new PlayTimer;
			netStats = new NetworkStats;
			netStats.init();
			
			
			ICONS[MINERALS] = _minerals_icon;
			ICONS[PEOPLE] = _crew_icon;
			ICONS[POWER] = _power_icon;
			ICONS[DAMAGE] = _damage_icon;
			ICONS[HOUSING] = _housing_icon;
			ICONS[WATER] = _water_icon;
			ICONS[GOODS] = _goods_icon;
			ICONS[METEOROIDS] = _meteoroids_icon;
			ICONS[MINOS] = _minos_icon;
			ICONS[TIME] = _time_icon;
			
			save = new FlxSave();
			save.bind("Starhaven");
		}
		
		public static function load():void {
			ALL_UNLOCKED = save.read("ALL_UNLOCKED");
			DRAW_GLOW = !save.read("DONT_DRAW_GLOW"); //default to on
			
			NewPieceInfo.init();
			NewPlayerEvent.init();
			ControlSet.load();
			difficulty.load();
			accomplishments.load();
			unlocks.load();
			sound.load();
			music.load();
			timer.load();
			netStats.load();
		}
		
		public static function toggleGlow(_:String=null):void {
			DRAW_GLOW = !DRAW_GLOW;
			save.write("DONT_DRAW_GLOW", !DRAW_GLOW); //shenanagains
		}
		
		
		
		public static var iconLayer:FlxGroup;
		public static var iconLeeches:Vector.<Mino>;
		public static var hudLayer:FlxGroup;
		public static var hudLeeches:Vector.<Mino>;
		
		public static function makeScenarioReady(minoLayer:FlxGroup, maxDim:Point):void {
			Mino.all_minos = [];
			B = new Bounds();
			B.maxDim = maxDim.clone();
			fluid = null;
			Mino.resetGrid();
			
			Mino.layer = minoLayer;
			iconLayer = new FlxGroup;
			iconLeeches = new Vector.<Mino>;
			hudLayer = new FlxGroup;
			hudLeeches = new Vector.<Mino>;
		}
		
		public static function get newMusicOK():Boolean {
			return !BETA || !MUSIC_LOCKED || DEBUG;
		}
		
		
		
		
		
		
		
		private static var initialBuffer:String = null;
		private static var printReady:Boolean = false;
		public static function setPrintReady():void {
			if (printReady)
				return;
			
			printReady = true;
			if (initialBuffer) {
				log(initialBuffer);
				initialBuffer = null;
			}
		}
		
		public static function log(...args):void {
			var outStr:String = "";
			if (args.length > 1)
				for each (var o:Object in args.slice(0, args.length - 1))
					outStr += o + ", ";
			
			outStr += args[args.length - 1];
			if (printReady)
				FlxG.log(outStr);
			else if (initialBuffer)
				initialBuffer += "\n" + outStr;
			else
				initialBuffer = outStr;
		}
		
		public static function weightedChoice(weights:Array):int {
			var total:Number = 0;
			for each (var weight:Number in weights)
				total += weight;
			
			var roll:Number = FlxU.random() * total;
			for (var i:int = 0; i < weights.length; i++) {
				if (roll < weights[i])
					return i;
				roll -= weights[i];
			}
			
			return i; //error!
		}
		
		public static function randomChoice(options:Array):* {
			return options[int(FlxU.random() * options.length)];
		}
		
		
		public static function renderTime(totalSeconds:int):String {
			var seconds:int = totalSeconds % 60;
			var minutes:int = totalSeconds / 60;
			return minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
		}
		
		public static function decimalize(a:Number, sigfigs:int = 4):String {
			var suffix:String = '';
			if (a >= 10000000) {
				a /= 1000000;
				suffix = "M";
			} else if (a >= 10000) {
				a /= 1000;
				suffix = "K";
			}
			
			var str:String = a + '';
			var decimalIndex:int = str.indexOf('.');
			if (decimalIndex == sigfigs || decimalIndex == -1)
				str = str.substr(0, sigfigs);
			else
				str = str.substr(0, sigfigs + 1);
			
			return str + suffix;
		}
		
		
		public static function interpolateColors(a:uint, b:uint, aFraction:Number):uint {
			var alpha:int = ((a >> 24) & 0xff) * aFraction + ((b >> 24) & 0xff) * (1 - aFraction);
			var red:int = ((a >> 16) & 0xff) * aFraction + ((b >> 16) & 0xff) * (1 - aFraction);
			var green:int = ((a >> 8) & 0xff) * aFraction + ((b >> 8) & 0xff) * (1 - aFraction);
			var blue:int = ((a >> 0) & 0xff) * aFraction + ((b >> 0) & 0xff) * (1 - aFraction);
			return (alpha << 24) | (red << 16) | (green << 8 ) | blue;
		}
		
		public static function HSVToRGB(H:Number, S:Number, V:Number):uint {
			var Chroma:Number = S * V;
			var Hp:Number = H * 6;
			var X:Number = Chroma * (1 - Math.abs(Hp % 2 - 1));
			var R:Number, G:Number, B:Number;
			switch (Math.floor(Hp)) {
				case 0: 
					R = Chroma;
					G = X;
					B = 0;
					break;
				case 1:
					R = X;
					G = Chroma;
					B = 0;
					break;
				case 2:
					R = 0;
					G = Chroma;
					B = X;
					break;
				case 3:
					R = 0;
					G = X;
					B = Chroma;
					break;
				case 4:
					R = X;
					G = 0;
					B = Chroma;
					break;
				case 5:
					R = Chroma;
					G = 0;
					B = X;
					break;
			}
			
			var m:Number = V - Chroma;
			
			var r:int = (R + m) * 255;
			var g:int = (G + m) * 255;
			var b:int = (B + m) * 255;
			return 0xff000000 | (r << 16) | (g << 8) | b;
		}
		
		
		public static function innerAngle(a:Point, b:Point):Number {
			return Math.acos(dot(a, b) / Math.abs(a.length * b.length));
		}
		
		public static function dot(a:Point, b:Point):Number {
			return a.x * b.x + a.y * b.y;
		}
		
		public static function resetMouse():void {
			FlxG.mouse.show();
			FlxG.mouse.unload();
		}
		
		
		public static const MINERALS:int = 0;
		public static const PEOPLE:int = 1;
		public static const POWER:int = 2;
		public static const DAMAGE:int = 3;
		public static const HOUSING:int = 4;
		public static const WATER:int = 5;
		public static const GOODS:int = 6;
		public static const METEOROIDS:int = 7;
		public static const MINOS:int = 8;
		public static const TIME:int = 9;
		public static const ICONS:Array = [];
		[Embed(source = "../lib/art/ui/icon_person_2.png")] private static const _crew_icon:Class;
		[Embed(source = "../lib/art/ui/icon_minerals_2.png")] private static const _minerals_icon:Class;
		[Embed(source = "../lib/art/ui/icon_power.png")] private static const _power_icon:Class;
		[Embed(source = "../lib/art/ui/icon_damage.png")] private static const _damage_icon:Class;
		[Embed(source = "../lib/art/ui/icon_person_2.png")] private static const _housing_icon:Class;
		[Embed(source = "../lib/art/ui/icon_water.png")] private static const _water_icon:Class;
		[Embed(source = "../lib/art/ui/icon_goods.png")] private static const _goods_icon:Class;
		[Embed(source = "../lib/art/ui/icon_asteroid2.png")] private static const _meteoroids_icon:Class;
		[Embed(source = "../lib/art/ui/icon_mino.png")] private static const _minos_icon:Class;
		[Embed(source = "../lib/art/ui/icon_hourglass.png")] private static const _time_icon:Class;
	}

}