package Scenarios {
	import Mining.NebulaCloud;
	import Missions.NebulaMission;
	import flash.geom.Point;
	import Mining.MineralBlock;
	import flash.geom.Rectangle;
	import Sminos.NebularAccumulator;
	/**
	 * ...
	 * @author ...
	 */
	public class NebulaScenario extends DefaultScenario {
		
		protected var mission:NebulaMission;
		public function NebulaScenario(Seed:Number = NaN) {
			super(Seed);
			if (C.difficulty.normal)
				goal = 0.4;
			miningTool = NebularAccumulator;
			bg_sprites = _bgs;
		}
		
		override public function create():void {
			prepNebula();
			super.create();
		}
		
		protected function prepNebula():void {
			mission = new NebulaMission(seed);
			mapDim = mission.fullMapSize;
		}
		
		override protected function _getBounds():Rectangle {
			return C.B.OUTER_BOUNDS;
		}
		
		override protected function createGCT(miningTime:Number = 50):void {
			super.createGCT(miningTime);
		}
		
		override protected function createStation():void {
			var preNebula:Number = new Date().valueOf();
			resourceSource = new NebulaCloud(0, 0,
											 mission.rawMap.map, mission.rawMap.center);
			//var preNebula:Number = new Date().valueOf();
			C.log("Time spent building nebula: " + ((new Date().valueOf()) - preNebula) + " ms.");
			super.createStation();
			buildNebula();
		}
		
		protected function buildNebula():void {
			var nebula:NebulaCloud = resourceSource as NebulaCloud;
			//erase overlapping asteroid blocks
			for each (var block:Block in station.core.blocks)
				nebula.mine(block.add(station.core.absoluteCenter));
			
			station.resourceSource = nebula;
			initialMinerals = station.mineralsAvailable;
			
			minoLayer.add(nebula);
		}
		
		[Embed(source = "../../lib/art/backgrounds/nebula_1.jpg")] private static const _bg01:Class;
		[Embed(source = "../../lib/art/backgrounds/nebula_2.jpg")] private static const _bg0:Class;
		[Embed(source = "../../lib/art/backgrounds/nebula_3.jpg")] private static const _bg1:Class;
		[Embed(source = "../../lib/art/backgrounds/nebula_4.jpg")] private static const _bg2:Class;
		[Embed(source = "../../lib/art/backgrounds/nebula_5.jpg")] private static const _bg3:Class;
		[Embed(source = "../../lib/art/backgrounds/nebula_6.jpg")] private static const _bg4:Class;
		private static const _bgs:Array = [_bg0, _bg01, _bg1, _bg2, _bg3, _bg4];
	}

}