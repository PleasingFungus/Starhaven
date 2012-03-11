package  {
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import HUDs.Minimap;
	import Mining.MetaResource;
	import Mining.MineralBlock;
	import Mining.ResourceSource;
	import SFX.Fader;
	import SFX.PickupSound;
	import SFX.PowerSound;
	import Sminos.StationCore;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class Station extends Aggregate {
		
		protected var newlyDamaged:Array;
		protected var newDamage:Boolean;
		public var crewDeficit:Boolean;
		public var rotateable:Boolean;
		public var slowJuice:Boolean;
		public var silent:Boolean;
		
		protected var lastCrewed:Array;
		protected var newCrewed:Array;
		protected var lastPowered:Array;
		protected var pickupSound:PickupSound;
		protected var powerSound:PowerSound;
		
		public var resourceSource:ResourceSource;
		protected var _mineralsMined:int;
		public var mineralsLaunched:int;
		public var minimap:Minimap;
		
		public var lifespan:Number;
		
		public function Station(SetRotationState:Function) {
			super(makeCore(), SetRotationState);
			core.addToGrid();
			
			lastCrewed = [];
			lastPowered = [];
			pickupSound = new PickupSound;
			powerSound = new PowerSound;
			silent = true;
			
			lifespan = 0;
		}
		
		protected function makeCore():Smino {
			return new StationCore(0, 0);
		}
		
		//override public function merge(other:Aggregate):void {
			//super.merge(other);
			//if (resourceSource is MetaResource)
				//(resourceSource as MetaResource).members.push(other.resourceSource);
		//}
		
		override public function update():void {
			super.update();
			updateMinoStatus();
			checkMinerals();
			lifespan += FlxG.elapsed;
			silent = false;
		}
		
		protected function updateMinoStatus():void {
			newDamage = false;
			for (var i:int = 0; i < members.length; i++)
				if (members[i].newlyDamaged || !members[i].exists) {
					newDamage = true;
					break;
				}
			
			if (newDamage)
				handleDamage();
			
			iterOverMembers(nullCrew);
			newCrewed = [];
			iterOverMembers(huntCrew);
			lastCrewed = newCrewed;
			
			iterOverMembers(huntNewPowered);
			//TODO: check for newly inoperational things [damage only?]
			lastPowered = [];
			iterOverMembers(populatePowered);
			powerSound.update();
		}
		
		protected function handleDamage():void {
			resetPower();
			cleanup();
			minimap.dirty = true;
		}
		
		protected var newlyPowered:Boolean;
		protected var newlyConnected:Boolean;
		protected function resetPower():void {
			iterOverMembers(nullParentage);
			core.parent = this;
			newlyConnected = true;
			while (newlyConnected) {
				newlyConnected = false;
				iterOverMembers(checkAdjacency);
			}
			iterOverMembers(killNonadjacent);
			
			iterOverMembers(nullConnection);
			newlyPowered = true;
			while (newlyPowered) {
				newlyPowered = false;
				iterOverMembers(checkConnections);
			}
		}
		
		protected function cleanup():void {
			for (var i:int = 0; i < members.length; i++)
				if (!members[i].exists) {
					members.splice(i, 1);
					i--;
				}
		}
		
		protected function nullConnection(smino:Smino):void {
			if (!smino.powerGen)
				smino.powered = false;
		}
		
		protected function checkConnections(smino:Smino):void {
			if (!smino.powered) {
				smino.hungerForPower();
				if (smino.powered)
					newlyPowered = true;
			}
		}
		
		protected function nullParentage(smino:Smino):void {
			smino.parent = null;
			for each (var mino:Mino in members)
				if (mino.exists && !(mino is Smino) && smino.adjacent(mino))
					smino.parent = this;
			smino.getNeighbors(true);
		}
		
		protected function checkAdjacency(smino:Smino):void {
			if (smino.parent == this)
				return;
			
			for each (var neighbor:Smino in smino.getNeighbors())
				if (neighbor.parent == this) {
					smino.parent = this;
					newlyConnected = true;
					return;
				}
		}
		
		protected function killNonadjacent(smino:Smino):void {
			if (smino.parent != this) {
				smino.exists = false;
				smino.removeFromGrid();
				new Fader(smino);
			}
		}
		
		protected function nullCrew(smino:Smino):void {
			smino.crewEmployed = 0;
		}
		
		protected function huntCrew(smino:Smino):void {			
			if (smino.opStatus == Smino.OP_READY && smino.powerGen)
				smino.gainPower(smino); //make power-gens self-start
			else {
				smino.hungerForCrew();
				if (smino.crewDeficit)
					crewDeficit = true;
				else if (smino.crewEmployed) {
					if (lastCrewed.indexOf(smino) == -1 && !silent)
						C.sound.crew();
					newCrewed.push(smino);
				}
			}
		}
		
		protected function huntNewPowered(smino:Smino):void {
			if (!silent && !powerSound.newPowerup && !smino.transmitsPower &&
				smino.powered && lastPowered.indexOf(smino) == -1)
				powerSound.newPowerup = true;
		}
		
		protected function populatePowered(smino:Smino):void {
			if (!smino.transmitsPower && smino.powered)
				lastPowered.push(smino);
		}
		
		public function checkMinerals():void {
			var lastAvailable:int = _mineralsAvailable;
			
			_mineralsAvailable = resourceSource.totalResources();
			
			if (lastAvailable != _mineralsAvailable)
				minimap.dirty = true;
			
			core.storedMinerals = mineralsMined;
			pickupSound.update();
		}
		
		protected var recentlyMined:int;
		protected const BIG_SOUND_THRESHOLD:int = 75;
		public function set mineralsMined(amount:int):void {
			if (amount > _mineralsMined && !silent) {
				if (!pickupSound.playing)
					recentlyMined = 0;
				
				recentlyMined += amount - _mineralsMined;
				
				if (recentlyMined < BIG_SOUND_THRESHOLD) {
					pickupSound.playSmallChime();
				} else 
					pickupSound.playLargeChime();
			}
			_mineralsMined = amount;
		}
		
		public function get mineralsMined():int {
			return _mineralsMined;
		}
		
		public function refine(type:int, amount:int):void {
			amount = Math.min(amount, mineralsMined);
			mineralsLaunched += amount;
			mineralsMined -= amount;
		}
		
		
		override protected function rotate(clockwise:Boolean):Mino {
			var intersect:Mino = super.rotate(clockwise);
			
			if (!intersect) {
				//Mino.rotateGridAbout(core, clockwise);
				Mino.resetGrid();
				for each (var mino:Mino in Mino.all_minos)
					if (mino.exists && !mino.falling)
						mino.addToGrid();
			}
			
			//minimap.rotate(clockwise);
			minimap.dirty = true;
			return intersect;
		}
		
		protected function iterOverMembers(callback:Function):void {
			for each (var mino:Mino in members)
				if (mino.exists && mino is Smino)
					callback(mino as Smino);
		}
		
		
		private var _mineralsAvailable:int = -1;
		public function get mineralsAvailable():int {
			if (_mineralsAvailable == -1)
				_mineralsAvailable = resourceSource.totalResources();
			return _mineralsAvailable;
		}
		
		
		override public function get bounds():Rectangle {
			var baseBounds:Rectangle = super.bounds;
			
			baseBounds.left = Math.max(baseBounds.left, C.B.OUTER_BOUNDS.left);
			baseBounds.top = Math.max(baseBounds.top, C.B.OUTER_BOUNDS.top);
			if (baseBounds.right > C.B.OUTER_BOUNDS.right)
				baseBounds.width = C.B.OUTER_BOUNDS.right - baseBounds.x;
			if (baseBounds.bottom > C.B.OUTER_BOUNDS.bottom)
				baseBounds.height = C.B.OUTER_BOUNDS.bottom - baseBounds.y;
			
			return baseBounds;
		}
		
		public function print():void {
			var printString:String = '[';
			for each (var mino:Mino in members)
				if (mino is Smino && mino != core)
					printString += '"'+mino.serialize() + '", ';
			printString = printString.substr(0, printString.length - 2) + ']';
			C.log(printString);
		}
	}

}