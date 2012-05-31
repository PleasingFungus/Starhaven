package Scenarios.Tutorials {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import Mining.BaseAsteroid;
	import Mining.MineralBlock;
	import Mining.Terrain;
	import Missions.LoadedMission;
	import org.flixel.data.FlxPanel;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	import Meteoroids.PlanetSpawner;
	import org.flixel.FlxG;
	import Scenarios.DefaultScenario;
	import GrabBags.BagType;
	import Scenarios.PlanetScenario;
	import Sminos.LongConduit;
	import Sminos.LongDrill;
	import Sminos.Conduit;
	import InfoScreens.NewPlayerEvent;
	import Mining.PlanetMaterial;
	import Globals.GlobalCycleTimer;
	/**
	 * ...
	 * @author Nicholas "PleasingFungus" Feinberg
	 */
	public class MiningTutorial extends PlanetScenario {
		
		public function MiningTutorial() {
			super(NaN);
			
			goalMultiplier = 0.5;
			buildMusic = C.music.TUT_MUSIC;
		}
		
		override public function create():void {
			C.IN_TUTORIAL = true;
			super.create();
			
			hud.goalName = "Collected";
			hud.updateGoal(0);
		}
		
		override protected function createTracker(_:Number = 0):void {
			super.createTracker(0);
		}
		
		override protected function createGCT(_:int):void {
			super.createGCT(0);
		}
		
		override protected function createMission():void {
			mission = new LoadedMission(_mission_image);
		}
	
		override protected function setupBags():void {
			bagType = new BagType([LongDrill, Conduit, Conduit]);
			C.difficulty.bagSize = bagType.length;
		}
		
		override protected function buildLevel():void {
			var planet:PlanetMaterial = new PlanetMaterial( -10, 0, mission.rawMap.map, mission.rawMap.center);
			station.core.center.x += 1;
			station.core.center.y -= 4;
			
			Mino.resetGrid();
			station.core.addToGrid();
			
			station.resourceSource = planet;
			initialMinerals = station.mineralsAvailable;
			
			var planet_bg:Mino = new Mino(planet.gridLoc.x, planet.gridLoc.y, mission.rawMap.map, mission.rawMap.center, 0xff23170f);
			
			minoLayer.add(planet_bg);
			minoLayer.add(planet);
			station.add(planet);
			Mino.all_minos.push(planet);
			planet.addToGrid();
			
			addGhostSminos();
		}
		
		
		
		
		/*private var seenIntro:Boolean;
		override protected function checkPlayerEvents():void {
			super.checkPlayerEvents();
			if (!seenIntro) {
				hudLayer.add(NewPlayerEvent.miningTutorial());
				seenIntro = true;
			}
		}*/
		
		override protected function get goalPercent():int {
			return station.mineralsMined * 100 / (initialMinerals * goalMultiplier);
		}
		
		override protected function checkEndConditions():void {
			super.checkEndConditions();
			if (!missionOver && insufficientMineralsRemain())
				beginEndgame();
		}
		
		protected function insufficientMineralsRemain():Boolean {
			var inField:int = station.mineralsAvailable;
			var mined:int = 0;
			for each (var mino:Mino in Mino.all_minos)
				if (mino.exists)
					mined += mino.storedMinerals;
			var goalMin:int = initialMinerals * goalMultiplier;
			return inField + mined < goalMin;
		}
		
		override protected function getEndText():String {
			if (won() || station.core.damaged)
				return super.getEndText();
			return "Insufficient minerals remain!";
		}
		
		override protected function shouldZoomOut():Boolean
		{
			return true;
		}
		
		override protected function getMinoChoice():Class
		{
			if (GlobalCycleTimer.minosDropped < 1)
			{
				return LongDrill;
			}
			else if (GlobalCycleTimer.minosDropped == 1)
			{
				return LongConduit;
			}
			else
			{
				return super.getMinoChoice();
			}
		}
		
		/************************************
		 * 		  ghost smino code			*
		 ***********************************/
		
		protected var ghostSminos:Vector.<Smino>;
		protected var currentGhostSmino:Smino;
		protected var currentGhostSminoDestination:FlxPoint;
		protected var increasingAlpha:Boolean;
		protected const GHOST_MAX_ALPHA:Number = .7;
		protected const GHOST_MIN_ALPHA:Number = 0;
		protected const GHOST_PULSE_TIME:Number = .6;
		protected const GHOST_MOVE_TIME:Number = 1.5;
		protected var ghostSminoSpawn:FlxPoint;
		protected const GHOST_SMINO_DESTINATIONS:Vector.<FlxPoint> = new Vector.<FlxPoint>;
		//[Embed(source = "../../../lib/art/sminos/drillglow.png")] protected const drillGlowImage:Class;
		protected var ghostMovementFinished:Boolean;
		
		protected function addGhostSminos():void
		{
			ghostSminos = new Vector.<Smino>;
			ghostSminoSpawn = new FlxPoint(0, C.B.PlayArea.top - 20);
			ghostSminos.push(new LongDrill(ghostSminoSpawn.x, ghostSminoSpawn.y), new LongConduit(ghostSminoSpawn.x, ghostSminoSpawn.y));
			GHOST_SMINO_DESTINATIONS.push(new FlxPoint(-6, 5), new FlxPoint(-5, 4));
			for each (var ghostSmino:Smino in ghostSminos)
			{
				Mino.layer.add(ghostSmino);
				Mino.all_minos.push(ghostSmino);
				ghostSmino.active = false;
				ghostSmino.solid = false;
				ghostSmino.visible = false;
				ghostSmino.alpha = .8;
			}
			ghostSminos[1].rotateClockwise(true);
			
			ghostMovementFinished = false;
		}
		
		override public function update():void
		{
			super.update();
			
			for each (var ghostSmino:Smino in ghostSminos)
				ghostSmino.visible = false;
			
			setCurrentGhostSmino();
			if (currentGhostSmino)
			{
				updateGhostMino();
				if (!ghostMovementFinished)
					disableMino();
			}
			if (currentMino && (ghostMovementFinished || !currentGhostSmino))
			{
				enableMino();
			}
		}
		
		override protected function checkInput():void
		{
			if (ghostMovementFinished || !currentGhostSmino)
				super.checkInput();
		}
		
		protected function disableMino():void
		{
			currentMino.active = false;
			arrowHint.active = arrowHint.visible = false;
		}
		
		protected function enableMino():void
		{
			currentMino.active = true;
			arrowHint.active = arrowHint.visible = true;
		}
		
		/*override protected function checkCurrentMino():void
		{
			var bears:Boolean = ghostMovementFinished;
			if (!bears)
				C.log(bears, currentMino, currentGhostSmino);
			if (ghostMovementFinished || !currentGhostSmino)
			{
				super.checkCurrentMino();
			}
		}*/
		
		/*override protected function spawnNextMino():void
		{
			super.spawnNextMino();
			ghostMovementFinished = false;
		}*/
		
		override protected function popNextMino():Smino
		{
			ghostMovementFinished = false;
			return super.popNextMino();
		}
		
		protected function setCurrentGhostSmino():void
		{
			if (GlobalCycleTimer.minosDropped < 2)
			{
				if (currentMino is LongDrill)
				{
					currentGhostSmino = ghostSminos[0];
					currentGhostSminoDestination = GHOST_SMINO_DESTINATIONS[0];
				}
				else if (currentMino is Conduit)
				{
					currentGhostSmino = ghostSminos[1];
					currentGhostSminoDestination = GHOST_SMINO_DESTINATIONS[1];
				}
				else
				{
					currentGhostSmino = null;
				}
			}
			else
			{
				currentGhostSmino = null;
			}
		}
		
		protected function updateGhostMino():void
		{
			currentGhostSmino.visible = true;
			if (ghostMovementFinished)
				pulseGhostSmino(currentGhostSmino);
			else
				moveGhostSmino();
		}
		
		protected function pulseGhostSmino(smino:Smino):void
		{
			if (increasingAlpha)
			{
				if (smino.alpha < GHOST_MAX_ALPHA)
				{
					smino.alpha += (FlxG.elapsed / GHOST_PULSE_TIME) * (GHOST_MAX_ALPHA - GHOST_MIN_ALPHA);
				}
				else
				{
					increasingAlpha = false;
					smino.alpha = GHOST_MAX_ALPHA;
				}
			}
			else
			{
				if (smino.alpha > GHOST_MIN_ALPHA)
				{
					smino.alpha -= (FlxG.elapsed / GHOST_PULSE_TIME) * (GHOST_MAX_ALPHA - GHOST_MIN_ALPHA);
				}
				else
				{
					increasingAlpha = true;
					smino.alpha = GHOST_MIN_ALPHA;
				}
			}
		}
		
		protected function moveGhostSmino():void
		{
			if (currentGhostSmino.gridLoc.x > currentGhostSminoDestination.x || currentGhostSmino.gridLoc.y < currentGhostSminoDestination.y)
			{
				currentGhostSmino.gridLoc.x -= (FlxG.elapsed / GHOST_MOVE_TIME) * (ghostSminoSpawn.x - currentGhostSminoDestination.x);
				currentGhostSmino.gridLoc.y -= (FlxG.elapsed / GHOST_MOVE_TIME) * (ghostSminoSpawn.y - currentGhostSminoDestination.y);
			}
			else
			{
				currentGhostSmino.gridLoc.x = currentGhostSminoDestination.x;
				currentGhostSmino.gridLoc.y = currentGhostSminoDestination.y;
				ghostMovementFinished = true;
			}
		}
		
		[Embed(source = "../../../lib/missions/tutorial_mining.png")] private static const _mission_image:Class;
	}

}