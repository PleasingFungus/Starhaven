package  {
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import HUDs.Minimap;
	import Mining.MetaResource;
	import Mining.MineralBlock;
	import Mining.ResourceSource;
	import org.flixel.FlxSound;
	import SFX.Fader;
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
		
		protected var lastOperational:Array;
		protected var newOperational:Boolean;
		protected var powerSound:PowerSound;
		
		public var resourceSource:ResourceSource;
		protected var _mineralsMined:int;
		public var mineralsLaunched:int;
		public var minimap:Minimap;
		
		public var lifespan:Number;
		
		public function Station() {
			var core:StationCore = new StationCore(0, 0);//C.HALFWIDTH, C.HALFHEIGHT);
			super(core);
			core.addToGrid();
			
			/*lastOperational = [core];
			powerSound = new PowerSound;*/
			
			lifespan = 0;
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
		}
		
		protected function updateMinoStatus():void {
			newDamage = false;
			for (var i:int = 0; i < members.length; i++)
				if (members[i].newlyDamaged || !members[i].exists) {
					newDamage = true;
					break;
				}
			
			if (newDamage) {
				resetPower();
				cleanup();
				minimap.dirty = true;
			}
			
			iterOverMembers(nullCrew);
			iterOverMembers(huntCrew);
			
			/*iterOverMembers(huntNewOperational);
			//TODO: check for newly inoperational things [damage only?]
			lastOperational = [];
			iterOverMembers(populateOperational);
			powerSound.update();*/
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
			}
		}
		
		protected function huntNewOperational(smino:Smino):void {
			if (!smino.transmitsPower && smino.operational && lastOperational.indexOf(smino) == -1)
				powerSound.newPowerup = true;
		}
		
		protected function populateOperational(smino:Smino):void {
			if (!smino.transmitsPower && smino.operational)
				lastOperational.push(smino);
		}
		
		protected function checkMinerals():void {
			var lastAvailable:int = _mineralsAvailable;
			
			_mineralsAvailable = resourceSource.totalResources();
			
			if (lastAvailable != _mineralsAvailable)
				minimap.dirty = true;
			
			core.storedMinerals = mineralsMined;
		}
		
		protected var mineSound:FlxSound;
		protected var recentlyMined:int;
		protected var playingBigSound:Boolean;
		protected const BIG_SOUND_THRESHOLD:int = 75;
		public function set mineralsMined(amount:int):void {
			if (!mineSound)
				mineSound = new FlxSound();
			
			if (amount > _mineralsMined) {
				if (!mineSound.playing) {
					recentlyMined = 0;
					playingBigSound = false;
				}
				
				recentlyMined += amount - _mineralsMined;
				
				if (!mineSound.playing && recentlyMined < BIG_SOUND_THRESHOLD) {
					mineSound.loadEmbedded(COLLECT_NOISE);
					mineSound.volume = 0.5;
					mineSound.play();
				} else if (!playingBigSound && recentlyMined > BIG_SOUND_THRESHOLD) {
					mineSound.loadEmbedded(BIG_COLLECT_NOISE);
					mineSound.volume = 0.5;
					mineSound.play();
					playingBigSound = true;
				}
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
			for each (var mino:Mino in members.slice(0, members.length - 1))
				printString += '"'+mino.serialize() + '", ';
			C.log(printString + '"'+members[members.length - 1].serialize() + '"]');
		}
		
		[Embed(source = "../lib/sound/game/pickup2.mp3")] protected const COLLECT_NOISE:Class;
		[Embed(source = "../lib/sound/game/bigpickup.mp3")] protected const BIG_COLLECT_NOISE:Class;
	}

}