package Globals {
	import flash.net.URLVariables;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class PlayTimer {
		
		public var session:Number;
		public var total:Number;
		public function PlayTimer() {
			session = total = 0;
		}
		
		public function load():void {
			total = C.save.read("totalPlaytime") as Number;
			if (isNaN(total))
				total = 0;
		}
		
		public function save():void {
			C.save.write("totalPlaytime", total);
		}
		
		public function update():void {
			session += FlxG.elapsed;
			total += FlxG.elapsed;
		}
		
		public function networkSend(variables:URLVariables):void {
			variables.sessionTime = session;
			variables.totalTime = total;
		}
		
	}

}