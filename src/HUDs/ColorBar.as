package HUDs {
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class ColorBar extends FlxSprite {
		
		public var quant:Number;
		public var maxQuant:Number;
		public function ColorBar(X:int, Y:int, MaxQuant:Number, Quant:Number, Width:int = 60, Height:int = 8) {
			super(X, Y);
			createGraphic(Width, Height);
			
			quant = Quant;
			maxQuant = MaxQuant;
		}
		
		override public function render():void {
			var qFraction:Number = quant / maxQuant;
			scale.x = Math.min(1, Math.max(0, qFraction));
			color = getColorFor(qFraction);
			super.render();
		}
		
		protected function getColorFor(fraction:Number):uint {
			var red:Number = 1;
			var green:Number = 1
			if (fraction > 0.5)
				red = (1 - fraction) / 0.5;
			else
				green = fraction / 0.5;
			return 0xff000000 | (int(red * 255) << 16) | (int(green * 255) << 8);
		}
	}

}