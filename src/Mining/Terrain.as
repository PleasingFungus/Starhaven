package Mining {
	import flash.geom.Point;
	/**
	 * ...
	 * @author ...
	 */
	public class Terrain {
		
		public var map:Array;
		public var mapDim:Point;
		public var center:Point;
		public function Terrain(Map:Array, MapDim:Point) {
			map = Map;
			mapDim = MapDim;
			center = new Point(Math.floor(mapDim.x / 2), Math.floor(mapDim.y / 2));
		}
		
	}

}