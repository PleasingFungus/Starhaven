package GrabBags {
	import Sminos.*;
	import org.flixel.FlxU;
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class GrabBag {
		
		private var last:Class;
		private var minos:Array;
		public function GrabBag(sminos:Array) {
			for (var i:int = 0; i < sminos.length; i++)
				if (sminos[i] is BagType)
					sminos[i] = new GrabBag((sminos[i] as BagType).minos);
			
			minos = shuffle(sminos);
		}
		
		protected function shuffle(toShuffle:Array = null):Array {
			if (toShuffle == null)
				toShuffle = minos;
			
			for each (var item:Object in toShuffle)
				if (item is GrabBag) {
					var bag:GrabBag = item as GrabBag;
					bag.shuffle();
				}
			
			var shuffled:Array = new Array(toShuffle.length);
			
			for (var i:int = 0; i < shuffled.length; i++) {
				var randIndex:int = FlxU.random() * toShuffle.length;
				shuffled[i] = toShuffle[randIndex];
				toShuffle.splice(randIndex, 1);
			}
			
			if (toShuffle == minos)
				minos = shuffled;
			return shuffled;
		}
		
		public function empty():Boolean {
			for each (var choice:Object in minos)
				if (choice is Class || !(choice as GrabBag).empty())
					return false;
			return true;
		}
		
		public function grabMino():Class {
			if (empty())
				return null;
			
			
			var choice:Object = minos.pop();
			while (choice is GrabBag) {
				var bag:GrabBag = choice as GrabBag;
				choice = bag.grabMino();
				if (choice)
					minos.push(bag);
				else
					choice = minos.pop();
			}
			if (choice == Conduit)
				choice = randomConduit();
			if (choice == null)
				C.log("Bad choice!");
			last = choice as Class;
			return last;
		}
		
		public function repush():void {
			minos.push(last);
		}
		
		protected function randomConduit():Class {
			var conduits:Array = [LongConduit, /*TConduit, */HookConduit, LeftHookConduit];
			return C.randomChoice(conduits);
		}
		
		public function toString():String {
			return "{"+minos+"}";
		}
		
	}
}