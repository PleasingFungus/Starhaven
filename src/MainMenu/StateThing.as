package MainMenu {
	import org.flixel.FlxG;
	import org.flixel.FlxText;
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
			onSelect = changeStates;
		}
		
		protected function changeStates(_:String):void {
			//var loadingText:FlxText = new FlxText(0, FlxG.height / 2 - 10, FlxG.width, "Loading...");
			//loadingText.setFormat(C.FONT, 48, 0xff8fff, 'center');
			//FlxG.state.add(loadingText);
			//FlxG.state.render();
			
			FlxG.state = new associate();
		}
		
	}

}