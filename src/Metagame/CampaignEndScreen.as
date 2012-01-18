package Metagame {
	import org.flixel.*;
	import MainMenu.StateThing;
	import MainMenu.MenuState;
	import Credits.TitledColumn;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class CampaignEndScreen extends FadeState {
		
		override public function create():void {
			var title:FlxText = new FlxText(10, 10, FlxG.width - 20, "Mission Over!");
			title.setFormat(C.TITLEFONT, 48, 0xffffff, 'center', 0x1);
			add(title);
			
			var completed:FlxText = new FlxText(10, title.y + title.height, FlxG.width - 20, "Levels Beaten: "+C.campaign.missionNo);
			completed.setFormat(C.FONT, 24, 0xffffff, 'center');
			add(completed);
			//'best' goes here
			
			colY = completed.y + completed.height + 30;
			
			addStat("Time Elapsed", C.campaign.statblock.timeElapsed, "s");
			addStat("Blocks Dropped", C.campaign.statblock.blocksDropped);
			addStat("Minerals Launched", C.campaign.statblock.mineralsLaunched);
			addStat("Meteoroids Destroyed", C.campaign.statblock.meteoroidsDestroyed);
			
			MenuThing.resetThings();
			MenuThing.addColumn([add(new StateThing("Try Again", CampaignState))], FlxG.width/8);
			MenuThing.addColumn([add(new StateThing("Back to Menu", MenuState))], FlxG.width * 5 / 8);
			for each (var option:MenuThing in MenuThing.menuThings)
				option.setY(FlxG.height - 40);
			MenuThing.menuThings[0].select();
			
			C.campaign = null;
		}
		
		private var colIndex:int;
		private var colY:int;
		private var colHeight:int;
		private function addStat(Name:String, Value:int, Unit:String = ""):void {
			var X:int = !(colIndex % 2) ? FlxG.width / 4 : FlxG.width * 3 / 4;
			var Y:int = colY;
			
			var titledCol:TitledColumn = new TitledColumn(X, Y, Name);
			titledCol.addCol(Value+Unit);
			//'best' goes here
			add(titledCol);
			
			colIndex ++;
			colHeight = Math.max(colHeight, titledCol.height);
			if (!(colIndex % 2)) {
				colY += colHeight + 25;
				colHeight = 0;
			}
		}
		
	}

}