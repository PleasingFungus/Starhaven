package Scenarios {
	import org.flixel.*;
	import Mining.BaseAsteroid;
	import flash.display.BitmapData;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class SpaceScenario extends DefaultScenario {
		
		protected var bgMissionType:Class;
		public function SpaceScenario(Seed:Number) {
			super(Seed);
			bg_sprites = _bgs;
			mapBuffer = 20;
		}
		
		
		override protected function createBG():void {
			super.createBG();
			
			if (!bgMissionType)
				bgMissionType = missionType;
			
			parallaxBG = new FlxGroup;
			var sectors:Array = new Array(9);
			for (var X:int = 0; X < 3; X++)
				for (var Y:int = 0; Y < 3; Y++)
					sectors[X + Y * 3] = new Point(X, Y);
			
			for (var i:int = 0; i < 7; i++) {
				var bgMission:Mission = new bgMissionType(NaN, 0.9);
				var astrScale:Number = i > 3 ? i > 5 ? 1/2 : 1/4 : 1/8; 
				var bgAsteroid:BaseAsteroid = new BaseAsteroid(-1, -1, bgMission.rawMap.map, bgMission.rawMap.center, astrScale);
				var bmp:BitmapData = bgAsteroid.pixels.clone();
				
				var sectorIndex:int = FlxU.random() * sectors.length;
				var sector:Point = sectors[sectorIndex];
				sectors.splice(sectorIndex, 1);
				
				var spr:FlxSprite = new FlxSprite((FlxU.random()) * FlxG.width * 1.5 * sector.x / 3,
												  (FlxU.random()) * FlxG.height * 1.5 * sector.y / 3);
				spr.scrollFactor.x = spr.scrollFactor.y = astrScale;
				spr.pixels = bmp;
				spr.frame = 0;
				
				spr.color = bgAstrColor(astrScale);
				parallaxBG.add(spr);
			}
			
		}
		
		protected function bgAstrColor(scale:Number):uint {
			return 0x505050;
		}
		
		
		[Embed(source = "../../lib/art/backgrounds/garradd_3s.jpg")] private static const _bg1:Class;
		[Embed(source = "../../lib/art/backgrounds/garradd_4s.jpg")] private static const _bg2:Class;
		[Embed(source = "../../lib/art/backgrounds/garradd_5s.jpg")] private static const _bg3:Class;
		[Embed(source = "../../lib/art/backgrounds/garradd_6.jpg")] private static const _bg4:Class;
		[Embed(source = "../../lib/art/backgrounds/garradd_7s.jpg")] private static const _bg5:Class;
		private static const _bgs:Array = [_bg1, _bg2, _bg3, _bg4, _bg5];
	}

}