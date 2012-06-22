package Scenarios.Tutorials
{
	import Scenarios.PlanetScenario;
	import Missions.LoadedMission;
	import Mining.PlanetMaterial;
	
	public class Tutorial extends PlanetScenario
	{
		protected var levelImage:Class;
		
		public function Tutorial(mapImage:Class)
		{
			super();
			
			buildMusic = C.music.TUT_MUSIC;
			
			levelImage = mapImage;
		}
		
		override public function create():void {
			C.IN_TUTORIAL = true;
			super.create();
		}
		
		override protected function setupBags():void
		{
			C.difficulty.bagSize = bagType.length;
		}
		
		override protected function createMission():void {
			mission = new LoadedMission(levelImage);
		}
		
		override protected function createGCT(_:int):void {
			super.createGCT(0);
		}
		
		override protected function buildLevel():void {
			var planet:PlanetMaterial = new PlanetMaterial(-8, 0, mission.rawMap.map, mission.rawMap.center);
			station.core.center.x += 1;
			station.core.center.y -= 4;
			
			Mino.resetGrid();
			station.core.addToGrid();
			
			station.resourceSource = planet;
			initialMinerals = station.mineralsAvailable;
			
			var planet_bg:Mino = new Mino(planet.gridLoc.x, planet.gridLoc.y, mission.rawMap.map, mission.rawMap.center, 0xff23170f);
			
			minoLayer.add(planet_bg);
			minoLayer.add(planet);
			station.add(planet);
			Mino.all_minos.push(planet);
			planet.addToGrid();
			
			addSminos();
		}
		
		protected function addSminos():void {
			for each (var smino:Smino in (mission as LoadedMission).loadPieces(levelImage))
			{
				smino.stealthAnchor(station);
				Mino.layer.add(smino);
				Mino.all_minos.push(smino);
			}
		}
		
		override protected function shouldZoomOut():Boolean
		{
			return true;
		}
	}
}