package Sminos {
	import HUDs.LaunchText;
	import Icons.Icontext;
	import flash.geom.Point;
	import Mining.MetalRocket;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author ...
	 */
	public class Launcher extends Smino {
		
		protected var launchCapacity:int;
		protected var launchRemaining:int;
		protected var capacityText:Icontext;
		public function Launcher(X:int, Y:int, blocks:Array, center:Point,
								 Sprite:Class = null, InopSprite:Class = null) {
			super(X, Y, blocks, center, 0xff1e5a2c, 0xff42a45a, Sprite, InopSprite);
			
			launchRemaining = launchCapacity = blocks.length * LAUNCH_SIZE;
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
		
		protected var rocket:FlxSprite;
		override protected function renderSupply():void {
			if (launchRemaining) {
				if (!rocket)
					rocket = new FlxSprite().loadGraphic(_rocket_sprite);
				var absCenter:Point = absoluteCenter;
				for (var i:int = 0; i < Math.floor(launchRemaining / LAUNCH_SIZE); i++ ) {
					var block:Point = blocks[i].add(absCenter);
					rocket.x = block.x * C.BLOCK_SIZE + C.B.drawShift.x;
					rocket.y = block.y * C.BLOCK_SIZE + C.B.drawShift.y;
					rocket.render();
				}
				//capacityText.text = launchCapacity+"";
				//capacityText.x = x + width/2 - (capacityText.textWidth + 18) / 2 + 18 + C.B.drawShift.x;
				//capacityText.y = y + height / 2 - capacityText.height / 2 + C.B.drawShift.y;
				//
				//capacityText.update();
				//capacityText.render();
			}
			
			super.renderSupply();
		}
		
		protected function get crewedRockets():int {
			return crewEmployed - (launchCapacity - launchRemaining) / LAUNCH_SIZE;
		}
		
		public static const LAUNCH_SIZE:int = 25; //10 for pre-multiminerals
		[Embed(source = "../../lib/art/other/rocket_unlit.png")] private static const _rocket_sprite:Class;
		[Embed(source = "../../lib/sound/vo/launchers.mp3")] public static const _desc:Class;
	}

}