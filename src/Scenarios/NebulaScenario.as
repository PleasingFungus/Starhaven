package Scenarios {
	import Mining.NebulaCloud;
	import Missions.NebulaMission;
	import flash.geom.Point;
	import Mining.MineralBlock;
	import flash.geom.Rectangle;
	import Sminos.NebularAccumulator;
	import InfoScreens.NewPlayerEvent;
	/**
	 * ...
	 * @author ...
	 */
	public class NebulaScenario extends DefaultScenario {
		
		public function NebulaScenario(Seed:Number = NaN) {
			super(Seed);
			miningTool = NebularAccumulator;
			missionType = NebulaMission;
			bg_sprites = _bgs;
			mapBuffer = 20;
			goalMultiplier = 0.52;
			minoLimitMultiplier = 0.4;
			meteoSpeedMultiplier = 4/5;
		}
		
		override protected function buildLevel():void {
			var preNebula:Number = new Date().valueOf();
			var nebula:NebulaCloud = new NebulaCloud(0, 0,
											 mission.rawMap.map, mission.rawMap.center);
			C.log("Time spent building nebula: " + ((new Date().valueOf()) - preNebula) + " ms.");
			
			//erase overlapping asteroid blocks
			for each (var block:Block in station.core.blocks)
				nebula.mine(block.add(station.core.absoluteCenter));
			nebula.forceSpriteReset();
			
			station.resourceSource = nebula;
			initialMinerals = station.mineralsAvailable;
			
			minoLayer.add(nebula);
		}
		
		override protected function createBG():void {
			super.createBG();
			bg.color = 0xc0ffc0; //desaturate?
		}
		
		override protected function checkPlayerEvents():void {
			NewPlayerEvent.fire(NewPlayerEvent.NEBULA);
			super.checkPlayerEvents();
		}
		
		[Embed(source = "../../lib/art/backgrounds/nebula_1.jpg")] private static const _bg01:Class;
		[Embed(source = "../../lib/art/backgrounds/nebula_2.jpg")] private static const _bg0:Class;
		[Embed(source = "../../lib/art/backgrounds/nebula_3.jpg")] private static const _bg1:Class;
		[Embed(source = "../../lib/art/backgrounds/nebula_4.jpg")] private static const _bg2:Class;
		[Embed(source = "../../lib/art/backgrounds/nebula_5.jpg")] private static const _bg3:Class;
		[Embed(source = "../../lib/art/backgrounds/nebula_6s.jpg")] private static const _bg4:Class;
		private static const _bgs:Array = [_bg0, _bg01, _bg1, _bg2, _bg3, _bg4];
	}

}