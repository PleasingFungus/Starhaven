package  {
	import flash.net.*;
	import flash.events.Event;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class NetworkStats {
		
		private var loader:URLLoader;
		public function NetworkStats() {
			loader = new URLLoader(); 
			loader.addEventListener(Event.COMPLETE, on_complete);
		}
		
		public function init():void {
			if (C.DEBUG && C.NO_REPORTING) return;
			
			var variables : URLVariables = new URLVariables();  
			variables.func = "startup";
			variables.version = C.VERSION;
			sendRequest(variables);
		}
		
		public function logException(exception:Error):void {
			if (C.DEBUG && C.NO_REPORTING) return;
			
			var variables : URLVariables = new URLVariables();  
			variables.func = "error";
			variables.stacktrace = exception.getStackTrace();
			variables.version = C.VERSION;
			sendRequest(variables);
		}
		
		private function sendRequest(variables:URLVariables):void {
			var request : URLRequest = new URLRequest("http://pleasingfungus.com/starhaven/stats.php"); 
			request.method = URLRequestMethod.POST;  
			request.data = variables;  
			
			loader.load(request); 
		}
		 
		private function on_complete(e : Event):void{  
			C.log("Loaded from network: "+loader.data);
		}
	}

}