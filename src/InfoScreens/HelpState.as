package InfoScreens {
	import org.flixel.*;
	import Controls.ControlSet;
	import MainMenu.MenuState;
	import Sminos.Launcher;
	
	/**
	 * ...
	 * @author ...
	 */
	public class HelpState extends FadeState {
		[Embed(source = "../../lib/art/tutorial/core.png")] private static const _core:Class;
		[Embed(source = "../../lib/art/tutorial/conduits.png")] private static const _conduits:Class;
		[Embed(source = "../../lib/art/tutorial/drill.png")] private static const _drill:Class;
		[Embed(source = "../../lib/art/tutorial/launchers.png")] private static const _launchers:Class;
		[Embed(source = "../../lib/art/tutorial/barracks.png")] private static const _barracks:Class;
		[Embed(source = "../../lib/art/tutorial/asteroids.png")] private static const _asteroids:Class;
		private static const PAGES:Array = [_core, _conduits, _drill, _launchers, _barracks, _asteroids];
		
		private var page:int = 0;
		private var justCreated:Boolean = true;
		override public function create():void {
			if (justCreated)
				super.create();
			justCreated = false;
			
			defaultGroup.members = [];
			var bg:FlxSprite = new FlxSprite(0, 0, PAGES[page]);
			add(bg);
			
			switch (page) {
				case 0: 
					var title:FlxText = new FlxText(10, 10, FlxG.width - 20, "Explanation");
					title.setFormat(C.TITLEFONT, 48, 0xffffff, 'center');
					add(title);
					
					var premise:FlxText = new FlxText(10, title.y + 50, FlxG.width - 20, "");
					premise.setFormat(C.BLOCKFONT, 16);
					premise.text += "Starhaven is a game about MINING IN SPACE. Pieces of your MINING RIG fall from above. ";
					premise.text += "Your job is to assemble the pieces to extract as many BLUE-PURPLE MINERALS from the terrain as possible!\n\n\n";
					premise.text += "The core to your station is the CORE - this 5x5 orange block. It powers everything else. ";
					premise.text += "If it's damaged, that's it!";
					add(premise);
					
					break;
				case 1:
					var conduits:FlxText = new FlxText(90, 50, 200, "");
					conduits.setFormat(C.BLOCKFONT, 16);
					conduits.text += "Yellow CONDUITS provide transmit power and supplies throught your rig. "
					conduits.text += "Pretty much everything needs power to work!\n\n"
					conduits.text += "Hook conduits up to the CORE, and they'll power other adjacent modules. "
					conduits.text += "Conduits also power other conduits, so you can chain them as far as you please!";
					add(conduits);
					
					break;
				case 2:
					var drills:FlxText = new FlxText(110, 20, FlxG.width - 110, "");
					drills.setFormat(C.BLOCKFONT, 16);
					drills.text += "Purple DRILLS mine MINERALS from the rock. "
					drills.text += "Stick one pointy-end down, and it'll instantly drill until it can't go any further!";
					drills.text += "Then, it'll extract all the purple MINERALS adjacent to it, as well as the ones it hit going down.\n\n";
					drills.text += "To claim the minerals, just connect the drill to your CONDUIT NETWORK. ";
					drills.text += "This will cause the drill bit to retract, and deliver you all the minerals it mined!";
					add(drills);
					
					break;
				case 3:
					var launchers1:FlxText = new FlxText(120, 20, FlxG.width - 130, "");
					launchers1.setFormat(C.BLOCKFONT, 16);
					launchers1.text += "However, just mining the minerals isn't enough. You also need to launch them back to your (offscreen) HOME BASE! ";
					launchers1.text += "\n\nTo do this, you'll need to use the green LAUNCHERS."
					add(launchers1);
					
					var launchers2:FlxText = new FlxText(220, 330, FlxG.width - 230, "");
					launchers2.setFormat(C.BLOCKFONT, 16);
					launchers2.text += "Like everything else, you need to power launchers. ";
					launchers2.text += "But unlike drills, launchers also need CREW. ";
					launchers2.text += "(See next page!)";
					add(launchers2);
					break;
				
				case 4:
					var barracks:FlxText = new FlxText(10, 20, FlxG.width - 20, "");
					barracks.setFormat(C.BLOCKFONT, 16);
					barracks.text += "Once powered, blue BARRACKS provide crew to adjacent modules. ";
					barracks.text += "And once LAUNCHERS have power and crew, they can hurl your collected minerals back to your HOME BASE!\n\n";
					barracks.text += "Barracks provide one CREW per block, so a 3x2 barracks holds 6 CREW. ";
					barracks.text += "Launchers need one crew per block to operate, and can then launch one rocket per block, holding "+Launcher.LAUNCH_SIZE+" MINERALS apiece. "
					barracks.text += "It's all in the numbers!";
					add(barracks);
					
					var easterEgg:FlxText = new FlxText(1, 407, 30, "Number one: that's terror. Number two: that's terror. Number three? That's terror.");
					easterEgg.setFormat(C.BLOCKFONT, 1);
					add(easterEgg);
					
					break;
				
				case 5:
					var asteroids:FlxText = new FlxText(10, 20, FlxG.width - 20, "");
					asteroids.setFormat(C.BLOCKFONT, 16);
					asteroids.text += "One other type of module needs crew - red DEFENSE BEAMS. ";
					asteroids.text += "If powered and crewed, defense beams will shoot down incoming ASTEROIDS that threaten your rig.\n\n";
					asteroids.text += "Asteroids are extremely dangerous - if you don't have any working defenses, your best bet is to rotate the station so that the bulk of the rock is in the way of the incoming asteroids.\n\n";
					asteroids.text += "Good luck!";
					add(asteroids);
					
					break;
			}
		}
		
		override public function update():void {
			super.update();
			
			if (ControlSet.CANCEL_KEY.justPressed())
				FlxG.state = new MenuState;
			else if (FlxG.keys.justPressed("LEFT")) {
				if (page > 0) {
					page--;
					create();
					FlxG.play(UP_SOUND, 0.25);
				} else {
					C.playBackNoise();
					fadeTo(MenuState);
				}
			} else if (FlxG.keys.justPressed("RIGHT") || FlxG.mouse.justPressed() || FlxG.keys.anyKey()) {
				if (page < PAGES.length - 1) {
					page++;
					create();
					FlxG.play(DOWN_SOUND, 0.25);
				} else {
					C.playBackNoise();
					fadeTo(MenuState);
				}
			}
		}
		
		[Embed(source = "../../lib/sound/menu/down2.mp3")] protected const DOWN_SOUND:Class;
		[Embed(source = "../../lib/sound/menu/down.mp3")] protected const UP_SOUND:Class;
	}

}