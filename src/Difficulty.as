package  {
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class Difficulty {
		
		public var setting:int = NORMAL;
		public function Difficulty() {
			
		}
		
		public function load():void {
			setting = C.save.read("difficulty") as int;
		}
		
		public function save():void {
			C.save.write("difficulty", setting);
		}
		
		public function get normal():Boolean {
			return setting == NORMAL;
		}
		
		public function get hard():Boolean {
			return setting == HARD;
		}
		
		public static const NORMAL:int = 0;
		public static const HARD:int = 1;
	}

}