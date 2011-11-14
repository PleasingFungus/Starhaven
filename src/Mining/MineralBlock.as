package Mining {
	/**
	 * ...
	 * @author ...
	 */
	public class MineralBlock extends Block {
		
		public var type:int;
		public var valueFactor:int;
		public function MineralBlock(X:int=0, Y:int=0, ValueFactor:int = 5, Type:int=0) {
			super(X, Y);
			type = Type;
			valueFactor = ValueFactor;
		}
		
		public function get value():int {
			return VALUES[type] * valueFactor;
		}
		
		public function get color():uint {
			return COLORS[type-BEDROCK];
		}
		
		private const BEDROCK_COLOR:uint = 0xff2d2d30;
		private const ROCK_COLOR:uint = 0xffe8e8e8;
		private const WEAK_MINERAL_COLOR:uint = 0xff4c355b;
		private const MED_MINERAL_COLOR:uint = 0xff552daa;
		private const STRONG_MINERAL_COLOR:uint = 0xffd800ff;
		private const VSTRONG_MINERAL_COLOR:uint = 0xffff2b6a;
		private const COLORS:Array = [BEDROCK_COLOR, ROCK_COLOR,
									  WEAK_MINERAL_COLOR, MED_MINERAL_COLOR,
									  STRONG_MINERAL_COLOR, VSTRONG_MINERAL_COLOR];
		
		public static const BEDROCK:int = -1;
		public static const ROCK:int = 0;
		public static const PURPLE_MINERALS:int = 1;
		public static const ORANGE_MINERALS:int = 2;
		public static const TEAL_MINERALS:int = 3;
		
		private const VALUES:Array = [0, 1, 2, 4];
	}

}

