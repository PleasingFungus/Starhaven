package Sminos {
	import flash.geom.Point;
	import Mining.MineralBlock;
	import Mining.WaterMineral;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class Scoop extends Smino {
		
		public function Scoop(X:int, Y:int ) {
			var blocks:Array = [new Block(0, 0), 				  new Block(2, 0),
								new Block(0, 1), new Block(1, 1), new Block(2, 1),
												 new Block(1, 2)];
			super(X, Y, blocks, new Point(1, 1), 0xff64448f, 0xff9348f4, _sprite, _sprite_in);
			cladeName = "Scoop";
			name = "Scoop";
			description = "Use scoops to smash into purple mineral clusters and dislodge them; then use conduits to collect the minerals when they bob to the surface!";
			audioDescription = _desc;
		}
		
		override protected function anchorTo(Parent:Aggregate):void {
			//checkWater();
			if (facing == DOWN) {
				parent = Parent;
				drill();
			}
			
			super.anchorTo(Parent);
			powered = true; //shenanagains?
		}
		
		protected function drill():void {
			var forward:Point = new Point(0, 1);
			var target:Mino = station.resourceSource as Mino;
			var tip:Array = [blocks[2], blocks[4], blocks[5]];
			
			var Parent:Aggregate = parent;
			do {
				var stopped:Boolean = false;
				parent = Parent;
				
				for each (var block:Block in tip) {
					var drillPoint:Point = block.add(absoluteCenter).add(forward);
					var drillBlock:MineralBlock = station.resourceSource.resourceAt(drillPoint);
					
					if (drillBlock && drillBlock.type == MineralBlock.BEDROCK) {
						stopped = true;
						break;
					}
				}
				
				if (!stopped) {
					for each (block in tip)
						minePoint(block.add(absoluteCenter).add(forward));
					gridLoc = gridLoc.add(forward);
				}
				
				parent = null;
			} while (!stopped && !intersects());
			
			if (intersects())
				gridLoc = gridLoc.subtract(forward);
			parent = Parent;
			
			//intersects() only works if you bother to fuck around with turning parent on and off, which I ain't.
		}
		
		protected function minePoint(point:Point):void {
			var block:MineralBlock = station.resourceSource.resourceAt(point);
			if (block && !block.damaged) {
				station.resourceSource.mine(point);
				if (block.type > 0)
					Mino.layer.add(new WaterMineral(point.x, point.y, block.type, block.value));
			}
		}
		
		override protected function getErrorIcons():Array { return [] }
		
		[Embed(source = "../../lib/art/sminos/scoop.png")] private static const _sprite:Class;
		[Embed(source = "../../lib/art/sminos/scoop_in.png")] private static const _sprite_in:Class;
		[Embed(source = "../../lib/sound/vo/scoops.mp3")] public static const _desc:Class;
	}

}