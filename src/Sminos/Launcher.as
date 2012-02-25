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
	
	public class Launcher extends Smino {
		
		protected var launchCapacity:int;
		protected var launchRemaining:int;
		//protected var launchesQueued:int;
		//protected var launchTime:Number;
		protected var capacityText:Icontext;
		
		public function Launcher(X:int, Y:int, blocks:Array, center:Point,
								 Sprite:Class = null, InopSprite:Class = null) {
			super(X, Y, blocks, center, 0xff1e5a2c, 0xff42a45a, Sprite, InopSprite);
			
			launchRemaining = launchCapacity = blocks.length * LAUNCH_SIZE;
			capacityText = new Icontext(0, 0, 100, launchCapacity + "", C.ICONS[C.GOODS]);
			
			cladeName = "Launcher";
			description = "Power and fully crew Launchers to send minerals you've gathered back to your home base!";
			audioDescription = _desc;
		}
		
		override protected function executeCycle():void {
			super.executeCycle();
			
			if (operational && launchRemaining && station.mineralsMined >= LAUNCH_SIZE) {
				launchRemaining -= LAUNCH_SIZE;
				station.mineralsMined -= LAUNCH_SIZE;
				station.mineralsLaunched += LAUNCH_SIZE;
				LaunchText.launch(LAUNCH_SIZE);
				
				var i:int = launchRemaining / LAUNCH_SIZE;
				Mino.layer.add(new MetalRocket(absoluteCenter.x + blocks[i].x, absoluteCenter.y + blocks[i].y));
				
				C.sound.play(LAUNCH_NOISES[int(FlxU.random() * LAUNCH_NOISES.length)], 0.5);
			}
		}
		
		protected var rocket:FlxSprite;
		protected var combatRocket:FlxSprite;
		override public function renderTop(force:Boolean = false):void {
			if (exists && (Scenario.substate == Scenario.SUBSTATE_NORMAL || force) && !damaged && launchRemaining) {
				if (!rocket)
					rocket = new FlxSprite().loadGraphic(_rocket_sprite);
				renderOnBlocks(rocket, Math.floor(launchRemaining / LAUNCH_SIZE));
			}
			
			
			super.renderTop(force);
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
		[Embed(source = "../../lib/sound/vo/launchers.mp3")] public static const _desc:Class;
		[Embed(source = "../../lib/sound/game/launch_mineral_1.mp3")] protected const _LAUNCH_NOISE_1:Class;
		[Embed(source = "../../lib/sound/game/launch_mineral_2.mp3")] protected const _LAUNCH_NOISE_2:Class;
		protected const LAUNCH_NOISES:Array = [_LAUNCH_NOISE_1, _LAUNCH_NOISE_2];
		
		//protected const LAUNCH_TIMER:int = 0.2;
	}

}