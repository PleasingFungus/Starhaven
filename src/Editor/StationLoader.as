package Editor {
	import Sminos.*;
	import Missions.LoadedMission;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class StationLoader {
		
		public var station:Station;
		public function StationLoader(station:Station, initialConfig:Array = null) {
			this.station = station;
			if (initialConfig)
				load(initialConfig);
		}
		
		public function load(config:Array):void {
			for each (var sminoConfig:String in config) {
				var details:Array = sminoConfig.split(Mino.DELIMITER);
				var name:String = details[0];
				var x:int = details[1];
				var y:int = details[2];
				var facing:int = details[3];
				
				var sminoIndex:int = LoadedMission.SMINO_NAMES.indexOf(name);
				if (sminoIndex == -1) {
					C.log("Couldn't spawn smino " + name);
					continue;
				}
				var sminoType:Class = LoadedMission.ALL_SMINOS[sminoIndex];
				
				var smino:Smino = new sminoType(x, y);
				while (smino.facing != facing)
					smino.rotateClockwise(true);
				smino.stealthAnchor(station);
				Mino.layer.add(smino);
			}
		}
		
		/*public const ALL_SMINOS:Array = [HookConduit, LeftHookConduit, LongConduit,
										 MediumBarracks, SmallBarracks, MediumLauncher, SmallLauncher,
										 NebularAccumulator, Scoop, LongDrill,
										 RocketGun];
		
		public const SMINO_NAMES:Array = ["Hook-Conduit", "LeftHook-Conduit", "Long-Conduit",
										  "Barracks", "Small Barracks", "Launcher", "Small Launcher",
										  "Nebular Accumulator", "Scoop", "Long Drill",
										  "Rocket Gun"]; */
	}

}