package Scenarios {
	import Meteoroids.EggSpawner;
	import flash.geom.Point;
	import GrabBags.BagType;
	import GrabBags.GrabBag;
	import Metagame.Upgrade;
	import Mining.BaseAsteroid;
	import Sminos.*;
	import Mining.MineralBlock;
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class DefaultScenario extends Scenario {
		
		protected var miningTool:Class = LongDrill;
		protected var mission:Mission;
		protected var missionType:Class;
		protected var rock:BaseAsteroid;
		public function DefaultScenario(Seed:Number) {
			super(Seed);
			
			mapDim = new Point(15, 15);
			spawner = EggSpawner;
			bg_sprite = _bg;
		}
		
		
		
		override public function create():void {
			createMission();
			mapDim = mission.fullMapSize;
			super.create();
			setupBags();
		}
		
		protected function createMission():void {
			mission = new missionType(seed);
		}
		
		override protected function buildLevel():void {
			buildRock();
			repositionLevel();
			eraseOverlap();
			addElements();
		}
		
		protected function buildRock():void {
			rock = new BaseAsteroid( -1, -1, mission.rawMap.map, mission.rawMap.center);
		}
		
		protected function repositionLevel():void {
			//override!
		}
		
		protected function eraseOverlap():void {
			for (var i:int = 0; i < mission.rawMap.map.length; i++) {
				var aBlock:MineralBlock = mission.rawMap.map[i];
				var adjustedrockBlock:Point = new Point(aBlock.x + rock.absoluteCenter.x,
															aBlock.y + rock.absoluteCenter.y);
				if (station.core.bounds.containsPoint(adjustedrockBlock)) {
					mission.rawMap.map.splice(i, 1);
					i--;
				}
			}
			rock.forceSpriteReset();
		}
		
		protected function addElements():void {
			Mino.resetGrid();
			station.core.addToGrid();
			rock.addToGrid();
			Mino.all_minos.push(rock);
			
			station.resourceSource = rock;
			initialMinerals = station.mineralsAvailable;
			
			minoLayer.add(rock);
			station.add(rock);
		}
		
		
		
		protected function setupBags():void {
			BagType.all = [new BagType("Assorted Bag", 1, [new BagType("Asst. 1", 1, getAssortment(0)),
														   new BagType("AsBag2", 1, getAssortment(1))])];
		}
		
		protected function getAssortment(index:int):Array {
			var assortment:Array = [makeBag(miningTool)];
			if (index)
				assortment = assortment.concat(makeBag(MediumLauncher), makeBag(SmallLauncher));
			else
				assortment.push(makeBag(miningTool), makeBag(RocketGun), makeBag(SmallLauncher));
				
			if (!(C.DEBUG && C.NO_CREW)) {
				if (index)
					assortment.push(makeBag(MediumBarracks));
				assortment.push(makeBag(SmallBarracks));
			}
			
			return assortment;
		}
		
		protected function makeBag(primarySmino:Class):BagType {
			primarySmino = replace(primarySmino);
			var conduit:Class = replace(Conduit);
			return new BagType(null, 1, [primarySmino, conduit]);
		}
		
		protected function replace(original:Class):Class {
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