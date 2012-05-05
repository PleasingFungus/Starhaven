package Sminos {
	import flash.geom.Point;
	import Mining.MineralBlock;
	import HUDs.MinedText;
	import HUDs.CollectText;
	import Icons.Icontext;
	import Mining.ResourceSource;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class Drill extends Smino {
		
		public var drilling:Boolean;
		protected var mineralText:Icontext;
		protected var targetResource:ResourceSource;
		protected var shroud:Mino;
		public function Drill(X:int, Y:int, Blocks:Array, Center:Point, OpSprite:Class=null, InopSprite:Class=null) {
			super(X, Y, Blocks, Center, 0xff64448f, 0xff9348f4, OpSprite, InopSprite);
			cladeName = "Drill";
			description = "Drill point-first into purpleish mineral clusters to harvest them; then hook up the drill to power to collect the minerals!";			bombCarrying = true;
			waterproofed = true;
			//if (!C.BEAM_DEFENSE)
				//crewReq = 1;
			
			mineralText = new Icontext(x, y + height / 2 - 8, width, storedMinerals+"", C.ICONS[C.MINERALS]);
		}
		
		private var anchorTarget:Mino;
		override protected function anchorTo(hit:Mino):void {
			checkWater();
			if (!submerged) {
				parent = hit.parent;
				anchorTarget = hit;
				if (parent is Station)
					targetResource = (parent as Station).resourceSource;
				//drill();
				drilling = true;
				falling = false;
			}
		}
		
		
		
		protected function forwardDir():Point {
			return new Point(facing == LEFT ? -1 : facing == RIGHT ? 1 : 0, facing == UP ? -1 : facing == DOWN ? 1 : 0);
		}
		
		protected function drillOne(visual:Boolean = true):Boolean { return true }
		
		protected function drill():void {
			while (drillOne(false)) {}
			finishDrill();
		}
		
		override public function get operational():Boolean {
			return !drilling && super.operational;
		}
		
		protected function finishDrill():void { 
			mine();
			
			MinedText.mine(storedMinerals);
			powerReq = 1;
			drilling = false;
			super.anchorTo(anchorTarget);
			anchorTarget = null;
		}
		
		protected var drilledMinos:Array = [];
		protected function drillTip(tip:Point):MineralBlock {
			var block:MineralBlock = targetResource.resourceAt(tip);
			if (!block || block.damaged) {
				var mino:Mino = Mino.getGrid(tip.x, tip.y);
				if (mino && mino.exists && !(mino is StationCore) && drilledMinos.indexOf(mino) == -1) {
					mino.solid = false;
					drilledMinos.push(mino);
				}
				return null;
			}
			
			if (block.type == MineralBlock.BEDROCK)
				return block;
			
			if (block.type > 0)
				storedMinerals += block.value;
			
			targetResource.mine(tip);
			return block;
		}
		
		protected function minePoint(point:Point):MineralBlock {
			var block:MineralBlock = targetResource.resourceAt(point);
			if (block && !block.damaged && block.type > 0) {
				storedMinerals += block.value;
				targetResource.mine(point);
				return block;
			}
			return null;
		}
		
		protected function mine():void {
			var shroudBlocks:Array = [];
			var abscen:Point = absoluteCenter;
			for (var X:int = topLeft.x; X < topLeft.x + blockDim.x; X++)
				for (var Y:int = topLeft.y; Y < topLeft.y + blockDim.y; Y++) {
					if (minePoint(new Point(X + abscen.x, Y + abscen.y)))
						shroudBlocks.push(new Block(X,Y));
				}
			shroud = new Mino(gridLoc.x, gridLoc.y, shroudBlocks, center.clone(), 0xffffffff);
			shroud.alpha = INITIAL_SHROUD_ALPHA;
		}
		
		protected var drillTimer:Number = 0;
		protected var drillTime:Number = 0.2;
		override public function update():void {
			if (drilling)
				animateDrill();
			else
				super.update();
		}
		
		protected function animateDrill():void {
			if (!current)
				drill();
			else {
				drillTimer += FlxG.elapsed;
				if (drillTimer >= drillTime) {
					if (drillOne())
						drillTimer -= drillTime;
					else
						drill();
					C.sound.play(DRILL_NOISE, 0.5);
				}
			}
		}
		
		override protected function runCycle():void {
			super.runCycle();
			
			if (operational && storedMinerals) {
				station.mineralsMined += storedMinerals;
				CollectText.collect(storedMinerals);
				storedMinerals = 0;
				powerReq = 0;
			}
		}
		
		override public function render():void {
			super.render();
			if (storedMinerals && !damaged)
				renderMineralsIcon();
		}
		
		private const INITIAL_SHROUD_ALPHA:Number = 0.75;
		override public function renderTop(_:Boolean, force:Boolean = false):void {
			super.renderTop(_);
			if (exists && shroud) {
				shroud.alpha -= FlxG.elapsed * INITIAL_SHROUD_ALPHA;
				if (shroud.alpha < 0)
					shroud = null;
				else if (C.HUD_ENABLED)
					shroud.render();
			}
		}
		
		protected function renderMineralsIcon():void {
			iconPosition(mineralText);
			mineralText.text = storedMinerals+"";
			mineralText.update();
			mineralText.render();
		}
		
		override protected function renderErrors():void {
			if (!drilling)
				super.renderErrors();
		}
		
		override public function get holdsAttention():Boolean {
			return super.holdsAttention || drilling;
		}
		
		override public function stealthAnchor(station:Aggregate):void {
			silent = true;
			super.anchorTo(station.core);
		}
		
		[Embed(source = "../../lib/sound/game/drill.mp3")] protected const DRILL_NOISE:Class;
		
	}

}