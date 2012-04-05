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
		override public function create():void {
			super.create();
			loadBackground(BG, 0.65);
			
			var title:FlxText = new FlxText(0, 15, FlxG.width, "Credits");
			title.setFormat(C.TITLEFONT, 48, 0xffffff, 'center');
			
			add(creditGruppen = new FlxGroup);
			add(titleBar = new FlxSprite().createGraphic(FlxG.width, title.y + title.height + 20, 0xff000000));
			add(title);
			colY = titleBar.y + titleBar.height + 9; //90
			background.y = colY;
			
			addCredit("Design", "Nicholas Feinberg");
			addCredit("Programming", "Nicholas Feinberg");
			addCredit("Art Lead", "Jackson Potter 'Jr.'");
			addCredit("Additional Art", "Nicholas Feinberg");
			addCredit("Sound", "Nicholas Feinberg", "w/ Stephen Lavelle's bfxr", "www.soundrangers.com");
			addCredit("Music", "Jeremy Iamurri (Solatrus)", "Nick Smalley (OMGTSN)");
			colIsWide = true;
			addCredit("Playtesting", "Alexander 'Droqen' Martin - 'Dropen'",
									 "Ethan 'BIG MAN' Feinberg - 'not even big'",
									 "James 'Bobo' Higgins",
									 "Nik 'goog' Dorff - 'ugggggh'",
									 "Nataniel 'tridgor' Butt",
									 "Renaud 'Roi Des-Monstres' Cormier",
									 "Nathaniel 'Medi' Rook",
									 "Michael 'Chrono' Bennett",
									 "James 'Walliard' Falcounbridge",
									 "Jeffrey 'Jiefu' McGannigan",
									 "James 'Nagilfar' Draskovic",
									 "'Kiwi'",
									 "The TIGSource Feedback forum");
			colIsWide = true;
			addCredit("Additional Thanks");
			addCredit("Fonts", "Tino Meinert - CPMono", "Anna Anthropy - Crypt of Tomorrow");
			addCredit("Backgrounds", "NASA's Astronomy Picture of the Day");
			
			creditGruppen.height = colY + colHeight - COL_SPACE/2;
			maxScroll = 0;
			minScroll = (FlxG.height - creditGruppen.height) + maxScroll;
			
			var scrollText:FlxText = new FlxText(5, 35, 115, "Use arrow keys to scroll.");
			scrollText.setFormat(C.FONT, 12);
			add(scrollText);
			
			var returnText:FlxText = new FlxText(FlxG.width - 120, 35, 115, ControlSet.CONFIRM_KEY+" or click to return.");
			returnText.setFormat(C.FONT, 12, 0xffffff, 'right');
			add(returnText);
		}
		
		private var colIndex:int;
		private var colY:int;
		private var colHeight:int;
		private var colIsWide:Boolean;
		private function addCredit(Title:String, ...people):void {
			var X:int = !(colIndex % 2) ? FlxG.width / 4 : FlxG.width * 3 / 4;
			var Y:int = colY;
			
			var titledCol:TitledColumn = new TitledColumn(X, Y, Title);
			for each (var person:String in people)
				titledCol.addCol(person);
			creditGruppen.add(titledCol);
			
			if (colIsWide) {
				titledCol.setWidth(FlxG.width);
				colIndex++;
				colIsWide = false;
			}
			
			colIndex ++;
			colHeight = Math.max(colHeight, titledCol.height);
			if (!(colIndex % 2)) {
				colY += colHeight + COL_SPACE;
				colHeight = 0;
			}
		}
		
		
		
		
		override public function update():void {
			super.update();
			if (!FlxG.fade.exists && !FlxG.flash.exists) {
				checkScroll();
				if (ControlSet.CANCEL_KEY.justPressed() || ControlSet.CONFIRM_KEY.justPressed() || FlxG.mouse.justPressed())
					fadeBackTo(MenuState);
			}
		}
		
		private var maxScroll:int, minScroll:int;
		private function checkScroll():void {
			if (FlxG.keys.pressed("UP"))
				scrollUp(FlxG.elapsed * SCROLL_SPEED);
			else if (FlxG.keys.pressed("DOWN"))
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
				credit.scroll(dy);
			creditGruppen.y += dy;
		}
		
		private const SCROLL_SPEED:Number = 200;
		private const COL_SPACE:int = 25;
		
		[Embed(source = "../../lib/art/backgrounds/menu/menu_bg_x3s.jpg")] private const BG:Class;
	}

}