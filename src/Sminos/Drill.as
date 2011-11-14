package Sminos {
	import flash.geom.Point;
	import Mining.MineralBlock;
	import HUDs.MinedText;
	import HUDs.CollectText;
	import Icons.Icontext;
	import Mining.ResourceSource;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class Drill extends Smino {
		
		protected var storedMinerals:int = 0;
		protected var mineralText:Icontext;
		protected var targetResource:ResourceSource;
		public function Drill(X:int, Y:int, Blocks:Array, Center:Point, OpSprite:Class=null, InopSprite:Class=null) {
			powerReq = 1;
			super(X, Y, Blocks, Center, 0xff64448f, 0xff9348f4, OpSprite, InopSprite);
			cladeName = "Drill";
			description = "Drill into purple mineral clusters to harvest them; then hook them up to power to collect the minerals!";
			
			mineralText = new Icontext(x, y + height / 2 - 8, width, storedMinerals+"", C.ICONS[C.MINERALS]);
		}
		
		override protected function anchorTo(Parent:Aggregate):void {
			checkWater();
			if (!submerged) {
				parent = Parent;
				if (parent is Station)
					targetResource = (parent as Station).resourceSource;
				var forward:Point = new Point(facing == LEFT ? -1 : facing == RIGHT ? 1 : 0,
											  facing == UP ? -1 : facing == DOWN ? 1 : 0);
				drill(forward);
			}
			super.anchorTo(Parent);
		}
		
		protected function drill(forward:Point):void { }
		
		protected function minePoint(point:Point):void {
			var block:MineralBlock = targetResource.resourceAt(point);
			if (block && !block.damaged && block.type > 0) {
				storedMinerals += block.value;
				targetResource.mine(point);
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
		
		protected function renderMineralsIcon():void {
			iconPosition(mineralText);
			mineralText.text = storedMinerals+"";
			mineralText.update();
			mineralText.render();
		}
		
	}

}