package GameBonuses.Music 
{
	import org.flixel.FlxText;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MusicName extends FlxText 
	{
		
		public function MusicName(X:int, Y:int, Width:int) {
			super(X, Y, Width, ' ');
			setFormat(C.FONT, 24, 0xffffff, 'center');
		}
		
		override public function update():void {
			text = C.music.normalMusic.name;
		}
	}

}