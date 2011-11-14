package GrabBags {
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class BagType {
		
		public var name:String;
		public var weight:Number;
		public var minStage:int;
		public var maxStage:int;
		protected var _minos:Array;
		public function BagType(Name:String, Weight:Number, Minos:Array,
								MinStage:int = 0, MaxStage:int = int.MAX_VALUE) {
			name = Name;
			weight = Weight;
			_minos = Minos;
			
			minStage = MinStage;
			maxStage = MaxStage;
		}
		
		public function get minos():Array {
			var m:Array = new Array(_minos.length)
			for (var i:int = 0; i < _minos.length; i++)
				m[i] = _minos[i];
			return m;
		}
		
		public function toString():String {
			if (name)
				return name;
			return "[" + minos + "]";
		}
		
		public static var all:Array;
	}

}