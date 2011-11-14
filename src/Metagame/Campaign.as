package Metagame {
	import Sminos.*;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class Campaign {
		
		public var missions:int;
		public var minerals:int;
		public var goal:int;
		public var upgrades:Array;
		public function Campaign() {
			goal = TOTAL_MISSIONS * EXPECTED_YIELD_PER_MISSION;
			upgrades = [new Upgrade(SmallBarracks, LargeBarracks),
						new Upgrade(SmallFab, LargeFactory),
						new Upgrade(Conduit, SecondaryReactor)];
		}
		
		public function refresh():void {
			for each (var upgrade:Upgrade in upgrades)
				upgrade.used = false;
		}
		
		public function upgradeFor(original:Class):Upgrade {
			for each (var upgrade:Upgrade in upgrades)
				if (!upgrade.used && upgrade.original == original)
					return upgrade;
			return null;
		}
		
		public const TOTAL_MISSIONS:int = 3;
		private const EXPECTED_YIELD_PER_MISSION:int = 300;
	}

}