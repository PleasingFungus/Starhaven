package Options {
	import org.flixel.FlxG;
	import Controls.Key;
	import Controls.ControlSet;
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class ControlMenuThing extends MenuThing {
		
		private var desc:String;
		private var key:Key;
		
		private var chosen:Boolean;
		
		private var blinkTimer:Number = 0;
		private var blinkPeriod:Number = 0.4;
		public function ControlMenuThing(desc:String, key:Key) {
			super(desc + key.toString());
			this.desc = desc;
			this.key = key;
			//
			//text.font = C.BLOCKFONT;
			//text.size = 12;
			createHighlight();
		}
		
		
		
		
		override public function update():void {
			if (chosen && !selected)
				unchoose();
			
			if (selected && chosen) {
				if (FlxG.keys.justPressed("ENTER"))//(ControlSet.CONFIRM_KEY.justReleased()) {
					unchoose();
			} else {
				if (genString() != text.text) {
					text.text = genString();
					createHighlight();
				}
				
				super.update();
			}
		}
		
		override protected function choose():void {
			//if (chosen) {
				//unchoose();
				//return;
			//}
			for each (var thing:MenuThing in menuThings)
				thing.deselect();
			selected = true;
			
			chosen = true;
			text.text = desc;
			
			ControlSet.registerKeyListener(onKeyPressed);
			
			blinkTimer = blinkPeriod;
			highlight.visible = false;
		}
		
		private function onKeyPressed(keycode:int, shift:Boolean):void {
			if (FlxG.keys.justReleased("ENTER"))
				return;
			
			var keyname:String = FlxG.keys.keycodeToName(keycode);
			
			if (keyname && keyname != key.key) {
				//for each (var okey:Key in ControlSet.CONFIGURABLE_CONTROLS)
				for (var i:int = 0; i < ControlSet.CONFIGURABLE_CONTROLS.length; i++) {
					var okey:Key = ControlSet.CONFIGURABLE_CONTROLS[i];
					if (okey.key == keyname) {
						okey.key = key.key; //swap!
						C.netStats.changeKey(okey, keyname, okey.key);
						break;
					}
				}
				
				C.netStats.changeKey(key, key.key, keyname);
				key.key = keyname;
				
				ControlSet.save();
			}
			
			unchoose();
		}
		
		private function unchoose():void {
			chosen = false;
			//init(genString());
			ControlSet.deregisterKeyListener(onKeyPressed);
		}
		
		
		
		
		override public function render():void {
			if (chosen) {
				blinkTimer += FlxG.elapsed;
				if (blinkTimer >= blinkPeriod) {
					blinkTimer -= blinkPeriod;
					highlight.visible = !highlight.visible;
				}
				forceRender();
			} else
				super.render();
		}
		
		private function genString():String {
			return desc + key.toString();
		}
	}

}