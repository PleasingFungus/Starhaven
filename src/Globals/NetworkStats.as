package Globals {
	import Controls.ControlSet;
	import Controls.Key;
	import flash.net.*;
	import flash.events.Event;
	import Metagame.Statblock;
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
		
		public function endLevel(level:Scenario, stats:Statblock, won:Boolean):void {
			if (C.DEBUG && C.NO_REPORTING) return;
			
			var variables : URLVariables = new URLVariables();  
			variables.func = "endLevel";
			
			addLevelEventInfo(level, variables);
			stats.networkSend(variables);
			C.timer.networkSend(variables);
			variables.won = won;
			
			sendRequest(variables);
		}
		
		public function finishTutorial(tutorialsBeaten:int):void {
			if (C.DEBUG && C.NO_REPORTING) return;
			
			var variables : URLVariables = new URLVariables();  
			variables.func = "finishTutorial";
			
			variables.tutorialsBeaten = tutorialsBeaten;
			variables.skipped = tutorialsBeaten < C.scenarioList.LAST_TUTORIAL_INDEX;
			if (variables.skipped)
				variables.fromMenu = !C.IN_TUTORIAL; //shenanagains
			
			sendRequest(variables);
		}
		
		public function newUnlock(unlock:String):void {
			if (C.DEBUG && C.NO_REPORTING) return;
			
			var variables : URLVariables = new URLVariables();  
			variables.func = "newUnlock";
			
			variables.unlock = unlock;
			
			sendRequest(variables);
		}
		
		public function toggleUnlocks():void {
			if (C.DEBUG && C.NO_REPORTING) return;
			
			var variables : URLVariables = new URLVariables();  
			variables.func = "toggleUnlocks";
			
			variables.unlocked = C.ALL_UNLOCKED ? 1 : 0;
			
			sendRequest(variables);
		}
		
		public function changeKey(key:Key, from:String, to:String):void {
			if (C.DEBUG && C.NO_REPORTING) return;
			
			var variables : URLVariables = new URLVariables();  
			variables.func = "changeKey";
			
			variables.key = ControlSet.CONFIGURABLE_CONTROLS.indexOf(key);
			variables.old = from;
			variables.new_ = to;
			
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