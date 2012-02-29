package {
	import Controls.ControlSet;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import GrabBags.GrabBag;
	import InfoScreens.NewPieceInfo;
	import InfoScreens.NewPlayerEvent;
	import MainMenu.MenuState;
	
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
			C.load();
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
		
		override protected function onFocusLost(event:Event = null):void {
			if (FlxG.state is Scenario)
				(FlxG.state as Scenario).enterPauseState();
		}
		
		override protected function onFocus(event:Event = null):void {
			if (FlxG.state is Scenario)
				(FlxG.state as Scenario).leavePauseState();
		}
		
		override protected function onEnterFrame(event:Event):void {
			try {
				super.onEnterFrame(event);
			} catch (exception:Error) {
				if (C.netStats)
					C.netStats.logException(exception);
				C.log(exception.getStackTrace());
				throw(exception);
			}
		}
	}
}
