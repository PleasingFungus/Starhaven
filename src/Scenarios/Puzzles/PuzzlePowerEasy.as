package Scenarios.Puzzles {
	import Sminos.*;
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class PuzzlePowerEasy extends Scenario {
		
		override public function create():void {
			super.create();
			
			loadStation();
			
			hud.disablePriorities();
			hud.disableTech();
			hud.disableShip();
			hud.disableThreats(); //hud.disableAll();
			//todo: new station that actually has enough barracks!
			//todo: track win condition (all minos powered)
			//todo: set up mino queue
			//todo: track lose condition (out of minos!)
			//todo: description
		}
		
		protected function loadStation():void {
			var stationParts:Array = ["Station Core,20,15,0", "Small Barracks,16,17,0", "Small Lab,16,13,0", "Small Barracks,14,17,0", "Small Lab,20,11,3", "Small Barracks,16,19,1", "Small Lab,20,19,1", "Small Barracks,23,19,1", "Small Barracks,23,21,1", "Small Lab,24,12,2", "Small Barracks,24,14,2", "Factory,26,14,3", "Small Lab,25,19,2", "Small Barracks,25,21,2", "Small Barracks,27,12,2", "Small Lab,20,8,3", "Small Lab,25,9,3", "Small Barracks,15,10,3"];
			for each (var rawPart:String in stationParts) {
				var part:Smino = Smino.restoreFromString(rawPart);
				if (part)
					minoLayer.add(station.add(part));
			}
		}
		
		override public function update():void {
			super.update();
			station.addCrew(station.crewReq());
		}
		
		override protected function popNextMino():Smino {
			var X:int = C.HALFWIDTH;
			var Y:int = C.HALFHEIGHT - C.getFurthest() + 1;
			return new LongConduit(X, Y);
		}
		
		public static const name:String = "Power - Easy";
	}

}