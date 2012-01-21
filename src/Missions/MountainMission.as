package Missions {
	import org.flixel.FlxU;
	import Mining.MineralBlock;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class MountainMission extends TerrestrialMission {
		
		public function MountainMission(Seed:Number = NaN) {
			mapWidth = 60;
			rockDepth = 24;
			atmosphere = 24;
			
			super(Seed);
		}
		
		override protected function blockLimitToFullyMine():int {
			return 100;
		}
		
		override protected function topAt(x:int):int {
			var distFromCenter:int = Math.abs(x - mapWidth / 2);
			var distFraction:Number = distFromCenter / (mapWidth / 2);
			distFraction *= distFraction;
			return super.topAt(x) + (rockDepth * 2/3) * distFraction;
		}
		
		override protected function bedrockDepthAt(x:int):int {
			var distFromCenter:int = x - mapWidth / 2;
			if (distFromCenter < 2 && distFromCenter > -3)
				return int.MIN_VALUE; //pillar of bedrock beneath station core
			
			var distFraction:Number = Math.abs(distFromCenter) / (mapWidth / 2);
			distFraction *= distFraction;
			//var approxTop:int = rockDepth - (rockDepth / 2) * distFraction;
			//var relativeDeep:int = rockDepth / 2;
			
			var minDepth:int = Math.floor(rockDepth - (FlxU.random() * 2 + 2));
			var deep:int = minDepth - (1 - distFraction) * rockDepth / 8;
			return deep;
		}
		
		override protected function randomMineralType():int {
			return MineralBlock.WEAK_MINERALS;
		}
		
	}

}