package Globals {
	import flash.net.*;
	import flash.events.Event;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class Timelock {
		
		public var loaded:Boolean;
		public var locked:Boolean;
		public var lockMessage:String;
		private var loader:URLLoader;
		public function Timelock() {
			loader = new URLLoader(); 
			loader.addEventListener(Event.COMPLETE, on_complete);
			
			var request : URLRequest = new URLRequest("http://pleasingfungus.com/starhaven/beta.txt"); 
			request.method = URLRequestMethod.GET;
			request.data = new URLVariables;
			
			loader.load(request); 
		}
		
		 
		private function on_complete(e : Event):void{  
			var out:String = loader.data as String;
			var nlIndex:int = out.indexOf('\n');
			var okay:String = out.substr(0, nlIndex-1);
			locked = okay != "OK";
			lockMessage = out.substr(nlIndex + 1);
			loaded = true;
		}
	}

}