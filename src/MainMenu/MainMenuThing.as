package MainMenu {
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class MainMenuThing extends StateThing {
		
		private var associate:Class;
		public function MainMenuThing(desc:String, assocState:Class) {
			super(desc, assocState);
			
			if (i == lastChosen)
				select();
		}
		
		override protected function choose():void {
			super.choose();
			lastChosen = i;
			C.save.write("Last Chosen Menu Option", lastChosen);
		}
		
		public static var lastChosen:int;
		public static function init():void {
			lastChosen = C.save.read("Last Chosen Menu Option") as int; //will default to 0
		}
	}

}