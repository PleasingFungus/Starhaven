package Musics {
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class MusicTrack {
		
		public var intro:Number;
		public var body:String;
		public var loops:Boolean;
		public function MusicTrack(Body:String, Intro:Number = -1, Loops:Boolean = true) {
			intro = Intro;
			body = Body;
			loops = Loops;
		}
		
		public function toString():String {
			var str:String = "[Music: " + body;
			if (intro != -1) str += " - " + intro;
			str += " : L=" + loops + "]";
			return str;
		}
	}

}