package Editor {
	import Controls.Key;
	import GameBonuses.Attack.AttackStation;
	import Scenarios.DefaultScenario;
	import Scenarios.PlanetScenario;
	import Missions.LoadedMission;
	import Mining.PlanetMaterial;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class EditorState extends PlanetScenario {
		
		protected var minoIndex:int;
		protected var loader:StationLoader;
		public function EditorState() {
			super(NaN);
			
			mapBuffer = 0;
			rotateable = false;
		}
		
		override public function create():void {
			minoIndex = 0;
			super.create();
		}
		
		override protected function createMission():void {
			mission = new LoadedMission(_mission_image);
		}
		
		override protected function createTracker(_:Number = 0):void {
			super.createTracker(0);
		}
		
		override protected function createGCT(_:int):void {
			super.createGCT(0);
		}
		
		override protected function createStation():void {
			station = new AttackStation(function setRotationState(isRotating:Boolean):void { substate = isRotating ? SUBSTATE_ROTPAUSE : SUBSTATE_NORMAL; });
			station.minimap = hud.minimap;
			station.rotateable = rotateable;
			minoLayer.add(station);
			minoLayer.add(station.core);
			setBounds();
			buildLevel();
		}
		
		override protected function buildLevel():void {
			var planet:PlanetMaterial = new PlanetMaterial( -15, 0, mission.rawMap.map, mission.rawMap.center);
			station.core.center.x += 1;
			station.core.center.y -= 4;
			
			Mino.resetGrid();
			station.core.addToGrid();
			
			station.resourceSource = planet;
			
			var planet_bg:Mino = new Mino(planet.gridLoc.x, planet.gridLoc.y, mission.rawMap.map, mission.rawMap.center, 0xff23170f);
			
			minoLayer.add(planet_bg);
			minoLayer.add(planet);
			station.add(planet);
			Mino.all_minos.push(planet);
			planet.addToGrid();
			
			loadStation();
		}
		
		
		
		
		
		
		override protected function checkInput():void {
			super.checkInput();
			
			if (PRINT_KEY.justPressed())
				station.print();
			
			if (DECR_MINO_KEY.justPressed()) {
				if (currentMino) {
					currentMino.exists = false;
					killCurrentMino();
				}
				minoIndex = (minoIndex + loader.ALL_SMINOS.length - 1) % loader.ALL_SMINOS.length;
				spawnNextMino();
			}
			
			if (INCR_MINO_KEY.justPressed()) {
				if (currentMino) {
					currentMino.exists = false;
					killCurrentMino();
				}
				minoIndex = (minoIndex + 1) % loader.ALL_SMINOS.length;
				spawnNextMino();
			}
		}
		
		override protected function getMinoChoice():Class {
			return loader.ALL_SMINOS[minoIndex];
		}
		
		protected function loadStation():void {
			loader = new StationLoader(station);
		}
		
		override protected function checkEndConditions():void { } //never die
		
		protected const DECR_MINO_KEY:Key = new Key("A");
		protected const INCR_MINO_KEY:Key = new Key("S");
		protected const KILL_LAST_KEY:Key = new Key("D");
		protected const PRINT_KEY:Key = new Key("P");
		
		[Embed(source = "../../lib/missions/attack_2.png")] private static const _mission_image:Class;
	}

}