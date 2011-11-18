package Sminos {
	import flash.geom.Point;
	import Mining.MineralBlock;
	import Mining.ResourceSource;
	import org.flixel.FlxSprite;
	import HUDs.MinedText;
	/**
	 * ...
	 * @author ...
	 */
	public class LongDrill extends Drill {
		
		protected var length:int = 8;
		public function LongDrill(X:int, Y:int) {
			var blocks:Array = [new Block(0, 0), new Block(1, 0), new Block(2, 0)];
			for (var i:int = 1; i < length; i++)
				blocks.push(new Block(1, i));
			super(X, Y, blocks, new Point(1, 0), _sprite, _sprite_in);
			
			name = "Long Drill";
			//sidewaysAttachable = false;
		}
			
		//rewrite me!
		override protected function drill(forward:Point):void {
			var tip:Point = new Point(gridLoc.x /*- center.x*/ + forward.x * length,
									  gridLoc.y /*- center.y*/ + forward.y * length);
			var target:Mino = Mino.getGrid(tip.x, tip.y);
			if (target && target is ResourceSource)
				targetResource = target as ResourceSource;
			else {
				//mine();
				return;
			}
			
			var Parent:Aggregate = parent;
			parent = null;
			do {
				var minedTip:MineralBlock = drillTip(tip);
				
				gridLoc = gridLoc.add(forward); //move forward
				tip = tip.add(forward);
				
				if (!minedTip)
					break;
				
				target.solid = false;
				if (intersects())
					break;
				target.solid = true;
			} while (!intersect(target));
			
			if (minedTip)
				targetResource.unmine(tip.subtract(forward));
			gridLoc = gridLoc.subtract(forward);
			
			parent = Parent;
			target.solid = true;
			
			mine();
		}
		
		protected function drillTip(tip:Point):MineralBlock {
			var block:MineralBlock = targetResource.resourceAt(tip);
			if (!block || block.damaged || block.type == MineralBlock.BEDROCK)
				return null;
			
			if (block.type > 0)
				storedMinerals += block.value;
			
			targetResource.mine(tip);
			return block;
		}
		
		protected function mine():void {
			var directions:Array = [new Point(1,0), new Point(0,1), new Point(-1,0), new Point(0,-1)];
			for each (var block:Block in blocks) {
				var adjustedBlock:Point = block.add(absoluteCenter);
				for each (var direction:Point in directions)
					minePoint(adjustedBlock.add(direction));
			}
			
			MinedText.mine(storedMinerals);
			powerReq = 1;
		}
		
		[Embed(source = "../../lib/art/sminos/drill.png")] private static const _sprite:Class;
		[Embed(source = "../../lib/art/sminos/drill_in.png")] private static const _sprite_in:Class;
		[Embed(source = "../../lib/art/sminos/drillhead.png")] private static const _headsprite:Class;
		[Embed(source = "../../lib/art/sminos/drillhead_in.png")] private static const _headsprite_in:Class;
	}

}