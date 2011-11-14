package Controls {
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class ResetMenuThing extends MenuThing {
		
		public function ResetMenuThing() {
			super("Reset Controls");
		}
		
		
		override protected function choose():void {
			ControlSet.reset();
			ControlSet.save();
		}
	}

}