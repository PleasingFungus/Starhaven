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
		protected var storedMinerals:int = 0;
		protected var mineralText:Icontext;
		protected var targetResource:ResourceSource;
		public function Drill(X:int, Y:int, Blocks:Array, Center:Point, OpSprite:Class=null, InopSprite:Class=null) {
			super(X, Y, Blocks, Center, 0xff64448f, 0xff9348f4, OpSprite, InopSprite);
			cladeName = "Drill";
			description = "Drill point-first into purplish mineral clusters to harvest them; then hook the drills up to power to collect the minerals!";
			audioDescription = _desc;
			
			mineralText = new Icontext(x, y + height / 2 - 8, width, storedMinerals+"", C.ICONS[C.MINERALS]);
		}
		
		override protected function anchorTo(Parent:Aggregate):void {
			checkWater();
			if (!submerged) {
				parent = Parent;
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
		
		protected function drillOne():Boolean { return true }
		
		protected function drill():void {
			while (drillOne()) {}
			finishDrill();
		}
		
		override public function get operational():Boolean {
			return !drilling && super.operational;
		}
		
		protected function finishDrill():void { 
			MinedText.mine(storedMinerals);
			powerReq = 1;
			drilling = false;
			super.anchorTo(parent);
		}
		
		protected function minePoint(point:Point):void {
			var block:MineralBlock = targetResource.resourceAt(point);
			if (block && !block.damaged && block.type > 0) {
				storedMinerals += block.value;
				targetResource.mine(point);
			}
		}
		
		protected var drillTimer:Number = 0;
		protected const DRILL_TIME:Number = 0.2;
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
				if (drillTimer >= DRILL_TIME) {
					if (drillOne())
						drillTimer -= DRILL_TIME;
					else
						drill();
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
		
		[Embed(source = "../../lib/sound/vo/drills.mp3")] public static const _desc:Class;
		
	}

}