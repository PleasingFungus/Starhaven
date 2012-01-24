package  {
	import org.flixel.*;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.filters.BlurFilter;
	
	/**
	 * ...
	 * @author azazoth
	 */
	public class FakeSSState extends FlxState{
		
		public function FakeSSState() {
			add(new FlxSprite().loadGraphic(_raw_ss));
		}
		
		override public function render():void {
			super.render();
			drawGlow();
		}

		private var glowBuffer:BitmapData;
		private var glowColorTransform:ColorTransform = new ColorTransform(1, 1, 1, C.GLOW_ALPHA);
		
		private const blurFilter:BlurFilter = new BlurFilter(C.GLOW_SCALE, C.GLOW_SCALE, 1);
		private function drawGlow():void {
			if (!glowBuffer)
				glowBuffer = FlxG.buffer.clone();
			glowBuffer.applyFilter(FlxG.buffer, new Rectangle(0, 0, FlxG.width, FlxG.height), new Point(), blurFilter);
			FlxG.buffer.draw(glowBuffer, null, glowColorTransform, BlendMode.SCREEN);
		}
		
		[Embed(source = "../lib/coolbeans.png")] private static const _raw_ss:Class;
	}

}