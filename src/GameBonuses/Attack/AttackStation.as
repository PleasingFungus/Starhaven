package GameBonuses.Attack {
	import Sminos.SecondaryReactor;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class AttackStation extends Station {
		
		public function AttackStation(SetRotationState:Function) {
			super(SetRotationState);
		}
		
		override protected function makeCore():Smino {
			return new SecondaryReactor(0, 0);
		}
		
		override public function checkMinerals():void { }
		
		override protected function handleDamage():void {
			resetPower();
			cleanup();
			//no minimap nonsense
		}
	}

}