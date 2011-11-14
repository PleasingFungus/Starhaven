package Sminos {
	import flash.geom.Point;
	import Icons.Icontext;
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class PowerGen extends Smino {
		
		//private var powerIcon:Icontext;
		//private var powerAmount:int;
		public function PowerGen(X:int, Y:int, Blocks:Array, Center:Point,
								 PowerGeneration:int = 0, CrewReq:int = 0,
								 Sprite:Class = null, InopSprite:Class = null) {
			
			powerGen = PowerGeneration;
			crewReq = CrewReq;
			transmitsPower = true;
			
			super(X, Y, Blocks, Center, 0xffdb3d3d, 0xfffff947, Sprite, InopSprite);
			
			
			//powerIcon = new Icontext(x, y + height / 2 - 8, width, "+" + PowerGeneration, C.ICONS[C.POWER]);
			//powerIcon.color = 0x0;
		}
		
		//override public function render():void {
			//super.render();
			//if (operational)
				//renderPowerIcon();
		//}
		//
		//protected function renderPowerIcon():void {
			//powerIcon.x = x + width/2 - (powerIcon.textWidth + 18) / 2 + 18 + C.drawShift.x;
			//powerIcon.y = y + height / 2 - powerIcon.height / 2 + C.drawShift.y;
			//
			//powerIcon.update();
			//powerIcon.render();
		//}
	}

}