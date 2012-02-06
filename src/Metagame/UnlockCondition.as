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
		public var reqDiff:int;
		public function UnlockCondition(GetAssocList:Function, ListIndex:int, RequiredStat:int, RequiredStatValue:int,
										Name:String, ReqDifficulty:int = -1) {
			getAssocList = GetAssocList;
			listIndex = ListIndex;
			reqStat = RequiredStat;
			reqStatValue = RequiredStatValue;
			name = Name;
			reqDiff = ReqDifficulty > 0 ? ReqDifficulty : C.difficulty.NORMAL;
		}
		
		public function holds():Boolean {
			return C.accomplishments.bestStats.accessByIndex(reqStat) >= reqStatValue && C.difficulty.initialSetting >= reqDiff;
		}
		
	}

}