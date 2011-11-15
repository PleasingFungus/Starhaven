package  {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import Icons.*;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import SFX.Fader;
	
	import Sminos.*;
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class Smino extends Mino {
		public function get station():Station { return parent as Station; }
		public var powered:Boolean;
		public var submerged:Boolean;
		public var transmitsPower:Boolean;
		
		public var powerReq:int = 0;
		public var powerGen:int = 0;
		public var crewReq:int = 0;
		public var crewCapacity:int = 0;
		public var crew:int = 0;
		public var crewEmployed:int = 0;
		public var description:String = "Placeholder description.";
		
		protected var leech:IconLeech;
		protected var powerIcon:Icontext;
		protected var housingIcon:Icontext;
		
		private var dullColor:uint;
		private var poweredColor:uint;
		protected var opSprite:Class;
		protected var inopSprite:Class;
		
		//TODO: setup dual sprite caching?
		//private var opSprites:Array;
		//private var inopSprites:Array;
		
		public function Smino(X:int, Y:int, Blocks:Array, Center:Point,
							  DullColor:uint = 0xffa0a0a0, PoweredColor:uint = 0xfff8fb89,
							  OpSprite:Class = null, InopSprite:Class = null) {
			dullColor = DullColor;
			poweredColor = PoweredColor;
			opSprite = OpSprite;
			inopSprite = InopSprite;
			
			super(X, Y, Blocks, Center,
				  powered ? PoweredColor : DullColor,
				  (powered || !InopSprite) ? OpSprite : InopSprite);
			
			cycleSpeed = .8 * C.B.BASE_AREA.width / C.B.PlayArea.width;
			
			C.iconLayer.add(new IconLeech(null, renderTop));
			if (powerGen > 0) {
				powerIcon = new Icontext(x, y + height / 2 - 8, width, "+" + powerGen, C.ICONS[C.POWER]);
				powerIcon.color = 0x0;
			} else if (crewCapacity > 0) {
				housingIcon = new Icontext(x, y + height / 2 - 8, width, "+" + crewCapacity, C.ICONS[C.HOUSING]);
				housingIcon.color = 0x0;
			}
			
			all_minos.push(this);
		}
		
		
		override protected function anchorTo(Parent:Aggregate):void {
			checkBounds();
			if (!exists)
				return;
			
			Parent.add(this);
			addToGrid();
			notifyNeighbors();
			mergeNeighbors();
			
			if (!(parent is Station))
				return;
			
			checkWater();
			hungerForPower();
			cycleSpeed = 1;
			
			FlxG.quake.start(0.015, 0.075);
		}
		
		protected function checkBounds():void {
			if (!outsideOuterBounds())
				return;
			
			var X:int = gridLoc.x - center.x;
			var Y:int = gridLoc.y - center.y;
			
			for (var i:int = 0; i < blocks.length; i++) {
				var block:Block = blocks[i];
				if (block.outsideOuterBounds(X, Y)) {
					//blocks.splice(i, 1);
					//i--;
					block.damaged = true;
				}
			}
			
			//if (blocks.length == 0)
			if (exists) {
				new Fader(this);
				exists = false;
			}
			
			damaged = dead = true;
			falling = false;
			damagedBy = this; //?
		}
		
		protected function checkWater():void {
			if (C.fluid && C.fluid.intersect(this))
				submerged = true;
		}
		
		public function hungerForPower():void {
			var powerSource:Mino;
			var neighbors:Array = getNeighbors();
			for each (var neighbor:Smino in neighbors)
				//neighbor.setColor(0xffff0000);
				if (neighbor.powered && neighbor.transmitsPower && !neighbor.damaged) {
					powerSource = neighbor;
					break;
				}
			
			if (powerSource)
				gainPower(powerSource);
		}
		
		public function gainPower(powerSource:Mino, neighbors:Array = null):void {
			if (submerged)
				return;
			
			powered = true;
			if (transmitsPower && !damaged)
				transmitPower(neighbors);
		}
		
		protected function transmitPower(neighbors:Array):void {
			if (!neighbors)
				neighbors = getNeighbors();
			for each (var neighbor:Smino in neighbors)
				if (!neighbor.powered)
					neighbor.gainPower(this);
		}
		
		
		public function hungerForCrew():void {
			if (crewDeficit <= 0)
				return;
			
			var neighbors:Array = getNeighbors();
			for each (var neighbor:Smino in neighbors) {
				//C.log(neighbor.name +': ' + neighbor.surplusCrew);
				if (neighbor.surplusCrew <= 0)
					continue;
				
				if (neighbor.surplusCrew >= crewDeficit) {
					neighbor.crewEmployed += crewDeficit;
					crewEmployed = crewReq;
					break;
				}
				
				crewEmployed += neighbor.surplusCrew;
				neighbor.crewEmployed = neighbor.crew;
			}
		}
		
		public function get surplusCrew():int {
			if (!operational)
				return 0;
			return crew - crewEmployed;
		}
		
		public function get crewDeficit():int {
			if (opStatus < OP_INTACT)
				return 0;
			return crewReq - crewEmployed;
		}
		
		
		
		
		
		protected function notifyNeighbors():void {
			var neighbors:Array = getNeighbors();
			for each (var neighbor:Smino in neighbors)
				neighbor.addNeighbor(this);
		}
		
		
		
		
		public function get opStatus():int {
			if (falling)
				return OP_FALLING;
			if (damaged)
				return OP_ATTACHED;
			if (!(C.DEBUG && C.NO_CREW) && (crewEmployed < crewReq || crew < crewCapacity))
				return OP_INTACT;
			if (!powered)
				return OP_READY;
			return OP_FULL;
		}
		
		public function get operational():Boolean {
			return opStatus == OP_FULL;
		}
		
		//protected function get ready():Boolean {
			//return !damaged && crew == crewReq;
		//}
		
		
		
		/*override public function beExploded(explosionOrigin:Point, explosionRadius:int, explosionBounds:Rectangle):void {
			if (!exists || falling)
				return;
			
			//check each point
			for each (var block:Block in blocks) {
				if (block.damaged)
					continue;
				
				var distance:int = Math.abs((block.x + gridLoc.x - center.x) - explosionOrigin.x) + Math.abs((block.y + gridLoc.y - center.y) - explosionOrigin.y);
				
				//if it's within the radius from the origin (manhattan-style)...
				if (distance < explosionRadius) {
					damaged = true;
					block.damaged = true;
					Mino.setGrid(gridLoc.x - center.x + block.x, gridLoc.y - center.y + block.y, null);
				}
			}
			
			if (damaged)
				beDamaged();
		}*/
		
		override public function takeExplodeDamage(X:int, Y:int, Source:Mino):void {
			if (!exists || falling)
				return;
			
			var adjustedX:int = X - gridLoc.x + center.x;
			var adjustedY:int = Y - gridLoc.y + center.y;
			for each (var block:Block in blocks)
				/*if (block.x == adjustedX && block.y == adjustedY && !block.damaged)*/ {
					damaged = newlyDamaged = dead = true;
					block.damaged = true;
					Mino.setGrid(X, Y, null);
				}
			
			new Fader(this, 3);
			exists = false;
			
			damagedBy = Source;
		}
		
		override protected function beDamaged():void {
			resetSprites();
			generateSprite(); //may be excessive, but that's okay
			
			crew = 0;
			if (transmitsPower)
				disconnectNeighbors();
			
			newlyDamaged = false;
		}
		
		protected function disconnectNeighbors():void {
			for each (var smino:Smino in getNeighbors()) {
				if (smino.powerGen || !smino.powered || smino.damaged)
					continue; //can't be disconnected!
				smino.losePower();
			}
		}
		
		protected function losePower():void {
			if (powerGen) return;
			
			powered = false;
			hungerForPower();
			if (!powered && transmitsPower)
				disconnectNeighbors();
		}
		
		
		override public function outsidePlayArea():Boolean {
			var b:Rectangle = bounds;
			return b.left < C.B.PlayArea.left || b.right > C.B.PlayArea.right;
		}
		
		
		
		
		override public function render():void {
			simpleRender();
		}
		
		public function simpleRender():void {
			if (sprite) {
				var curSprite:Class = (operational || !inopSprite) ? opSprite : inopSprite;
				if (curSprite != sprite) {
					sprite = curSprite;
					resetSprites();
					generateSprite();
				}
			} else
				color = operational ? poweredColor : dullColor;
			super.render();
		}
		
		protected function minoRender():void {
			super.render();
		}
		
		override public function renderTop(force:Boolean = false):void {
			if (!exists)
				return;
			else if (Scenario.substate == Scenario.SUBSTATE_NORMAL/* || force*/)
				iconRender();
		}
		
		protected function iconRender():void {
			if (falling)
				return;
			
			if (!operational)
				renderErrors();
			else
				renderSupply();
		}
		
		private var debugBlock:FlxSprite;
		protected function renderDebugBlock():void {
			if (!debugBlock)
				debugBlock = new FlxSprite().createGraphic(C.BLOCK_SIZE, C.BLOCK_SIZE, C.DEBUG_COLOR);
			var p:Point = iconPosition();
			debugBlock.x = p.x - debugBlock.width / 2;
			debugBlock.y = p.y - debugBlock.height / 2;
			debugBlock.render();
		}
		
		protected function renderErrors():void {
			var errorIcons:Array = getErrorIcons();
			
			var totalWidth:int = 0;
			for each (var icon:FlxSprite in errorIcons)
				totalWidth += icon.width;
			totalWidth += 4 * (errorIcons.length - 1);
			
			var b:Rectangle = getDrawBounds();
			
			if (errorIcons.length == 1 && errorIcons[0] is Icontext) {
				var t:Icontext = errorIcons[0] as Icontext;
				iconPosition(t);
				t.render();
			} else for (var i:int = 0; i < errorIcons.length; i++) {
				var errorIcon:FlxSprite = errorIcons[i];
				errorIcon.x = b.x + b.width / 2 - totalWidth / 2 + i * totalWidth / (errorIcons.length);
				errorIcon.y = b.y + b.height / 2 - errorIcon.height/2;
				errorIcon.render();
			}
		}
		
		protected function getErrorIcons():Array {
			if (damaged)
				return []//new FlxSprite().loadGraphic(C.ICONS[C.DAMAGE])];
			
			var errorIcons:Array = [];
			
			if (submerged)
				errorIcons.push(SubmergedIcon.instance);
			else if (!transmitsPower && !powered)
				errorIcons.push(NoPowerIcon.instance);
			else if (crewEmployed < crewReq) {
				InsufficientCrewIcon.instance.text = crewDeficit+"";
				errorIcons.push(InsufficientCrewIcon.instance);
			}
			
			return errorIcons;
		}
		
		protected function renderSupply():void {
			/*if (powerGen > 0) {
				powerIcon.text = powerGen+"";
				powerIcon.x = x + width/2 - powerIcon.realWidth / 2 + C.B.drawShift.x;
				powerIcon.y = y + height / 2 - powerIcon.height / 2 + C.B.drawShift.y;
				
				powerIcon.update();
				powerIcon.render();
			} else */if (surplusCrew > 0) {
				housingIcon.text = surplusCrew + "";
				
				iconPosition(housingIcon);
				
				housingIcon.update();
				housingIcon.render();
			}
		}
		
		protected function iconPosition(icon:Icontext=null):Point {
			//volumetric center
			//var volumetricCenter:Point = absoluteCenter.subtract(topLeft);
			//volumetricCenter.offset(blockDim.x / 2, blockDim.y / 2);
			//if (facing == LEFT)
				//volumetricCenter.x += 2;
			//else if (facing == UP)
				//volumetricCenter.y += 2;
			//volumetricCenter = new Point(volumetricCenter.x * C.BLOCK_SIZE, volumetricCenter.y * C.BLOCK_SIZE).add(C.B.drawShift);
			//
			//housingIcon.x = volumetricCenter.x - housingIcon.realWidth / 2;
			//housingIcon.y = volumetricCenter.y - housingIcon.height / 2;
			//return volumetricCenter;
			
			var b:Rectangle = getDrawBounds();
			var pos:Point = new Point(b.x + b.width / 2,
									  b.y + b.height / 2);
			
			//var pos:Point = new Point(x + width / 2 + C.B.drawShift.x,
									  //y + height / 2 + C.B.drawShift.y);
			
			if (icon) {
				pos.offset( -icon.realWidth / 2, - icon.height / 2);
				icon.x = pos.x;
				icon.y = pos.y;
			}
			return pos;
		}
		
		override public function minimapColor(block:Block=null):uint {
			if (operational)
				return poweredColor;
			return dullColor;
		}
		
		
		
		public function getNeighbors(force:Boolean = false):Array {
			if (local_cache && !force)
				return local_cache;
			
			local_cache = [];
			for each(var mino:Mino in all_minos)
				if (mino != this && mino.exists && adjacent(mino) && mino is Smino)
					local_cache.push(mino);
			return local_cache;
		}
		protected var local_cache:Array = null;
		
		public function addNeighbor(neighbor:Smino):void {
			if (local_cache)
				local_cache.push(neighbor);
		}
		
		
		
		
		public static const OP_FALLING:int = -1;
		public static const OP_ATTACHED:int = 0;
		public static const OP_INTACT:int = 1;
		public static const OP_READY:int = 2;
		public static const OP_FULL:int = 3;
	}

}