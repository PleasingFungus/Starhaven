package Sminos {
	import flash.geom.Point;
	import Mining.MineralBlock;
	import Mining.WaterMineral;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class Scoop extends Drill {
		
		public function Scoop(X:int, Y:int ) {
			var blocks:Array = [new Block(0, 0), 				  new Block(2, 0),
								new Block(0, 1), new Block(1, 1), new Block(2, 1),
												 new Block(1, 2)];
			super(X, Y, blocks, new Point(1, 1), _sprite, _sprite_in);
			bombCarrying = false;
			rotateable = false;
			cladeName = "Scoop";
			name = "Scoop";
			description = "Use scoops to smash into mineral clusters and dislodge them; then use conduits to collect the minerals when they bob to the surface!";
		}
		
		override protected function drillOne(_:Boolean = true):Boolean {
			var forward:Point = new Point(0, 1);
			var target:Mino = station.resourceSource as Mino;
			var tip:Array = [blocks[2], blocks[4], blocks[5]];
			var drilledMinoTotal:int = drilledMinos.length;
			
			var minedTips:Array = new Array(3);
			for each (var block:Block in tip) {
				var drillPoint:Point = block.add(absoluteCenter).add(forward);
				var drillBlock:MineralBlock = station.resourceSource.resourceAt(drillPoint);
				
				if (drillBlock && drillBlock.type == MineralBlock.BEDROCK)
					return false;
				
				minedTips.push(drillPoint);
			}
			
			for each (drillPoint in minedTips)
				drillTip(drillPoint);
			
			gridLoc = gridLoc.add(forward);
			
			var Parent:Aggregate = parent;
			parent = null;
			var hit:Boolean = intersects() != null;
			parent = Parent;
			
			if (hit) {
				gridLoc = gridLoc.subtract(forward);
				for each (drillPoint in minedTips) 
					targetResource.unmine(drillPoint);
				return false;
			}
			
			
			if (minedTips.length || drilledMinoTotal != drilledMinos.length) {
				FlxG.quake.start(0.012, 0.065);
				drillTime *= 0.85;
			}
			return true;
		}
		
		override protected function minePoint(point:Point):MineralBlock {
			var minedBlock:MineralBlock = super.minePoint(point);
			if (storedMinerals)
				dumpMinerals(point, minedBlock.type);
			return minedBlock;
		}
		
		override protected function drillTip(point:Point):MineralBlock {
			var minedBlock:MineralBlock = super.drillTip(point);
			if (storedMinerals)
				dumpMinerals(point, minedBlock.type);
			return minedBlock;
		}
		
		protected function dumpMinerals(origin:Point, type:int):void {
			Mino.layer.add(new WaterMineral(origin.x, origin.y, type, storedMinerals));
			storedMinerals = 0;
		}
		
		override protected function finishDrill():void { 
			for each (var mino:Mino in drilledMinos)
				mino.takeExplodeDamage(-1, -1, this)
			super.finishDrill();
		}
		
		override protected function mine():void { }
		
		override protected function getErrorIcons():Array { return [] }
		
		[Embed(source = "../../lib/art/sminos/scoop.png")] private static const _sprite:Class;
		[Embed(source = "../../lib/art/sminos/scoop_in.png")] private static const _sprite_in:Class;
	}

}