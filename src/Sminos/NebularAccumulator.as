package Sminos {
	import flash.geom.Point;
	import Icons.Icontext;
	import Mining.MineralBlock;
	import org.flixel.FlxG;
	import HUDs.MinedText;
	import HUDs.CollectText;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class NebularAccumulator extends Smino {
		
		protected var mineralText:Icontext;
		protected var head:int;
		protected var shroud:Mino;
		public function NebularAccumulator(X:int, Y:int) {
			var blocks:Array = [				 new Block(1, 0),
								new Block(0, 1), new Block(1, 1), new Block(2, 1),
												 new Block(1, 2)];
			powerReq = 1;
			super(X, Y, blocks, new Point(1, 1), 0xff64448f, 0xff9348f4, _sprite, _sprite_in);
			
			name = "Nebular Accumulator";
			description = "Nebular Accumulators suck up minerals from the surrounding area. Once connected with conduits, you'll collect the minerals!";
			audioDescription = _desc;
			
			mineralText = new Icontext(x, y + height / 2 - 8, width, storedMinerals + "", C.ICONS[C.MINERALS]);
			
			genResourceShroud();
		}
		
		protected function genResourceShroud():void {
			var blocks:Array = [];
			var SUCK_SQUARED:int = SUCK_RADIUS * SUCK_RADIUS;
			for (var X:int = -SUCK_RADIUS; X <= SUCK_RADIUS; X++)
				for (var Y:int = - SUCK_RADIUS; Y <= SUCK_RADIUS; Y++)
					if (X*X + Y*Y <= SUCK_SQUARED)
						blocks.push(new Block(X, Y));
			
			shroud = new Mino(gridLoc.x, gridLoc.y, blocks, new Point, 0xffffffff);
			
			shroud.gridLoc = gridLoc;
			shroud.alpha = 1 / 4;
			
			C.iconLeeches.push(this);
		}
		
		override protected function anchorTo(hit:Mino):void {
			super.anchorTo(hit);
			suck();
		}
		
		protected const SUCK_RADIUS:int = 5;
		protected function suck():void {
			var absCenter:Point = absoluteCenter;
			var newBlocks:Array = [];
			for each (var block:Block in shroud.blocks)
				if (suckPoint(block.add(absCenter)))
					newBlocks.push(new Block(block.x -1, block.y -1));
			
			shroud.blocks = newBlocks;
			shroud.forceSpriteReset();
			shroud.alpha = 1;
			shroud.color = 0xffd800ff
			
			MinedText.mine(storedMinerals);
		}
		
		protected function suckPoint(point:Point):Boolean {
			var block:MineralBlock = station.resourceSource.resourceAt(point);
			if (block && !block.damaged && block.type > 0) {
				storedMinerals += block.value;
				station.resourceSource.mine(point);
				return true;
			}
			return false;
		}
		
		override protected function runCycle():void {
			super.runCycle();
			
			if (operational && storedMinerals) {
				powerReq = 0;
				station.mineralsMined += storedMinerals;
				CollectText.collect(storedMinerals);
				storedMinerals = 0;
			}
		}
		
		override public function render():void {
			super.render();
			if (storedMinerals && !damaged)
				renderMineralsIcon();
		}
		
		protected function renderShroud(force:Boolean = false):void {
			if (exists && shroud) {
				if (!falling)
					shroud.alpha -= FlxG.elapsed;
				if (shroud.alpha < 0)
					shroud = null;
				else 
					shroud.render();
			}
		}
		
		protected function renderMineralsIcon():void {
			iconPosition(mineralText);
			mineralText.text = storedMinerals+"";
			mineralText.update();
			mineralText.render();
		}
		
		[Embed(source = "../../lib/art/sminos/nebaccum.png")] private static const _sprite:Class;
		[Embed(source = "../../lib/art/sminos/nebaccum_in.png")] private static const _sprite_in:Class;
		[Embed(source = "../../lib/sound/vo/nebulaccum.mp3")] public static const _desc:Class;
	}

}