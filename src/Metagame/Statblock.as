package Metagame {
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class Statblock {
		
		public var timeElapsed:Number;
		public var blocksDropped:int;
		public var mineralsLaunched:int;
		public var meteoroidsDestroyed:int;
		public function Statblock(TimeElapsed:Number, BlocksDropped:int, MineralsLaunched:int, MeteoroidsDestroyed:int) {
			timeElapsed = TimeElapsed;
			blocksDropped = BlocksDropped;
			mineralsLaunched = MineralsLaunched;
			meteoroidsDestroyed = MeteoroidsDestroyed;
		}
		
		public function sum(other:Statblock):void {
			timeElapsed += other.timeElapsed;
			blocksDropped += other.blocksDropped;
			mineralsLaunched += other.mineralsLaunched;
			meteoroidsDestroyed += other.meteoroidsDestroyed;
		}
	}

}