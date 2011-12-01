package Helpers {
	import Controls.ControlSet;
	import flash.geom.Rectangle;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import Sminos.Bomb;
	
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class BombHelper extends FlxGroup {
		
		public var parent:Smino;
		private var icon:FlxSprite;
		private var helper:KeyHelper;
		public function BombHelper(Parent:Smino) {
			super();
			parent = Parent;
			
			add(icon = new FlxSprite().loadGraphic(parent is Bomb ? _boom_icon : _bomb_icon));
			add(helper = ControlSet.BOMB_KEY.generateKeySprite());
		}
		
		override public function update():void {
			if (!parent.exists || !parent.active) {
				exists = false; return;
			}
			
			var parentBounds:Rectangle = parent.getDrawBounds();
			var scale:Number = helper.scale.x * helper.scale.x;
			
			helper.x = parentBounds.x + parentBounds.width / 2 - helper.width / 2;
			helper.y = parentBounds.bottom + BUFFER * scale;
			
			icon.x = helper.x + helper.width + BUFFER * scale;
			icon.y = helper.y + helper.height / 2 - icon.height / 2;
		}
		
		private const BUFFER:int = 6;
		
		[Embed(source = "../../lib/art/sminos/bomb.png")] private static const _bomb_icon:Class;
		[Embed(source = "../../lib/art/ui/icon_damage_robust.png")] private static const _boom_icon:Class;
	}

}