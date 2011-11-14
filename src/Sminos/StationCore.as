package Sminos {
	import flash.geom.Point;
	import org.flixel.FlxG;
	import Icons.Icontext;
	import Mining.MineralBlock;
	import SFX.Fader;
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class StationCore extends PowerGen {
		
		public var blastRadius:int = 15;
		public function StationCore(X:int, Y:int) {
			var blocks:Array = [];
			for (var x:int = 0; x < 5; x++)
				for (var y:int = 0; y < 5; y++)
					blocks.push(new Block(x, y));
			
			super(X, Y, blocks, new Point(2, 2), 1200, 0, _sprite);
			crewCapacity = crew = crewEmployed = crewReq;
			powered = true;
			name = "Station Core";
		}
		
		
		override public function takeExplodeDamage(X:int, Y:int, Source:Mino):void {
			damaged = dead = newlyDamaged = true;
			damagedBy = Source;
		}
		
		
		override protected function beDamaged():void {
			writeEpitaph();
			
			explode(blastRadius);
			FlxG.quake.stop();
			FlxG.quake.start(0.1, 3);
			for each (var block:Block in blocks)
				block.damaged = true;
			new Fader(this, 3);
			
			super.beDamaged();
		}
		
		protected function writeEpitaph():void {
			var causeOfDeath:String;
			
			switch (damagedBy.name) {
				case "Secondary Reactor": causeOfDeath = "blown apart in a chain reaction"; break;
				case "Asteroid": causeOfDeath = "destroyed by asteroids"; break;
				default: causeOfDeath = "lost to the warp"; break;
			}
			
			//station.writeEpitaph(causeOfDeath);
		}
		
		
		[Embed(source = "../../lib/art/sminos/core.png")] private static const _sprite:Class;
	}

}