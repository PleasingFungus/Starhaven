package Metagame {
	import org.flixel.*;
	import Credits.TitledColumn;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class Statblock {
		
		public var missionsWon:Number;
		public var blocksDropped:int;
		public var mineralsLaunched:int;
		public var meteoroidsDestroyed:int;
		public function Statblock(MissionsWon:int, BlocksDropped:int, MineralsLaunched:int, MeteoroidsDestroyed:int) {
			missionsWon = MissionsWon;
			blocksDropped = BlocksDropped;
			mineralsLaunched = MineralsLaunched;
			meteoroidsDestroyed = MeteoroidsDestroyed;
		}
		
		public function sum(other:Statblock):void {
			for (var i:int = MISSIONS_WON; i <= METEOROIDS_DESTROYED; i++)
				setByIndex(i, accessByIndex(i) + other.accessByIndex(i));
			//missionsWon += other.missionsWon;
			//blocksDropped += other.blocksDropped;
			//mineralsLaunched += other.mineralsLaunched;
			//meteoroidsDestroyed += other.meteoroidsDestroyed;
		}
		
		public function accessByIndex(index:int):int {
			switch (index) {
				case MISSIONS_WON: return missionsWon;
				case BLOCKS_DROPPED: return blocksDropped;
				case MINERALS_LAUNCHED: return mineralsLaunched;
				case METEOROIDS_DESTROYED: return meteoroidsDestroyed;
			}
			this["Invalid Index!"]; //crashes
			return -1;
		}
		
		public function setByIndex(index:int, value:int):int {
			switch (index) {
				case MISSIONS_WON: return missionsWon = value; break;
				case BLOCKS_DROPPED: return blocksDropped = value; break;
				case MINERALS_LAUNCHED: return mineralsLaunched = value; break;
				case METEOROIDS_DESTROYED: return meteoroidsDestroyed = value; break;
			}
			return value;
		}
		
		public function createDisplay(Y:int, Comparator:Statblock = null):FlxGroup {
			colGroup = new FlxGroup;
			
			colY = Y;
			colIndex = colHeight = 0;
			
			addStat("Missions Won", missionsWon, Comparator ? Comparator.missionsWon : -1);
			addStat("Blocks Dropped", blocksDropped, Comparator ? Comparator.blocksDropped : -1);
			addStat("Minerals Launched", mineralsLaunched, Comparator ? Comparator.mineralsLaunched : -1);
			addStat("Meteoroids Destroyed", meteoroidsDestroyed, Comparator ? Comparator.meteoroidsDestroyed : -1);
			
			return colGroup;
		}
		
		private var colIndex:int;
		private var colY:int;
		private var colHeight:int;
		private var colGroup:FlxGroup;
		private function addStat(Name:String, Value:int, Best:int = -1, Unit:String = ""):void {
			var X:int = !(colIndex % 2) ? FlxG.width / 4 : FlxG.width * 3 / 4;
			var Y:int = colY;
			
			var titledCol:TitledColumn = new TitledColumn(X, Y, Name);
			titledCol.addCol(C.decimalize(Value) + Unit);
			if (Best != -1)
				titledCol.addCol("Best: " + C.decimalize(Best));
			//'next' goes here
			colGroup.add(titledCol);
			
			colIndex ++;
			colHeight = Math.max(colHeight, titledCol.height);
			if (!(colIndex % 2)) {
				colY += colHeight + 25;
				colHeight = 0;
			}
		}
		
		public function save(prefix:String):void {
			C.save.write(prefix + 'Wins', missionsWon);
			C.save.write(prefix + 'Blocks', blocksDropped);
			C.save.write(prefix + 'Minerals', mineralsLaunched);
			C.save.write(prefix + 'Meteoroids', meteoroidsDestroyed);
		}
		
		public static function load(prefix:String):Statblock {
			return new Statblock(C.save.read(prefix + 'Wins') as Number, 
								 C.save.read(prefix + 'Blocks') as int,  
								 C.save.read(prefix + 'Minerals') as int, 
								 C.save.read(prefix + 'Meteoroids') as int);
		}
		
		public function toString():String {
			return missionsWon + " wins, " + blocksDropped + " dropped, " + mineralsLaunched + " launched, " + meteoroidsDestroyed + " destroyed.";
		}
		
		public static const MISSIONS_WON:int = 0;
		public static const BLOCKS_DROPPED:int = 1;
		public static const MINERALS_LAUNCHED:int = 2;
		public static const METEOROIDS_DESTROYED:int = 3;
	}

}