package HUDs {
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class MinedText extends FlashText {
		
		public function MinedText(Amount:int) {
			instanceValue = Amount;
			super("+" + instanceValue + " mined!", 0x6f19e3);
			if (instance)
				instance.exists = false;
			instance = this;
		}
		
		private static var instance:FlashText;
		private static var instanceValue:int;
		public static function mine(minerals:int):void {
			if (instance && instance.exists)
				instanceValue += minerals;
			else
				instanceValue = minerals;
			
			var text:String = "+" + instanceValue + " mined!";
			
			if (instance && instance.exists)
				instance.text = text
			else {
				instance = new FlashText(text, 0x6f19e3);
				C.hudLayer.add(instance);
			}
		}
		
	}

}