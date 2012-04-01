package Musics {
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class MusicTrack {
		
		public var body:String;
		public var intro:Number;
		public var loopTime:Number;
		public var name:String;
		public function MusicTrack(Name:String, Body:String, Intro:Number = -1, LoopTime:Number = -1) {
			name = Name;
			intro = Intro;
			body = Body;
			loopTime = LoopTime;
		}
		
		public function toString():String {
			if (name)
				return name;
			
			var str:String = "[Music: " + body;
			if (intro != -1) str += ", " + intro + ":";
			if (loopTime != -1) str +=  loopTime;
			return str + "]";
		}
		
		public function clone():MusicTrack {
			return new MusicTrack(name, body, intro, loopTime);
		}
	}

}