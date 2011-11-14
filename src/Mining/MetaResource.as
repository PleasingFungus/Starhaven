package Mining {
	import flash.geom.Point;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class MetaResource implements ResourceSource {
		
		public var members:Array;
		public function MetaResource(Members:Array) {
			members = Members;
		}
		
		public function resourceAt(point:Point):MineralBlock {
			for each (var resourceSource:ResourceSource in members) {
				var resource:MineralBlock = resourceSource.resourceAt(point);
				if (resource)
					return resource;
			}
			return null;
		}
		
		public function mine(point:Point):void {
			for each (var resourceSource:ResourceSource in members) {
				if (resourceSource.resourceAt(point)) {
					resourceSource.mine(point);
					break;
				}
			}
		}
		
		public function unmine(point:Point):void {
			for each (var resourceSource:ResourceSource in members) {
				if (resourceSource.resourceAt(point)) {
					resourceSource.unmine(point);
					break;
				}
			}
		}
		
		public function totalResources():int {
			var total:int = 0;
			for each (var resourceSource:ResourceSource in members)
				total += resourceSource.totalResources();
			return total;
		}
		
	}

}