package handlers;

#if SCRIPTS_ENABLED
import scriptStuff.HiScript;
#else
import flixel.system.FlxSound;
import flixel.FlxG;
import flixel.util.FlxTimer;
import flixel.addons.effects.FlxTrail;
#end
import flixel.FlxBasic;
import flixel.FlxSprite;
import states.mainstates.PlayState;
import flixel.group.FlxGroup;

typedef StageCamOffsets = {
	var bfCamX:Float;
	var bfCamY:Float;
	var gfCamX:Float;
	var gfCamY:Float;
	var dadCamX:Float;
	var dadCamY:Float;
}

class Stage extends FlxTypedGroup<FlxBasic> {
    var curStage:String;
	public var offsets:StageCamOffsets = {
		bfCamX: 0,
		bfCamY: 0,
		gfCamX: 0,
		gfCamY: 0,
		dadCamX: 0,
		dadCamY: 0,
	}
    #if SCRIPTS_ENABLED
    public var script:HiScript;
    #else
    var psInstance:PlayState;

	var halloweenBG:FlxSprite;
    var halloweenLevel:Bool = false;
	var isHalloween:Bool = false;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var danced:Bool = true;
	var limo:FlxSprite;
	var grpLimoDancers:Array<FlxSprite> = [];
	var fastCar:FlxSprite;

	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;

	var bgGirls:FlxSprite;

	var tankBop1:FlxSprite;
	var tankBop2:FlxSprite;
	var tankBop3:FlxSprite;
	var tankBop4:FlxSprite;
	var tankBop5:FlxSprite;
	var tankBop6:FlxSprite;
	var smokeRight:FlxSprite;
	var smokeLeft:FlxSprite;
	var tower:FlxSprite;
	var steve:FlxSprite;
    #end

