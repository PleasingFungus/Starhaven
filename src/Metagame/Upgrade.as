package Metagame {
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class Upgrade {
		
		public var original:Class;
		public var replacement:Class;
		public var used:Boolean;
		public function Upgrade(Original:Class, Replacement:Class, Used:Boolean = false) {
			original = Original;
			replacement = Replacement;
			used = Used;
		}
		
	}

}