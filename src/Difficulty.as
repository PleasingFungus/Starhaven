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
		
		
		
		public function get meteoroidMultiplier():Number {
			if (hard)
				return 1.5;
			return 1;
		}
		
		public function get blockSlack():Number {
			if (hard)
				return 1.1;
			return 1.5;
		}
		
		
		
		public function name(forSetting:int = -1):String {
			if (forSetting == -1)
				forSetting = setting;
			return ["Normal", "Hard"][forSetting];
		}
		
		public static const NORMAL:int = 0;
		public static const HARD:int = 1;
	}

}