    public function new(stageName:String, psInstance:PlayState) {
        super(0);
        curStage = stageName;

        #if SCRIPTS_ENABLED
        script = new HiScript('assets/stages/$stageName');
        if (!script.isBlank && script.expr != null) {
            script.interp.scriptObject = psInstance;
            script.setValue("add", add);
			script.setValue("camOffsets", offsets);
            script.interp.execute(script.expr);
        } else {
            script.setValue("create", function() {
				psInstance.defaultCamZoom = 0.9;

				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Files.image('stageback'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);
	
				var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Files.image('stagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				add(stageFront);
	
				var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Files.image('stagecurtains'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = true;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;
	
				add(stageCurtains);
            });
        }
        script.callFunction("create");
		var addGF:Null<Bool> = script.getValue("addGF");
		if (addGF == null || addGF != false)
			add(psInstance.gf);
		var addDad:Null<Bool> = script.getValue("addDad");
		if (addDad == null || addDad != false)
			add(psInstance.dad);
		var addBF:Null<Bool> = script.getValue("addBF");
		if (addBF == null || addBF != false)
			add(psInstance.boyfriend);
        #else
        this.psInstance = psInstance;
        switch (stageName) {
			case 'spooky':
				halloweenLevel = true;
	
				var hallowTex = Files.sparrowAtlas('halloween_bg');
				//var hallowTex = FlxAtlasFrames.fromSparrow('assets/images/halloween_bg.png', 'assets/images/halloween_bg.xml');
	
				halloweenBG = new FlxSprite(-200, -100);
				halloweenBG.frames = hallowTex;
				halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
				halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
				halloweenBG.animation.play('idle');
				halloweenBG.antialiasing = true;
				add(halloweenBG);
	
				isHalloween = true;
			case 'philly':
				var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Files.image('philly/sky'));
				bg.scrollFactor.set(0.1, 0.1);
				add(bg);
	
				var city:FlxSprite = new FlxSprite(-10).loadGraphic(Files.image('philly/city'));
				city.scrollFactor.set(0.3, 0.3);
				city.setGraphicSize(Std.int(city.width * 0.85));
				city.updateHitbox();
				add(city);
	
				phillyCityLights = new FlxTypedGroup<FlxSprite>();
				add(phillyCityLights);
	
				for (i in 0...5)
				{
					var light:FlxSprite = new FlxSprite(city.x).loadGraphic((Files.image('philly/win$i')));
					light.scrollFactor.set(0.3, 0.3);
					light.visible = false;
					light.setGraphicSize(Std.int(light.width * 0.85));
					light.updateHitbox();
					light.antialiasing = true;
					phillyCityLights.add(light);
				}
	
				var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Files.image('philly/behindTrain'));
				add(streetBehind);
	
				phillyTrain = new FlxSprite(2000, 360).loadGraphic(Files.image('philly/train'));
				add(phillyTrain);
	
				trainSound = new FlxSound().loadEmbedded(Files.sound('train_passes'));
				FlxG.sound.list.add(trainSound);
	
				// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);
	
				var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Files.image('philly/street'));
				add(street);
			case 'limo':
				psInstance.defaultCamZoom = 0.90;

				var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic('assets/images/limo/limoSunset.png');
				skyBG.scrollFactor.set(0.1, 0.1);
				add(skyBG);

				var bgLimo:FlxSprite = new FlxSprite(-200, 480);
				bgLimo.frames = Files.sparrowAtlas('limo/bgLimo');
				// bgLimo.frames = FlxAtlasFrames.fromSparrow('assets/images/limo/bgLimo.png', 'assets/images/limo/bgLimo.xml');
				bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
				bgLimo.animation.play('drive');
				bgLimo.scrollFactor.set(0.4, 0.4);
				add(bgLimo);

				for (i in 0...5)
				{
					var dancer:FlxSprite = new FlxSprite((370 * i) + 130, bgLimo.y - 400);
					dancer.frames = Files.sparrowAtlas('limo/limoDancer');
					dancer.animation.addByIndices('danceLeft', 'bg dancer sketch PINK', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
					dancer.animation.addByIndices('danceRight', 'bg dancer sketch PINK', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
					dancer.animation.play("danceLeft");
					dancer.scrollFactor.set(0.4, 0.4);
					add(dancer);
					grpLimoDancers.push(dancer);
				}

				var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic('assets/images/limo/limoOverlay.png');
				overlayShit.alpha = 0.5;

				var limoTex = Files.sparrowAtlas('limo/limoDrive');
				// var limoTex = FlxAtlasFrames.fromSparrow('assets/images/limo/limoDrive.png', 'assets/images/limo/limoDrive.xml');

				limo = new FlxSprite(-120, 550);
				limo.frames = limoTex;
				limo.animation.addByPrefix('drive', "Limo stage", 24);
				limo.animation.play('drive');
				limo.antialiasing = true;

				fastCar = new FlxSprite(-300, 160).loadGraphic('assets/images/limo/fastCarLol.png');
				// add(limo);
			case 'mall':
				psInstance.defaultCamZoom = 0.80;
	
				var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic('assets/images/christmas/bgWalls.png');
				bg.antialiasing = true;
				bg.scrollFactor.set(0.2, 0.2);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);
	
				upperBoppers = new FlxSprite(-240, -90);
				upperBoppers.frames = Files.sparrowAtlas('christmas/upperBop');
				//upperBoppers.frames = FlxAtlasFrames.fromSparrow('assets/images/christmas/upperBop.png', 'assets/images/christmas/upperBop.xml');
				upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
				upperBoppers.antialiasing = true;
				upperBoppers.scrollFactor.set(0.33, 0.33);
				upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
				upperBoppers.updateHitbox();
				add(upperBoppers);
	
				var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic('assets/images/christmas/bgEscalator.png');
				bgEscalator.antialiasing = true;
				bgEscalator.scrollFactor.set(0.3, 0.3);
				bgEscalator.active = false;
				bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
				bgEscalator.updateHitbox();
				add(bgEscalator);
	
				var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic('assets/images/christmas/christmasTree.png');
				tree.antialiasing = true;
				tree.scrollFactor.set(0.40, 0.40);
				add(tree);
	
				bottomBoppers = new FlxSprite(-300, 140);
				bottomBoppers.frames = Files.sparrowAtlas('christmas/bottomBop');
				//bottomBoppers.frames = FlxAtlasFrames.fromSparrow('assets/images/christmas/bottomBop.png', 'assets/images/christmas/bottomBop.xml');
				bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
				bottomBoppers.antialiasing = true;
				bottomBoppers.scrollFactor.set(0.9, 0.9);
				bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
				bottomBoppers.updateHitbox();
				add(bottomBoppers);
	
				var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic('assets/images/christmas/fgSnow.png');
				fgSnow.active = false;
				fgSnow.antialiasing = true;
				add(fgSnow);
	
				santa = new FlxSprite(-840, 150);
				santa.frames = Files.sparrowAtlas('christmas/santa');
				//santa.frames = FlxAtlasFrames.fromSparrow('assets/images/christmas/santa.png', 'assets/images/christmas/santa.xml');
				santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
				santa.antialiasing = true;
				add(santa);
			case 'mallEvil':
				var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic('assets/images/christmas/evilBG.png');
				bg.antialiasing = true;
				bg.scrollFactor.set(0.2, 0.2);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);
	
				var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic('assets/images/christmas/evilTree.png');
				evilTree.antialiasing = true;
				evilTree.scrollFactor.set(0.2, 0.2);
				add(evilTree);
	
				var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic("assets/images/christmas/evilSnow.png");
				evilSnow.antialiasing = true;
				add(evilSnow);
			case 'school':
				psInstance.defaultCamZoom = 1;
	
				var bgSky = new FlxSprite().loadGraphic('assets/images/weeb/weebSky.png');
				bgSky.scrollFactor.set(0.1, 0.1);
				add(bgSky);
	
				var repositionShit = -200;
	
				var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic('assets/images/weeb/weebSchool.png');
				bgSchool.scrollFactor.set(0.6, 0.90);
				add(bgSchool);
	
				var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic('assets/images/weeb/weebStreet.png');
				bgStreet.scrollFactor.set(0.95, 0.95);
				add(bgStreet);
	
				var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic('assets/images/weeb/weebTreesBack.png');
				fgTrees.scrollFactor.set(0.9, 0.9);
				add(fgTrees);
	
				var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
				bgTrees.frames = Files.packerAtlas('weeb/weebTrees');
				bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
				bgTrees.animation.play('treeLoop');
				bgTrees.scrollFactor.set(0.85, 0.85);
				add(bgTrees);
	
				var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
				treeLeaves.frames = Files.sparrowAtlas('weeb/petals');
				treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
				treeLeaves.animation.play('leaves');
				treeLeaves.scrollFactor.set(0.85, 0.85);
				add(treeLeaves);
	
				var widShit = Std.int(bgSky.width * 6);
	
				bgSky.setGraphicSize(widShit);
				bgSchool.setGraphicSize(widShit);
				bgStreet.setGraphicSize(widShit);
				bgTrees.setGraphicSize(Std.int(widShit * 1.4));
				fgTrees.setGraphicSize(Std.int(widShit * 0.8));
				treeLeaves.setGraphicSize(widShit);
	
				fgTrees.updateHitbox();
				bgSky.updateHitbox();
				bgSchool.updateHitbox();
				bgStreet.updateHitbox();
				bgTrees.updateHitbox();
				treeLeaves.updateHitbox();
	
				bgGirls = new FlxSprite(-100, 190);
				bgGirls.frames = Files.sparrowAtlas('weeb/bgFreaks');
				var danceAnim = (PlayState.SONG.song.toLowerCase() == 'roses') ? "BG fangirls dissuaded" : "BG girls group";
				bgGirls.animation.addByIndices('danceLeft', danceAnim, CoolUtil.numberArray(14), "", 24, false);
				bgGirls.animation.addByIndices('danceRight', danceAnim, CoolUtil.numberArray(30, 15), "", 24, false);
				bgGirls.animation.play('danceLeft');
				bgGirls.scrollFactor.set(0.9, 0.9);
				bgGirls.setGraphicSize(Std.int(bgGirls.width * 6));
				bgGirls.updateHitbox();
				add(bgGirls);
			case 'schoolEvil':
				psInstance.defaultCamZoom = 1;
				var bg:FlxSprite = new FlxSprite(400, 200);
				bg.frames = Files.sparrowAtlas('weeb/animatedEvilSchool');
				//bg.frames = FlxAtlasFrames.fromSparrow('assets/images/weeb/animatedEvilSchool.png', 'assets/images/weeb/animatedEvilSchool.xml');
				bg.animation.addByPrefix('idle', 'background 2', 24);
				bg.animation.play('idle');
				bg.scrollFactor.set(0.8, 0.9);
				bg.scale.set(6, 6);
				add(bg);
			case 'tank':
				psInstance.defaultCamZoom = 0.9;
	
				var sky:FlxSprite = new FlxSprite(-400, -400).loadGraphic('assets/images/tank/tankSky.png');
				sky.scrollFactor.set(0, 0);
				sky.antialiasing = true;
				sky.setGraphicSize(Std.int(sky.width * 1.5));
				sky.active = false;
				add(sky);
	
				var mountain:FlxSprite = new FlxSprite(-300, -20).loadGraphic('assets/images/tank/tankMountains.png');
				mountain.scrollFactor.set(0.2, 0.2);
				mountain.setGraphicSize(Std.int(1.2 * mountain.width));
				mountain.updateHitbox();
				mountain.antialiasing = true;
				add(mountain);
	
				var buildings:FlxSprite = new FlxSprite(-200, 0).loadGraphic('assets/images/tank/tankBuildings.png');
				buildings.scrollFactor.set(0.3, 0.3);
				buildings.setGraphicSize(Std.int(buildings.width * 1.1));
				buildings.updateHitbox();
				buildings.antialiasing = true;
				add(buildings);
	
				steve = new FlxSprite(-420, -150);
				steve.frames = Files.sparrowAtlas('tank/tankRolling');
				//steve.frames = FlxAtlasFrames.fromSparrow('assets/images/tank/tankRolling.png', 'assets/images/tank/tankRolling.xml');
				steve.animation.addByPrefix('rollin', 'BG tank w lighting instance 1', 24, true);
				steve.animation.play('rollin');
				steve.setGraphicSize(Std.int(steve.width * 1.15));
				steve.updateHitbox();
				makedatakroil();
				add(steve);
	
				var smokeLeft:FlxSprite = new FlxSprite(-200, -100);
				smokeLeft.frames = Files.sparrowAtlas('tank/smokeLeft');
				//smokeLeft.frames = FlxAtlasFrames.fromSparrow('assets/images/tank/smokeLeft.png', 'assets/images/tank/smokeLeft.xml');
				smokeLeft.animation.addByPrefix('idle', 'SmokeBlurLeft ', 24, true);
				smokeLeft.scrollFactor.set(0.4, 0.4);
				smokeLeft.antialiasing = true;
				smokeLeft.animation.play('idle');
				add(smokeLeft);
	
				var smokeRight:FlxSprite = new FlxSprite(1100, -100);
				smokeRight.frames = Files.sparrowAtlas('tank/smokeRight');
				//smokeRight.frames = FlxAtlasFrames.fromSparrow('assets/images/tank/smokeRight.png', 'assets/images/tank/smokeRight.xml');
				smokeRight.animation.addByPrefix('idle', 'SmokeRight ', 24, true);
				smokeRight.scrollFactor.set(0.4, 0.4);
				smokeRight.antialiasing = true;
				smokeRight.animation.play('idle');
				add(smokeRight);
	
				tower = new FlxSprite(100, 120);
				tower.frames = Files.sparrowAtlas('tank/tankWatchtower');
				//tower.frames = FlxAtlasFrames.fromSparrow('assets/images/tank/tankWatchtower.png', 'assets/images/tank/tankWatchtower.xml');
				tower.animation.addByPrefix('idle', 'watchtower gradient color instance 1', 24, false);
				tower.antialiasing = true;
				add(tower);
	
				var ground:FlxSprite = new FlxSprite(-420, -150).loadGraphic('assets/images/tank/tankGround.png');
				ground.setGraphicSize(Std.int(ground.width * 1.1));
				ground.updateHitbox();
				ground.antialiasing = true;
				ground.scrollFactor.set(0.9, 0.9);
				ground.active = false;
				add(ground);
	
				tankBop1 = new FlxSprite(-500, 650);
				tankBop1.frames = Files.sparrowAtlas('tank/tank0');
				//tankBop1.frames = FlxAtlasFrames.fromSparrow('assets/images/tank/tank0.png', 'assets/images/tank/tank0.xml');
				tankBop1.animation.addByPrefix('bop', 'fg tankhead far right', 24);
				tankBop1.scrollFactor.set(1.7, 1.5);
				tankBop1.antialiasing = true;
				add(tankBop1);
	
				tankBop2 = new FlxSprite(-300, 750);
				tankBop2.frames = Files.sparrowAtlas('tank/tank1');
				//tankBop2.frames = FlxAtlasFrames.fromSparrow('assets/images/tank/tank1.png', 'assets/images/tank/tank1.xml');
				tankBop2.animation.addByPrefix('bop', 'fg tankhead 5', 24);
				tankBop2.scrollFactor.set(2.0, 0.2);
				tankBop2.antialiasing = true;
				add(tankBop2);
	
				tankBop3 = new FlxSprite(450, 940);
				tankBop3.frames = Files.sparrowAtlas('tank/tank2');
				//tankBop3.frames = FlxAtlasFrames.fromSparrow('assets/images/tank/tank2.png', 'assets/images/tank/tank2.xml');
				tankBop3.animation.addByPrefix('bop', 'foreground man 3', 24);
				tankBop3.scrollFactor.set(1.5, 1.5);
				tankBop3.antialiasing = true;
				add(tankBop3);
	
				tankBop4 = new FlxSprite(1300, 1200);
				tankBop4.frames = Files.sparrowAtlas('tank/tank3');
				//tankBop4.frames = FlxAtlasFrames.fromSparrow('assets/images/tank/tank3.png', 'assets/images/tank/tank3.xml');
				tankBop4.animation.addByPrefix('bop', 'fg tankhead 4', 24);
				tankBop4.scrollFactor.set(3.5, 2.5);
				tankBop4.antialiasing = true;
				add(tankBop4);
	
				tankBop5 = new FlxSprite(1300, 900);
				tankBop5.frames = Files.sparrowAtlas('tank/tank4');
				//tankBop5.frames = FlxAtlasFrames.fromSparrow('assets/images/tank/tank4.png', 'assets/images/tank/tank4.xml');
				tankBop5.animation.addByPrefix('bop', 'fg tankman bobbin 3', 24);
				tankBop5.scrollFactor.set(1.5, 1.5);
				tankBop5.antialiasing = true;
				add(tankBop5);
	
				tankBop6 = new FlxSprite(1620, 700);
				tankBop6.frames = Files.sparrowAtlas('tank/tank5');
				//tankBop6.frames = FlxAtlasFrames.fromSparrow('assets/images/tank/tank5.png', 'assets/images/tank/tank5.xml');
				tankBop6.animation.addByPrefix('bop', 'fg tankhead far right', 24);
				tankBop6.scrollFactor.set(1.5, 1.5);
				tankBop6.antialiasing = true;
				add(tankBop6);
			default:
				psInstance.defaultCamZoom = 0.9;

				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Files.image('stageback'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);
	
				var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Files.image('stagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				add(stageFront);
	
				var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Files.image('stagecurtains'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = true;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;
	
				add(stageCurtains);
		}

        // REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'limo':
				psInstance.boyfriend.regY -= 220;
				psInstance.boyfriend.regX += 260;

				offsets.bfCamX = -200;

				resetFastCar();
				add(fastCar);

			case 'mall':
				psInstance.boyfriend.regX += 200;
				offsets.bfCamY = -100;

			case 'mallEvil':
				psInstance.boyfriend.regX += 320;
				psInstance.dad.regY -= 80;
			case 'school':
				psInstance.boyfriend.regX += 200;
				psInstance.boyfriend.regY += 220;
				psInstance.gf.regX += 180;
				psInstance.gf.regY += 300;

				offsets.bfCamX = -100;
				offsets.bfCamY = -100;
			case 'schoolEvil':
				// trailArea.scrollFactor.set();

				var evilTrail = new FlxTrail(psInstance.dad, null, 4, 24, 0.3, 0.069);
				// evilTrail.changeValuesEnabled(false, false, false, false);
				// evilTrail.changeGraphic()
				add(evilTrail);
				// evilTrail.scrollFactor.set(1.1, 1.1);

				psInstance.boyfriend.regX += 200;
				psInstance.boyfriend.regY += 220;
				psInstance.gf.regX += 180;
				psInstance.gf.regY += 300;

				offsets.bfCamX = -100;
				offsets.bfCamY = -100;
		}

		add(psInstance.gf);

		// Shitty layering but whatev it works LOL
		if (curStage == 'limo')
			add(limo);

		add(psInstance.dad);
		add(psInstance.boyfriend);
        #end
    }

