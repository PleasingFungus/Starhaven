package GameBonuses.Music 
{
	import Musics.MusicTrack;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author ...
	 */
	public class TrackArt extends FlxSprite 
	{
		private var currentArt:Class;
		public function TrackArt(X:int, Y:int) 
		{
			super(X, Y);
			loadGraphic(_placeholder);
		}
		
		override public function update():void {
			super.update();
			
			var art:Class = findArt(C.music.normalMusic);
			if (art != currentArt) {
				loadGraphic(art);
				currentArt = art;
			}
		}
		
		private function findArt(track:MusicTrack):Class {
			switch (track.name) {
				case "Starhaven": return _menu;
				case "Resonance": return _tut;
				case "Surface Tension": return _moon;
				case "Surface Tension (Azure Depths)": return _sea;
				case "Surface Tension (Red Alert)": return _redalert;
				case "Lucid Void": return _ast;
				case "Lucid Void (Forgotten Sector)": return _dust;
				case "Lucid Void (Hull Breach)": return _hullbreach;
				case "I Am The Greatest (VGTG)": return _victory;
				case "Collapse": return _defeat;
				default: return _placeholder;
			}
		}
		
		[Embed(source = "../../../lib/art/track art/placeholder.png")] private const _placeholder:Class;
		[Embed(source = "../../../lib/art/track art/resonance.png")] private const _tut:Class;
		[Embed(source = "../../../lib/art/track art/menu.jpg")] private const _menu:Class;
		[Embed(source = "../../../lib/art/track art/moon3.png")] private const _moon:Class;
		[Embed(source = "../../../lib/art/track art/sea.png")] private const _sea:Class;
		[Embed(source = "../../../lib/art/track art/lucid.png")] private const _ast:Class;
		[Embed(source = "../../../lib/art/track art/dust.jpg")] private const _dust:Class;
		[Embed(source = "../../../lib/art/track art/redalert.png")] private const _redalert:Class;
		[Embed(source = "../../../lib/art/track art/hullbreach.png")] private const _hullbreach:Class;
		[Embed(source = "../../../lib/art/track art/victory.png")] private const _victory:Class;
		[Embed(source = "../../../lib/art/track art/defeat.png")] private const _defeat:Class;
	}

}