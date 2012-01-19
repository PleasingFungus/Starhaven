package Credits {
	import Controls.ControlSet;
	import org.flixel.*;
	import MainMenu.MenuState;
	
	/**
	 * ...
	 * @author Nicholas Feinberg
	 */
	public class CreditsState extends FadeState {
		
		
		private var titleBar:FlxSprite;
		private var creditGruppen:FlxGroup;
		public function CreditsState() {
			var title:FlxText = new FlxText(0, 15, FlxG.width, "Credits");
			title.setFormat(C.TITLEFONT, 48, 0xffffff, 'center');
			
			add(creditGruppen = new FlxGroup);
			add(titleBar = new FlxSprite().createGraphic(FlxG.width, title.y + title.height + 20, 0xff000000));
			add(title);
			colY = titleBar.y + titleBar.height;
			
			addCredit("Design", "Nicholas Feinberg");
			addCredit("Programming", "Nicholas Feinberg");
			addCredit("Art Lead", "Jackson Potter 'Jr.'");
			addCredit("Additional Art", "Nicholas Feinberg");
			addCredit("Sound", "Nicholas Feinberg");
			addCredit("Music", "Jeremy 'Solatrus' Iamurri", "Nick Smalley On Guitar");
			addCredit("Playtesting", "Alexander 'Droqen' Martin - 'Dropen'",
									 "Ethan 'BIG MAN' Feinberg - 'not even big'",
									 "James 'Bobo' Higgins",
									 "Nik 'goog' Dorff - 'ugggggh'",
									 "'Tridgor'",
									 "Renaud 'Roi Des-Monstres' Cormier",
									 "Nathaniel 'Medi' Rook",
									 "Michael 'Chrono' Bennett",
									 "James 'Walliard' Falcounbridge");
			var lastCol:TitledColumn = creditGruppen.members[creditGruppen.members.length - 1];
			lastCol.setWidth(FlxG.width);
			
			creditGruppen.height = colY + colHeight;
			maxScroll = 0;
			minScroll = (FlxG.height - creditGruppen.height) + maxScroll;
			
			//var t:FlxText = new FlxText(0, FlxG.height - 25, FlxG.width, "Press ENTER to go back to the menu.");
			//t.setFormat(C.FONT, 12, 0xffffff, 'center');
			//add(t);
		}
		
		private var colIndex:int;
		private var colY:int;
		private var colHeight:int;
		private function addCredit(Title:String, ...people):void {
			var X:int = !(colIndex % 2) ? FlxG.width / 4 : FlxG.width * 3 / 4;
			var Y:int = colY;
			
			var titledCol:TitledColumn = new TitledColumn(X, Y, Title);
			for each (var person:String in people)
				titledCol.addCol(person);
			creditGruppen.add(titledCol);
			
			colIndex ++;
			colHeight = Math.max(colHeight, titledCol.height);
			if (!(colIndex % 2)) {
				colY += colHeight + 25;
				colHeight = 0;
			}
		}
		
		
		
		
		override public function update():void {
			super.update();
			if (!FlxG.fade.exists && !FlxG.flash.exists) {
				checkScroll();
				if (ControlSet.CANCEL_KEY.justPressed() || ControlSet.CONFIRM_KEY.justPressed() || FlxG.mouse.justPressed()) {
					C.playBackNoise();
					fadeTo(MenuState);
				}
			}
		}
		
		private var maxScroll:int, minScroll:int;
		private function checkScroll():void {
			if (FlxG.mouse.y < FlxG.height / 3)
				scrollUp(FlxG.elapsed * SCROLL_SPEED);
			else if (FlxG.mouse.y > FlxG.height * 2 / 3)
				scrollDown(FlxG.elapsed * SCROLL_SPEED);
		}
		
		private function scrollDown(amount:Number):void {
			scrollTo(Math.max(minScroll, creditGruppen.y - amount));
		}
		
		private function scrollUp(amount:Number):void {
			scrollTo(Math.min(maxScroll, creditGruppen.y + amount));
		}
		
		private function scrollTo(newY:Number):void {
			var dy:Number = newY - creditGruppen.y;
			
			if (!dy) return;
			
			for each (var credit:TitledColumn in creditGruppen.members)
				credit.scroll(dy/2);
			creditGruppen.y += dy;
		}
		
		private const SCROLL_SPEED:Number = 250;
	}

}