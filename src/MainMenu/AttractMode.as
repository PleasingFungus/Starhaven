package MainMenu {
	import org.flixel.*;
	import Sminos.*;
	import flash.filters.BlurFilter;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import Globals.Bounds;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class AttractMode extends FlxGroup {
		
		protected var iconLayer:FlxGroup;
		protected var shroud:FlxSprite;
		protected var spawnTimer:Number;
		protected var fastfallers:Vector.<Smino>
		public function AttractMode() {
			super();
			
			C.makeScenarioReady(this);
			C.B.maxDim = new Point(B.BASE_AREA.width, B.BASE_AREA.height);
			iconLayer = C.iconLayer;
			
			shroud = new FlxSprite().createGraphic(FlxG.width, FlxG.height, 0xff000000);
			shroud.alpha = 0.25;
			
			spawnTimer = C.CYCLE_TIME * 10;
			fastfallers = new Vector.<Smino>;
			
			instantiated++;
		}
		
		override public function update():void {
			super.update();
			checkSpawnTimer();
			checkFastfallers();
			iconLayer.update();
		}
		
		protected function checkSpawnTimer():void {
			spawnTimer -= FlxG.elapsed;
			if (spawnTimer <= 0)// && instantiated <= 1)
				spawn();
		}
		
		protected function spawn():void {
			var X:int = FlxU.random() * C.B.BASE_AREA.width;
			
			var sminoType:Class = C.randomChoice(ALL_SMINOS);
			var newSmino:Smino = new sminoType(X, 0);
			
			newSmino.gridLoc.y -= newSmino.blockDim.y + 1;
			if (newSmino.bounds.left <= 0)
				newSmino.gridLoc.x = -newSmino.bounds.left + 1;
			else if (newSmino.bounds.right >= C.B.BASE_AREA.width)
				newSmino.gridLoc.x -= newSmino.bounds.right - C.B.BASE_AREA.width + 1;
			
			var fastfalling:Boolean = FlxU.random() > 0.75;
			if (fastfalling)
				fastfallers.push(newSmino);
			
			add(newSmino);
			
			var passageTime:Number = C.CYCLE_TIME * newSmino.blockDim.y + 2;
			if (fastfalling) passageTime /= 2;
			spawnTimer += passageTime;
		}
		
		protected function checkFastfallers():void {
			for each (var smino:Smino in Mino.all_minos) {
				if (!smino.exists) continue;
				
				var fastfalling:Boolean = fastfallers.indexOf(smino) != -1;
				if (fastfalling) smino.update(); //simulating fastfall by double-updating
				
				smino.pressedDirs[FlxSprite.LEFT] = false;
				smino.pressedDirs[FlxSprite.UP] = !fastfalling;
				smino.pressedDirs[FlxSprite.RIGHT] = false;
				smino.pressedDirs[FlxSprite.DOWN] = fastfalling;
			}
		}
		
		override public function render():void {
			super.render();
			iconLayer.render();
			for each (var leech:Mino in C.iconLeeches)
				leech.renderTop(true, true);
			drawGlow();
			shroud.render();
		}
		
		
		private var glowBuffer:BitmapData;
		private var glowColorTransform:ColorTransform = new ColorTransform(1, 1, 1, C.GLOW_ALPHA);
		private const blurFilter:BlurFilter = new BlurFilter(C.GLOW_SCALE, C.GLOW_SCALE, 1);
		private function drawGlow():void {
			if (!C.DRAW_GLOW)
				return;
			if (!glowBuffer)
				glowBuffer = FlxG.buffer.clone();
			glowBuffer.applyFilter(FlxG.buffer, new Rectangle(0, 0, FlxG.width, FlxG.height), new Point(), blurFilter);
			FlxG.buffer.draw(glowBuffer, null, glowColorTransform, BlendMode.SCREEN);
		}
		
		public static var instantiated:int;
		
		protected const ALL_SMINOS:Array = [HookConduit, LeftHookConduit, LongConduit, LongDrill,
											MediumBarracks, MediumLauncher, NebularAccumulator, RocketGun,
											Scoop, SmallBarracks, SmallLauncher];
	}

}