    public function callFromScript(name:String, ?params:Array<Dynamic>)
        #if (SCRIPTS_ENABLED) script.callFunction(name, params); #else return null; #end

    override public function update(elapsed:Float) {
        super.update(elapsed);
        callFromScript("update", [elapsed]);

        #if !SCRIPTS_ENABLED
		if (curStage == 'tank')
			makedatakroil();

        if (curStage != "philly") return;
        if (trainMoving)
            {
                trainFrameTiming += elapsed;

                if (trainFrameTiming >= 1 / 24)
                {
                    updateTrainPos();
                    trainFrameTiming = 0;
                }
            }
        #end
    }

    public function stepHit(curStep:Int)
        callFromScript("stepHit");

    public function beatHit(curBeat:Int) {
        callFromScript("beatHit");
        #if !SCRIPTS_ENABLED
		switch (curStage)
		{
			case 'school':
				danced = !danced;
				bgGirls.animation.play(danced ? "danceLeft" : "danceRight");

			case 'mall':
				upperBoppers.animation.play('bop', true);
				bottomBoppers.animation.play('bop', true);
				santa.animation.play('idle', true);

			case 'limo':
				danced = !danced;
				for (dancer in grpLimoDancers)
					dancer.animation.play(danced ? "danceLeft" : "danceRight");

				if (FlxG.random.bool(10) && fastCarCanDrive)
					fastCarDrive();
			case "philly":
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
					// phillyCityLights.members[curLight].alpha = 1;
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}

			case "tank":
				tower.animation.play('idle', true);
				tankBop1.animation.play('bop', true);
				tankBop2.animation.play('bop', true);
				tankBop3.animation.play('bop', true);
				tankBop4.animation.play('bop', true);
				tankBop5.animation.play('bop', true);
				tankBop6.animation.play('bop', true);
		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			lightningStrikeShit(curBeat);
		}
        #end
    }

    #if !SCRIPTS_ENABLED
	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	function lightningStrikeShit(curBeat:Int):Void {
        FlxG.sound.play(Files.sound('thunder_${FlxG.random.int(1, 2)}'));
        halloweenBG.animation.play('lightning');
    
        lightningStrikeBeat = curBeat;
        lightningOffset = FlxG.random.int(8, 24);
    
        psInstance.event('play anim', 'bf', 'scared');
        psInstance.event('play anim', 'gf', 'scared');
	}

    var curLight:Int = 0;

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

    var startedMoving:Bool = false;

	function updateTrainPos():Void {
		if (trainSound.time >= 4700) {
            if (!startedMoving)
                psInstance.event('play anim', 'gf', 'hairBlow');
			startedMoving = true;
		}

		if (startedMoving) {
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function trainStart():Void {
        trainMoving = true;
        if (!trainSound.playing)
            trainSound.play(true);
    }

	function trainReset():Void {
		psInstance.event('play anim', 'gf', 'hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	function fastCarDrive()
	{
		FlxG.sound.play(Files.randomSound(0, 1, 'carPass'), 0.7);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
		});
	}

	function makedatakroil() {
		var tankResetShit:Bool = false;
		var tankMoving:Bool = false;
		var tankAngle:Float = FlxG.random.int(-90, 45);
		var tankSpeed:Float = FlxG.random.float(5, 7);
		var tankX:Float = 400;

		tankAngle += tankSpeed * FlxG.elapsed;
		steve.angle = (tankAngle - 90 + 15);
		steve.x = tankX + 1500 * Math.cos(Math.PI / 180 * (1 * tankAngle + 180));
		steve.y = 1300 + 1100 * Math.sin(Math.PI / 180 * (1 * tankAngle + 180));
	}
    #end
}