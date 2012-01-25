package Sminos {
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import HUDs.LaunchText;
	import Icons.Icontext;
	import flash.geom.Point;
	import Meteoroids.CombatRocket;
	import Meteoroids.SlowRocket;
	import Mining.MetalRocket;
	import org.flixel.*;
	/**
	 * ...
	 * @author ...
	 */
	public class Launcher extends Smino {
		
		protected var launchCapacity:int;
		protected var launchRemaining:int;
		protected var capacityText:Icontext;
		public var rocketsLoaded:int;
		protected var rocketCapacity:int;
		private var dangerSprite:Class;
		public function Launcher(X:int, Y:int, blocks:Array, center:Point,
								 Sprite:Class = null, InopSprite:Class = null, DangerSprite:Class = null) {
			super(X, Y, blocks, center, 0xff1e5a2c, 0xff42a45a, Sprite, InopSprite);
			dangerSprite = DangerSprite;
			
			launchRemaining = launchCapacity = blocks.length * LAUNCH_SIZE;
			rocketCapacity = blocks.length;
			capacityText = new Icontext(0, 0, 100, launchCapacity + "", C.ICONS[C.GOODS]);
			
			cladeName = "Launcher";
			description = "When fully crewed and powered, Launchers send minerals you've gathered back to your home base (score!)!";
			audioDescription = _desc;
		}
		
		override protected function executeCycle():void {
			super.executeCycle();
			
			if (operational && launchRemaining && station.mineralsMined >= LAUNCH_SIZE) {
				var launch:int = Math.min(launchRemaining, Math.floor(station.mineralsMined/LAUNCH_SIZE) * LAUNCH_SIZE);
				launchRemaining -= launch;
				station.mineralsMined -= launch;
				station.mineralsLaunched += launch;
				LaunchText.launch(launch);
				
				for (var i:int = launchRemaining / LAUNCH_SIZE; i < (launchRemaining + launch) / LAUNCH_SIZE; i++)
					Mino.layer.add(new MetalRocket(absoluteCenter.x + blocks[i].x, absoluteCenter.y + blocks[i].y));
			}
		}
		
		public function loadRockets():void {
			rocketsLoaded = rocketCapacity;
		}
		
		public function fireOn(target:Point):void {
			rocketsLoaded--;
			Mino.layer.add(new SlowRocket(absoluteCenter.add(blocks[rocketsLoaded]), target));
		}
		
		protected var rocket:FlxSprite;
		protected var combatRocket:FlxSprite;
		override protected function renderSupply():void {
			if (Scenario.dangeresque) {
				if (!combatRocket)
					combatRocket = new FlxSprite().loadGraphic(_combat_rocket_sprite);
				renderOnBlocks(combatRocket, rocketsLoaded);
			} else if (launchRemaining) {
				if (!rocket)
					rocket = new FlxSprite().loadGraphic(_rocket_sprite);
				renderOnBlocks(rocket, Math.floor(launchRemaining / LAUNCH_SIZE));
			}
			
			
			super.renderSupply();
		}
		
		override protected function getCurSprite():Class {
			return dangerSprite && Scenario.dangeresque && operational ? dangerSprite : super.getCurSprite(); 
		}
		
		protected function renderOnBlocks(sprite:FlxSprite, number:int):void {
			var absCenter:Point = absoluteCenter;
			for (var i:int = 0; i < number; i++ ) {
				var block:Point = absCenter.add(blocks[i]);
				sprite.x = block.x * C.BLOCK_SIZE + C.B.drawShift.x;
				sprite.y = block.y * C.BLOCK_SIZE + C.B.drawShift.y;
				sprite.render();
			}
		}
		
		protected function get crewedRockets():int {
			return crewEmployed - (launchCapacity - launchRemaining) / LAUNCH_SIZE;
		}
		
		protected var border:FlxSprite;
		protected const BORDER_WIDTH:int = 2;
		public function renderBorder():void {
			var db:Rectangle = getDrawBounds();
			if (!border || border.width != db.width + BORDER_WIDTH * 2) {
				var key:String = "border" + db.width + "x" + db.height;
				var alreadyMade:Boolean = FlxG.checkBitmapCache(key);
				border = new FlxSprite().createGraphic(db.width + BORDER_WIDTH * 2,
													   db.height + BORDER_WIDTH * 2, 0xffffffff, true, key);
				
				if (!alreadyMade) {
					border.pixels.fillRect(new Rectangle(BORDER_WIDTH, BORDER_WIDTH, db.width, db.height), 0x0);
					border.frame = 0;
				}
			}
			border.x = db.x - BORDER_WIDTH;
			border.y = db.y - BORDER_WIDTH;
			border.alpha = 0.8;
			border.render();
		}
		
		public static const LAUNCH_SIZE:int = 25; //10 for pre-multiminerals
		[Embed(source = "../../lib/art/other/rocket_unlit.png")] private static const _rocket_sprite:Class;
		[Embed(source = "../../lib/art/other/rocket_combat_unlit.png")] private static const _combat_rocket_sprite:Class;
		[Embed(source = "../../lib/sound/vo/launchers.mp3")] public static const _desc:Class;
	}

}