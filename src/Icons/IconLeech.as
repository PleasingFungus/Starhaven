package Icons {
	import org.flixel.FlxObject;
	
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class IconLeech extends FlxObject {
		
		private var onUpdate:Function;
		private var onRender:Function;
		public function IconLeech(OnUpdate:Function = null, OnRender:Function = null) {
			onUpdate = OnUpdate;
			onRender = OnRender;
		}
		
		override public function update():void {
			if (onUpdate != null)
				onUpdate();
		}
		
		override public function render():void {
			if (onRender != null)
				onRender();
		}
	}

}