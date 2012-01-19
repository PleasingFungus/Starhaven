package Metagame {
	import org.flixel.*;
	import Credits.TitledColumn;
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
		
		public function createDisplay(Y:int):FlxGroup {
			colGroup = new FlxGroup;
			
			var completed:FlxText = new FlxText(10, Y, FlxG.width - 20, "Levels Beaten: "+C.campaign.missionNo);
			completed.setFormat(C.FONT, 30, 0xffffff, 'center');
			colGroup.add(completed);
			//'best' goes here
			
			colY = completed.y + completed.height + 60;
			colIndex = colHeight = 0;
			
			addStat("Time Elapsed", timeElapsed, "s");
			addStat("Blocks Dropped", blocksDropped);
			addStat("Minerals Launched", mineralsLaunched);
			addStat("Meteoroids Destroyed", meteoroidsDestroyed);
			
			return colGroup;
		}
		
		private var colIndex:int;
		private var colY:int;
		private var colHeight:int;
		private var colGroup:FlxGroup;
		private function addStat(Name:String, Value:int, Unit:String = ""):void {
			var X:int = !(colIndex % 2) ? FlxG.width / 4 : FlxG.width * 3 / 4;
			var Y:int = colY;
			
			var titledCol:TitledColumn = new TitledColumn(X, Y, Name);
			titledCol.addCol(Value+Unit);
			//'best' goes here
			colGroup.add(titledCol);
			
			colIndex ++;
			colHeight = Math.max(colHeight, titledCol.height);
			if (!(colIndex % 2)) {
				colY += colHeight + 25;
				colHeight = 0;
			}
		}
	}

}