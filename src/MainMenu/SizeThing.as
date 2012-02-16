package MainMenu {
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class SizeThing extends MenuThing {
		
		private var size:int;
		public function SizeThing(Desc:String, Size:int) {
			super(Desc);
			text.size = 20;
			createHighlight();
			
			size = Size;
			if (C.difficulty.scaleSetting == size)
				C.difficulty.scaleSetting = size; // set actual difficulty to displayed
		}
		
		override protected function choose():void {
			C.difficulty.scaleSetting = size;
			C.difficulty.save();
		}
		
		override protected function get isHighlighted():Boolean {
			return C.difficulty.scaleSetting == size || super.isHighlighted;
		}
	}

}