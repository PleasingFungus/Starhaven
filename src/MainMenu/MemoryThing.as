package MainMenu {
	import flash.utils.getQualifiedClassName;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class MemoryThing extends StateThing {
		
		protected var lastChosen:int;
		public function MemoryThing(desc:String, assocState:Class) {
			super(desc, assocState);
			
			lastChosen = C.save.read(qualifier) as int; //will default to 0
			C.log(qualifier + ' -> ' + lastChosen);
			if (i == lastChosen)
				select();
		}
		
		override protected function choose():void {
			super.choose();
			lastChosen = i;
			C.save.write(qualifier, lastChosen);
		}
		
		protected var _qualifier:String;
		protected function get qualifier():String {
			if (!_qualifier) {
				var stateName:String = getQualifiedClassName(FlxG.state);
				stateName = stateName.substr(stateName.lastIndexOf(':') + 1);
				_qualifier = stateName + "LastChosen";
			}
			return _qualifier;
		}
	}

}