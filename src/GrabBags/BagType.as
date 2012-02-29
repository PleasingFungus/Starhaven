package GrabBags {
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class BagType {
		
		public var name:String;
		public var weight:Number;
		protected var _minos:Array;
		public function BagType(Minos:Array, Weight:Number = 1) {
			_minos = Minos;
			weight = Weight;
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
		
		public function get length():int {
			var len:int = 0;
			for each (var mino:* in _minos)
				if (mino is BagType)
					len += (mino as BagType).length;
				else 
					len++;
			return len;
		}
	}

}