package HUDs {
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class CollectText extends FlashText {
		
		public function CollectText(Amount:int) {
			instanceValue = Amount;
			super("+" + instanceValue + " collected!", 0x8c00ff);
			if (instance)
				instance.exists = false;
			instance = this;
		}
		
		private static var instance:FlashText;
		private static var instanceValue:int;
		public static function collect(minerals:int):void {
			if (instance && instance.exists)
				instanceValue += minerals;
			else
				instanceValue = minerals;
			
			var text:String = "+" + instanceValue + " collected!";
			
			if (instance && instance.exists)
				instance.text = text
			else {
				instance = new FlashText(text, 0x8c00ff);
				C.hudLayer.add(instance);
			}
		}
		
	}

}