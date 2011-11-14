package Mining {
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public interface ResourceSource {
		function resourceAt(point:Point):MineralBlock;
		function mine(point:Point):void;
		function unmine(point:Point):void;
		function totalResources():int;
	}
	
}