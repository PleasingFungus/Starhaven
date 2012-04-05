package Metagame {
	import flash.net.URLVariables;
	import org.flixel.*;
	import Credits.TitledColumn;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class Statblock {
		
		public var score:int;
		public var missionsWon:int;
		public var blocksDropped:int;
		public var mineralsLaunched:int;
		public var meteoroidsDestroyed:int;
		public var timeElapsed:Number;
		public function Statblock(Score:int, MissionsWon:int, BlocksDropped:int, MineralsLaunched:int, MeteoroidsDestroyed:int, TimeElapsed:Number) {
			score = Score;
			missionsWon = MissionsWon;
			blocksDropped = BlocksDropped;
			mineralsLaunched = MineralsLaunched;
			meteoroidsDestroyed = MeteoroidsDestroyed;
			timeElapsed = TimeElapsed;
			if (isNaN(timeElapsed)) timeElapsed = 0;
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
				case SCORE: return score;
				case MISSIONS_WON: return missionsWon;
				case BLOCKS_DROPPED: return blocksDropped;
				case MINERALS_LAUNCHED: return mineralsLaunched;
				case METEOROIDS_DESTROYED: return meteoroidsDestroyed;
				case TIME_ELAPSED: return timeElapsed;
			}
			this["Invalid Index!"]; //crashes
			return -1;
		}
		
		public function setByIndex(index:int, value:int):int {
			switch (index) {
				case SCORE: return score = value; break;
				case MISSIONS_WON: return missionsWon = value; break;
				case BLOCKS_DROPPED: return blocksDropped = value; break;
				case MINERALS_LAUNCHED: return mineralsLaunched = value; break;
				case METEOROIDS_DESTROYED: return meteoroidsDestroyed = value; break;
				case TIME_ELAPSED: return timeElapsed = value;
			}
			return value;
		}
		
		public function createDisplay(Y:int, Comparator:Statblock = null, RenderWon:Boolean = true):FlxGroup {
			colGroup = new FlxGroup;
			
			colY = Y;
			colIndex = colHeight = 0;
			
			if (RenderWon) {
				var titledCol:TitledColumn = new TitledColumn(FlxG.width/2, colY-5, "Score");
				//titledCol.setWidth(FlxG.width);
				titledCol.addCol(score + " pts");
				colGroup.add(titledCol);
				colY += titledCol.height + 35;
				
				var BestScore:int = Comparator ? Comparator.score : -1;
				if (BestScore != -1) {
					var bestText:String = "Best: " + C.decimalize(BestScore);
					titledCol.addCol(bestText);
				}
				
				addStat("Missions Won", MISSIONS_WON, Comparator);
			} else
				addStat("Score", SCORE, Comparator);
			addStat("Blocks Dropped", BLOCKS_DROPPED, Comparator);
			addStat("Minerals Launched", MINERALS_LAUNCHED, Comparator);
			addStat("Meteoroids Destroyed", METEOROIDS_DESTROYED, Comparator);
			
			return colGroup;
		}
		
		private var colIndex:int;
		private var colY:int;
		private var colHeight:int;
		private var colGroup:FlxGroup;
		private function addStat(Name:String, Index:int, Comparator:Statblock = null, Unit:String = ""):void {
			var X:int = !(colIndex % 2) ? FlxG.width / 4 : FlxG.width * 3 / 4;
			var Y:int = colY;
			
			var Value:int = accessByIndex(Index);
			var Best:int = Comparator ? Comparator.accessByIndex(Index) : -1;
			
			var titledCol:TitledColumn = new TitledColumn(X, Y, Name);
			titledCol.addCol(C.decimalize(Value) + Unit);
			if (Best != -1) {
				var bestText:String = "Best: " + C.decimalize(Best);
				var req:int = C.unlocks.requiredDifficultyForNext(Index);
				
				if (!C.ALL_UNLOCKED) {
					if (req > C.difficulty.initialSetting) {
						bestText += ", Next: \n[Req's " + C.difficulty.name(req)+"+]";
					} else {
						var next:int = C.unlocks.nextUnlockFor(Index);
						if (next != -1)
							bestText += ", Next: " + C.decimalize(next);
					}
				}
				titledCol.addCol(bestText);
			}
			colGroup.add(titledCol);
			
			colIndex ++;
			colHeight = Math.max(colHeight, titledCol.height);
			if (!(colIndex % 2)) {
				colY += colHeight + 25;
				colHeight = 0;
			}
		}
		
		public function save(prefix:String):void {
			C.save.write(prefix + 'Score', score);
			C.save.write(prefix + 'Wins', missionsWon);
			C.save.write(prefix + 'Blocks', blocksDropped);
			C.save.write(prefix + 'Minerals', mineralsLaunched);
			C.save.write(prefix + 'Meteoroids', meteoroidsDestroyed);
			C.save.write(prefix + 'Elapsed', timeElapsed);
		}
		
		public static function load(prefix:String):Statblock {
			return new Statblock(C.save.read(prefix + 'Score') as int,
								 C.save.read(prefix + 'Wins') as int, 
								 C.save.read(prefix + 'Blocks') as int,  
								 C.save.read(prefix + 'Minerals') as int, 
								 C.save.read(prefix + 'Meteoroids') as int, 
								 C.save.read(prefix + 'Elapsed') as Number);
		}
		
		public function toString():String {
			return score + " points, " + missionsWon + " wins, " + blocksDropped + " dropped, " + mineralsLaunched + " launched, " + meteoroidsDestroyed + " destroyed.";
		}
		
		public function networkSend(variables:URLVariables):void {
			variables.score = score;
			variables.missionsWon = missionsWon;
			variables.blocksDropped = blocksDropped;
			variables.mineralsLaunched = mineralsLaunched;
			variables.meteoroidsDestroyed = meteoroidsDestroyed;
			variables.timeElapsed = timeElapsed;
		}
		
		public static const SCORE:int = 5;
		public static const MISSIONS_WON:int = 0;
		public static const BLOCKS_DROPPED:int = 1;
		public static const MINERALS_LAUNCHED:int = 2;
		public static const METEOROIDS_DESTROYED:int = 3;
		public static const TIME_ELAPSED:int = 4;
	}

}