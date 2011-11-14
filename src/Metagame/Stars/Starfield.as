package Metagame.Stars {
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class Starfield {
		
		public var stars:Array;
		private var dim:int;
		private var population:int;
		private var arms:int;
		public function Starfield(Dim:int = 250, Population:int = 20000, Arms:int = 5 ) {
			dim = Dim;
			population = Population;
			arms = Arms;
			genStars();
		}
		
		protected function genStars():void {
			stars = new Array(dim*dim);
			for (var x:int = 0; x < dim; x++)
				for (var y:int = 0; y < dim; y++) {
					var closeness:Number = getCloseness(x, y);
					var starChance:Number = getStarChance(x, y, closeness);
					if (FlxU.random() < starChance)
						genStar(x, y, closeness);
				}
		}
		
		protected function getStarChance(x:int, y:int, closeness:Number = -1):Number {
			x = x - dim / 2;
			y = y - dim / 2;
			if (closeness < 0)
				closeness = getCloseness(x, y);
				
			var probFactor:Number = 3 * population / (dim * dim);
			
			var theta:Number = Math.atan2(y, x);
			var phi:Number = 2 * Math.PI / ((1 - closeness) * arms * arms);
			var radialFactor:Number = (1 + Math.sin((theta + phi) * arms)) * .5;
			var radialScalingFraction:Number = (1 - closeness);
			var scaledRadial:Number = radialFactor * radialScalingFraction + 1 - radialScalingFraction;
			
			return probFactor * closeness/* * scaledRadial*/;
		}
		
		protected function getCloseness(x:int, y:int):Number {
			var closeness:Number = 1 - Math.sqrt(x * x + y * y) / dim;
			return closeness * closeness * closeness;
		}
		
		protected function genStar(x:int, y:int, closeness:Number):void {
			stars[x + y * dim] = new Star(closeness, FlxU.random());
		}
		
		public function render(X:int, Y:int):FlxSprite {
			var scale:int = 2;
			var spr:FlxSprite = new FlxSprite(X - dim * scale /2, Y - dim * scale /2).createGraphic(dim * scale, dim * scale, 0xff000000, true);
			var stamp:FlxSprite = new FlxSprite().createGraphic(scale - 1, scale - 1);
			for (var x:int = 0; x < dim; x++)
				for (var y:int = 0; y < dim; y++) {
					//if (stars[x + y * dim])
						//spr.draw(stamp, x * scale, y * scale);
					var scaledChance:int = getStarChance(x, y) * 255;
					var color:uint = (scaledChance << 16) | (scaledChance << 8) | scaledChance;
					spr.pixels.setPixel(x * scale, y * scale, color);
				}
			spr.frame = 0;
			return spr;
		}
	}

}