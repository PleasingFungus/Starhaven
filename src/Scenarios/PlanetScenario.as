package Scenarios {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import Mining.BaseAsteroid;
	import Mining.MineralBlock;
	import Mining.Terrain;
	import Missions.PlanetMission;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	import Meteoroids.PlanetSpawner;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author ...
	 */
	public class PlanetScenario extends DefaultScenario {
		
		protected var mission:PlanetMission;
		public function PlanetScenario(Seed:Number = NaN) {
			super(Seed);
			
			mapBuffer = 0;
			bombs = 3;
			spawner = PlanetSpawner;
			if (C.difficulty.hard)
				goal = 0.65; //should be higher?
			bg_sprite = _bg;
			//bg_sprites = _bgs;
			rotateable = false;
		}
		
		override public function create():void {
			prepPlanet();
			super.create();
		}
		
		protected function prepPlanet():void {
			mission = new PlanetMission(seed);
			mapDim = mission.fullMapSize;
			C.log("Full Map Size: "+mission.fullMapSize.y);
		}
		
		override protected function createGCT(miningTime:Number = 55):void {
			super.createGCT(miningTime);
		}
		
		override protected function createStation():void {
			resourceSource = new BaseAsteroid( -1, -1, mission.rawMap.map, mission.rawMap.center);
			super.createStation();
			buildPlanet();
		}
		
		protected function buildPlanet():void {
			var planet:BaseAsteroid = resourceSource as BaseAsteroid;
			//shift planet
			station.core.gridLoc.y = PlanetMission.atmosphere - mission.fullMapSize.y// + Math.floor(station.core.blockDim.y / 2);
			Mino.resetGrid();
			station.core.addToGrid();
			planet.gridLoc.x = station.core.gridLoc.x;
			planet.gridLoc.y = Math.ceil(PlanetMission.atmosphere / 2);
			//erase overlapping planet blocks
			for (var i:int = 0; i < mission.rawMap.map.length; i++) {
				var aBlock:MineralBlock = mission.rawMap.map[i];
				var adjustedplanetBlock:Point = new Point(aBlock.x + planet.absoluteCenter.x,
															aBlock.y + planet.absoluteCenter.y);
				if (station.core.bounds.containsPoint(adjustedplanetBlock)) {
					mission.rawMap.map.splice(i, 1);
					i--;
				}
			}
			planet.forceSpriteReset();
			
			station.resourceSource = planet;
			initialMinerals = station.mineralsAvailable;
			
			var planet_bg:Mino = new Mino(planet.gridLoc.x, planet.gridLoc.y, mission.rawMap.map, mission.rawMap.center, 0xff303030);
			
			minoLayer.add(planet_bg);
			minoLayer.add(planet);
			station.add(planet);
			Mino.all_minos.push(planet);
			planet.addToGrid();
		}
		
		//override protected function createBG():void {
			//super.createBG();
			//var skyColor:uint = C.HSVToRGB(FlxU.random(), .3, .95);
			//var sky:FlxSprite = new FlxSprite().createGraphic(FlxG.width, FlxG.height, skyColor);
			//sky.alpha = 0.75;
			//bg.draw(sky);
		//}
		
		//[Embed(source = "../../lib/art/backgrounds/bg_1.jpg")] private static const _bg01:Class;
		//[Embed(source = "../../lib/art/backgrounds/bg_2.jpg")] private static const _bg0:Class;
		//[Embed(source = "../../lib/art/backgrounds/bg_3.jpg")] private static const _bg1:Class;
		//[Embed(source = "../../lib/art/backgrounds/bg_4.jpg")] private static const _bg2:Class;
		//[Embed(source = "../../lib/art/backgrounds/bg_5.jpg")] private static const _bg3:Class;
		//[Embed(source = "../../lib/art/backgrounds/bg_6.jpg")] private static const _bg4:Class;
		//private static const _bgs:Array = [_bg0, _bg01, _bg1, _bg2, _bg3, _bg4];
		[Embed(source = "../../lib/art/backgrounds/planetside.png")] private static const _bg:Class;
	}

}