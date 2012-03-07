package Options {
	import Controls.ControlSet;
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class ResetMenuThing extends MenuThing {
		
		public function ResetMenuThing() {
			super("Reset Controls");
			text.size = 12;
			createHighlight();
		}
		
		
		override protected function choose():void {
			ControlSet.reset();
			ControlSet.save();
		}
	}

}