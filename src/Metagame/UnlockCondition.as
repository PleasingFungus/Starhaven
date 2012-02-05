package Metagame {
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class UnlockCondition {
		
		public var getAssocList:Function;
		public var listIndex:int;
		public var reqStat:int;
		public var reqStatValue:int;
		public var name:String;
		public function UnlockCondition(GetAssocList:Function, ListIndex:int, RequiredStat:int, RequiredStatValue:int, Name:String) {
			getAssocList = GetAssocList;
			listIndex = ListIndex;
			reqStat = RequiredStat;
			reqStatValue = RequiredStatValue;
			name = Name;
		}
		
		public function holds():Boolean {
			return C.accomplishments.bestStats.accessByIndex(reqStat) >= reqStatValue;
		}
		
	}

}