package MainMenu {
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class StateThing extends MenuThing {
		
		private var associate:Class;
		public function StateThing(desc:String, assocState:Class) {
			super(desc);
			text.size = 20;
			createHighlight();
			
			associate = assocState;
		}
		
		override protected function choose():void {
			FlxG.state = new associate();
		}
		
	}

}