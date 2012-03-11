package GameBonuses.Attack {
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class MeteoDisplay extends FlxSprite {
		
		private var amount:int;
		public function MeteoDisplay(X:int, Y:int, initialAmount:int) {
			super(X, Y);
			amount = initialAmount;
			create();
		}
		
		public function updateTo(newAmount:int):void {
			if (amount != newAmount) {
				amount = newAmount;
				create();
			}
		}
		
		protected function create():void {
			var key:String = "MeteoDisplay" + amount;
			var alreadyExists:Boolean = FlxG.checkBitmapCache(key);
			createGraphic(80, 32, 0x0, false, key);
			if (alreadyExists) return;
			
			var meteoStamp:FlxSprite = new FlxSprite().loadGraphic(_sprite);
			if (amount <= 2)
				for (var i:int = 0; i < amount; i++)
					draw(meteoStamp, i * meteoStamp.width * 1.5, 0);
			else {
				draw(meteoStamp);
				var text:FlxText = new FlxText(0, 0, 32, "x" + amount);
				text.setFormat(C.FONT, 16);
				draw(text, 48, height/2 - text.height/2);
			}
		}
		
		[Embed(source = "../../../lib/art/other/asteroid_agon.png")] private const _sprite:Class;
	}

}