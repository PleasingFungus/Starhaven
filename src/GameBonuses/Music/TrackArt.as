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
			
			var art:Class = findArt(C.music.intendedMusic);
			if (art != currentArt) {
				loadGraphic(art);
				currentArt = art;
			}
		}
		
		private function findArt(track:MusicTrack):Class {
			switch (track.name) {
				case "Starhaven": return _menu;
				case "Surface Tension": return _moon;
				case "Surface Tension (Aquatic Tension)": return _placeholder;
				default: return _placeholder;
			}
		}
		
		[Embed(source = "../../../lib/art/track art/placeholder.png")] private const _placeholder:Class;
		[Embed(source = "../../../lib/art/track art/menu.jpg")] private const _menu:Class;
		[Embed(source = "../../../lib/art/track art/moon2.png")] private const _moon:Class;
	}

}