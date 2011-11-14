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
			init();
		}
		
		private function init():void {
			C.init(); //needs to be first!
			
			ControlSet.load();
			NewPieceInfo.init();
			NewPlayerEvent.init();
			MainMenuThing.init();
		}
		
		override protected function onKeyUp(event:KeyboardEvent):void {
			super.onKeyUp(event);
			ControlSet.onKeyUp(event.keyCode, event.shiftKey);
		}
	}
}
