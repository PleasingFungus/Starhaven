package Scenarios {
	import Asteroids.EggSpawner;
	import flash.geom.Point;
	import GrabBags.BagType;
	import GrabBags.GrabBag;
	import Metagame.Upgrade;
	import Sminos.*;
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class DefaultScenario extends Scenario {
		
		protected var miningTool:Class = LongDrill;
		public function DefaultScenario(Seed:Number) {
			super(Seed);
			
			mapDim = new Point(15, 15);
			spawner = EggSpawner;
			bg_sprite = _bg;
		}
		
		override public function create():void {
			super.create();
			setupBags();
		}
		
		protected function setupBags():void {
			BagType.all = [];
			
			BagType.all.push(new BagType("Assorted Bag", 1, getAssortment()));
		}
		
		protected function getAssortment():Array {
			var assortment:Array = [makeBag(SmallFab), makeBag(SmallFab), makeBag(Fabricator),
									makeBag(miningTool), makeBag(miningTool), makeBag(miningTool), makeBag(AsteroidGun)];
			if (!(C.DEBUG && C.NO_CREW))
				assortment = assortment.concat(makeBag(SmallBarracks), makeBag(SmallBarracks), makeBag(MediumBarracks));
			return assortment;
		}
		
		protected function makeBag(primarySmino:Class):BagType {
			primarySmino = replace(primarySmino);
			var conduit:Class = replace(Conduit);
			return new BagType(null, 1, [primarySmino, conduit]);
		}
		
		private function replace(original:Class):Class {
			if (!C.campaign)
				return original;
			
			var upgrade:Upgrade = C.campaign.upgradeFor(original);
			if (upgrade) {
				upgrade.used = true;
				return upgrade.replacement;
			}
			return original;
		}
		
		public static const name:String = "Play";
		[Embed(source = "../../lib/art/backgrounds/stars_introv.png")] private static const _bg:Class;
	}

}