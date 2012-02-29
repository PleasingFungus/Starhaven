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
		
		public function startLevel(level:Scenario):void {
			if (C.DEBUG && C.NO_REPORTING) return;
			
			var variables : URLVariables = new URLVariables();  
			variables.func = "startLevel";
			addLevelEventInfo(level, variables);
			variables.version = C.VERSION;
			sendRequest(variables);
		}
		
		private function sendRequest(variables:URLVariables):void {
			var request : URLRequest = new URLRequest("http://pleasingfungus.com/starhaven/stats.php"); 
			request.method = URLRequestMethod.POST;  
			request.data = variables;  
			
			loader.load(request); 
		}
		
		private function addLevelEventInfo(level:Scenario, variables:URLVariables):void {
			variables.difficulty = C.difficulty.setting;
			variables.level = C.scenarioList.index(level);
			variables.size = C.difficulty.scaleSetting;
			variables.inCampaign = C.campaign != null ? 1 : 0;
		}
		 
		private function on_complete(e : Event):void{  
			C.log("Loaded from network: "+loader.data);
		}
	}

}