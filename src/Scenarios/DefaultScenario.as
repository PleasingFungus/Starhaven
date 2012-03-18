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
		protected var conduitLimit:int = int.MAX_VALUE;
		protected var conduitsUsed:int;
		public function DefaultScenario(Seed:Number) {
			super(Seed);
			
			mapDim = new Point(15, 15);
			spawnerType = EggSpawner;
			bg_sprite = _bg;
		}
		
		
		
		override public function create():void {
			conduitsUsed = 0;
			createMission();
			mapDim = mission.fullMapSize;
			super.create();
		}
		
		protected function createMission():void {
			mission = new missionType(seed, C.difficulty.scale());
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
		
		
		
		override protected function setupBags():void {
			var a1:BagType = new BagType(getAssortment(0));
			var a2:BagType = new BagType(getAssortment(1));
			bagType = new BagType([a1, a2]);
			C.difficulty.bagSize = bagType.length;
		}
		
		protected function getAssortment(index:int):Array {
			var assortment:Array = [makeBag(miningTool), makeBag(RocketGun)];
			if (index)
				assortment.push(makeBag(MediumLauncher), makeBag(SmallLauncher));
			else
				assortment.push(makeBag(miningTool), makeBag(SmallLauncher));
				
			if (!(C.DEBUG && C.NO_CREW)) {
				if (index)
					assortment.push(makeBag(MediumBarracks));
				assortment.push(makeBag(SmallBarracks));
			}
			
			return assortment;
		}
		
		protected function makeBag(primarySmino:Class):BagType {
			primarySmino = replace(primarySmino);
			if (conduitsUsed >= conduitLimit)
				return new BagType([primarySmino]);
			
			var conduit:Class = replace(Conduit);
			conduitsUsed++;
			return new BagType([primarySmino, conduit]);
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