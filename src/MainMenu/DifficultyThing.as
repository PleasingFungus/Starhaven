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
		}
		
		override protected function choose():void {
			C.difficulty.setting = difficulty;
			C.difficulty.save();
		}
		
		override protected function get isHighlighted():Boolean {
			return C.difficulty.setting == difficulty || super.isHighlighted;
		}
		
	}

}