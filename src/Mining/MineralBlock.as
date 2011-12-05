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
			return colorOf(type);
		}
		
		override public function toString():String {
			return "("+x+","+y+"-"+type+")";
		}
		
		private static const BEDROCK_COLOR:uint = 0xff2d2d30;
		private static const ROCK_COLOR:uint = 0xffe8e8e8;
		private static const WEAK_MINERAL_COLOR:uint = 0xff4c355b;
		private static const MED_MINERAL_COLOR:uint = 0xff402daa;
		private static const STRONG_MINERAL_COLOR:uint = 0xffd800ff;
		private static const COLORS:Array = [BEDROCK_COLOR, ROCK_COLOR,
									  WEAK_MINERAL_COLOR, MED_MINERAL_COLOR,
									  STRONG_MINERAL_COLOR];
		
		public static function colorOf(type:int):uint {
			return COLORS[type-BEDROCK];
		}
		
		public static function typeOfColor(color:uint):int {
			return COLORS.indexOf(color) - 1;
		}
		
		public static const BEDROCK:int = -1;
		public static const ROCK:int = 0;
		public static const WEAK_MINERALS:int = 1;
		public static const MED_MINERALS:int = 2;
		public static const STRONG_MINERALS:int = 3;
		
		private const VALUES:Array = [0, 1, 2, 4];
	}

}

