package {
	import Controls.ControlSet;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import GrabBags.GrabBag;
	import InfoScreens.NewPieceInfo;
	import InfoScreens.NewPlayerEvent;
	import MainMenu.MenuState;
	import MainMenu.MainMenuThing;
	
	import org.flixel.*;
	
	
	[SWF(width="480", height="480", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]
	public class Starhome extends FlxGame
	{
		public function Starhome()
		{
			super(480, 480, MenuState, 1);
			useDefaultHotKeys = false;
			init();
		}
		
		private function init():void {
			C.init(); //needs to be first!
			
			NewPieceInfo.init();
			NewPlayerEvent.init();
			MainMenuThing.init();
			ControlSet.load();
			C.difficulty.load();
			C.accomplishments.load();
		}
		
		override protected function onKeyUp(event:KeyboardEvent):void {
			super.onKeyUp(event);
			ControlSet.onKeyUp(event.keyCode, event.shiftKey);
			checkSound(event.keyCode);
		}
		
		private function checkSound(c:int):void {
			switch (c) {				
				case 48:
				case 96:
					FlxG.mute = !FlxG.mute;
					showSoundTray();
					break;
				case 109:
				case 189:
					FlxG.mute = false;
					FlxG.volume -= 0.1;
					showSoundTray();
					break;
				case 107:
				case 187:
					FlxG.mute = false;
					FlxG.volume += 0.1;
					showSoundTray();
					break;
			}
		}
		
		override protected function onFocusLost(event:Event=null):void { }
	}
}
