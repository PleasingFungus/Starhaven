package Metagame {
	import Mining.Terrain;
	import Mining.MineralBlock;
	import Missions.AsteroidMission;
	import Missions.PlanetMission;
	import Missions.NebulaMission;
	import Scenarios.PlanetScenario;
	import Scenarios.AsteroidScenario;
	import Scenarios.NebulaScenario;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MissionChoice extends FlxGroup {
		
		public var mission:Class;
		protected var missionSize:Number;
		protected var seed:Number;
		
		protected var selectionBlock:FlxSprite;
		public function MissionChoice(Mission_:Class, X:int, Y:int) {
			super();
			mission = Mission_;
			seed = FlxU.seed = FlxU.random();
			
			var rawMap:Terrain;
			switch (Mission_) {
				case PlanetScenario: rawMap = new PlanetMission(seed).rawMap; break;
				case AsteroidScenario: rawMap = new AsteroidMission(seed).rawMap; break;
				case NebulaScenario: rawMap = new NebulaMission(seed).rawMap; break;
			}
			var map:FlxSprite = makeMap(rawMap);
			map.x = X;
			map.y = Y - map.height / 2;
			
			selectionBlock = new FlxSprite(map.x - 10, map.y - 10).createGraphic(map.width * map.scale.x + 20, map.height * map.scale.y + 20);
			selectionBlock.alpha = 0.2;
			add(selectionBlock);
			add(map);
		}
		
		override public function update():void {
			var moused:Boolean = selectionBlock.overlapsPoint(FlxG.mouse.x, FlxG.mouse.y);
			selectionBlock.alpha = moused ? 1 : 0.2;
			if (FlxG.mouse.justPressed() && moused) {
				FlxU.seed = seed;
				FlxG.state = new mission(seed);
			}
		}
		
		
		protected function makeMap(rawMap:Terrain):FlxSprite {
			var scale:int = 4;
			while (rawMap.mapDim.y * scale > FlxG.height / 4 - 20)
				scale--;
			var map:FlxSprite = new FlxSprite().createGraphic(rawMap.mapDim.x * scale, rawMap.mapDim.y * scale, 0x0, true);
			var stamp:FlxSprite = new FlxSprite().createGraphic(scale-1, scale-1);
			
			for each (var block:MineralBlock in rawMap.map) {
				stamp.color = block.type > 0 ? 0x5c537d : 0xa0a0a0;//TODO: deal with bedrock, be classier
				map.draw(stamp, block.x * scale, block.y * scale);
			}
			map.frame = 0;
			//map.scale.x = map.scale.y = 3;
			
			return map;
		}
		
	}

}