package MainMenu {
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class DifficultyThing extends MenuThing {
		
		private var difficulty:int;
		public function DifficultyThing(Desc:String, difficulty:int) {
			super(Desc);
			text.size = 20;
			createHighlight();
			
			this.difficulty = difficulty;
			if (C.difficulty.initialSetting == difficulty)
				C.difficulty.setting = difficulty; // set actual difficulty to displayed
		}
		
		override protected function choose():void {
			C.difficulty.setting = C.difficulty.initialSetting = difficulty;
			C.difficulty.save();
		}
		
		override protected function get isHighlighted():Boolean {
			return C.difficulty.initialSetting == difficulty || super.isHighlighted;
		}
		
	}

}