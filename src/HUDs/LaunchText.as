package HUDs {
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class LaunchText extends FlashText {
		
		public function LaunchText(Amount:int) {
			instanceValue = Amount;
			super("+" + instanceValue + " launched!", 0x44c641);
			if (instance)
				instance.exists = false;
			instance = this;
		}
		
		private static var instance:FlashText;
		private static var instanceValue:int;
		public static function launch(minerals:int):void {
			if (instance && instance.exists)
				instanceValue += minerals;
			else
				instanceValue = minerals;
			
			var text:String = "+" + instanceValue + " launched!";
			
			if (instance && instance.exists) {
				instance.text = text
			} else {
				instance = new FlashText(text, 0x44c641);
				FlashText.layer.add(instance);
			}
		}
		
	}

}