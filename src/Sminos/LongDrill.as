package Sminos {
	import flash.geom.Point;
	import Mining.MineralBlock;
	import Mining.ResourceSource;
	import org.flixel.FlxSprite;
	import HUDs.MinedText;
	import org.flixel.FlxG;
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
		
		override protected function drillOne(_:Boolean = true):Boolean {			
			var forward:Point = forwardDir();
			var tip:Point = new Point(gridLoc.x /*- center.x*/ + forward.x * length,
									  gridLoc.y /*- center.y*/ + forward.y * length);
			var target:Mino = Mino.getGrid(tip.x, tip.y);
			if (target && target is ResourceSource)
				targetResource = target as ResourceSource;
			else if (station && station.resourceSource is Mino) {
				targetResource = station.resourceSource;
				target = targetResource as Mino;
			} else {
				//mine();
				return false;
			}
			
			var minedTip:MineralBlock = drillTip(tip);
			if (minedTip && minedTip.type == MineralBlock.BEDROCK)
				return false;
			
			gridLoc = gridLoc.add(forward); //move forward
			
			var Parent:Aggregate = parent;
			parent = null;
			var hit:Boolean = intersects() != null;
			parent = Parent;
			
			if (hit) {
				gridLoc = gridLoc.subtract(forward);
				if (minedTip)
					targetResource.unmine(tip);
				return false;
			}
			
			var neighbor:Boolean = hasNeighbor(target, Parent);
			if (neighbor) {
				FlxG.quake.start(0.012, 0.065);
				return true;
			}
			gridLoc = gridLoc.subtract(forward);
			return false;
		}
		
		protected function hasNeighbor(target:Mino, parent:Aggregate):Boolean {
			if (adjacent(target))
				return true;
			for each (var mino:Mino in parent.members)
				if (mino != this && mino.exists && adjacent(mino))
					return true;
			return false;
		}
		
		override protected function finishDrill():void { 
			for each (var mino:Mino in drilledMinos)
				mino.takeExplodeDamage(-1, -1, this)
			super.finishDrill();
		}
		
		[Embed(source = "../../lib/art/sminos/drill.png")] private static const _sprite:Class;
		[Embed(source = "../../lib/art/sminos/drill_in.png")] private static const _sprite_in:Class;
		[Embed(source = "../../lib/art/sminos/drillhead.png")] private static const _headsprite:Class;
		[Embed(source = "../../lib/art/sminos/drillhead_in.png")] private static const _headsprite_in:Class;
	}

}