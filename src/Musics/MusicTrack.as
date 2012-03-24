package Musics {
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class MusicTrack {
		
		public var body:String;
		public var intro:Number;
		public var loopTime:Number;
		public function MusicTrack(Body:String, Intro:Number = -1, LoopTime:Number = -1) {
			intro = Intro;
			body = Body;
			loopTime = LoopTime;
		}
		
		public function toString():String {
			var str:String = "[Music: " + body;
			if (intro != -1) str += ", " + intro + ":";
			if (loopTime != -1) str +=  loopTime;
			return str + "]";
		}
	}

}