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
		public var allowed:int;
		public function NetworkStats() {
			loader = new URLLoader(); 
			loader.addEventListener(Event.COMPLETE, on_complete);
			allowed = C.BETA ? -1 : 0;
		}
		
		public function init():void {
			var variables : URLVariables = new URLVariables();  
			variables.func = "startup";
			variables.version = C.VERSION;
			sendRequest(variables);
		}
		
		public function load():void {
			allowed = (C.save.read("netAllowed") as int) - 1; //defaults to -1
		}
		
		public function setAllowed(newSetting:int):void {
			var variables : URLVariables = new URLVariables();  
			variables.func = "setAllowed";
			variables.permission = newSetting;
			sendRequest(variables);
			
			allowed = newSetting;
			C.save.write("netAllowed", allowed + 1);
		}
		
		public function logException(exception:Error):void {
			var variables : URLVariables = new URLVariables();  
			variables.func = "error";
			variables.stacktrace = exception.getStackTrace();
			if (!variables.stacktrace)
				variables.stacktrace = exception.message;
			if (!variables.stacktrace)
				return;
			variables.version = C.VERSION;
			sendRequest(variables);
		}
		
		public function startLevel(level:Scenario):void {
			var variables : URLVariables = new URLVariables();  
			variables.func = "startLevel";
			
			addLevelEventInfo(level, variables);
			variables.version = C.VERSION;
			
			sendRequest(variables);
		}
		
		public function endLevel(level:Scenario, stats:Statblock, won:Boolean, quit:Boolean):void {
			var variables : URLVariables = new URLVariables();  
			variables.func = "endLevel";
			
			addLevelEventInfo(level, variables);
			stats.networkSend(variables);
			C.timer.networkSend(variables);
			variables.won = won;
			variables.quit = quit;
			
			sendRequest(variables);
		}
		
		public function finishTutorial(tutorialsBeaten:int):void {
			var variables : URLVariables = new URLVariables();  
			variables.func = "finishTutorial";
			
			variables.tutorialsBeaten = tutorialsBeaten;
			variables.skipped = tutorialsBeaten < C.scenarioList.LAST_TUTORIAL_INDEX;
			variables.fromMenu = !C.IN_TUTORIAL ? 1 : 0; //shenanagains
			
			sendRequest(variables);
		}
		
		public function newUnlock(unlock:String):void {
			var variables : URLVariables = new URLVariables();  
			variables.func = "newUnlock";
			
			variables.unlock = unlock;
			
			sendRequest(variables);
		}
		
		public function toggleUnlocks():void {
			var variables : URLVariables = new URLVariables();  
			variables.func = "toggleUnlocks";
			
			variables.unlocked = C.ALL_UNLOCKED ? 1 : 0;
			
			sendRequest(variables);
		}
		
		public function changeKey(key:Key, from:String, to:String):void {
			var variables : URLVariables = new URLVariables();  
			variables.func = "changeKey";
			
			variables.key = ControlSet.CONFIGURABLE_CONTROLS.indexOf(key);
			variables.old = from;
			variables.new_ = to;
			
			sendRequest(variables);
		}
		
		private function sendRequest(variables:URLVariables):void {
			if (!canSend())
				return;
			
			var request : URLRequest = new URLRequest("http://pleasingfungus.com/starhaven/stats.php"); 
			request.method = URLRequestMethod.POST;  
			request.data = variables;  
			
			loader.load(request); 
		}
		
		private function canSend():Boolean {
			return allowed != 0 && !(C.DEBUG && C.NO_REPORTING);
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