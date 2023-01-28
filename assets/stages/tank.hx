import handlers.ClientPrefs;

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

function create() {
    defaultCamZoom = 0.9;
	
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
	// steve.frames = FlxAtlasFrames.fromSparrow('assets/images/tank/tankRolling.png', 'assets/images/tank/tankRolling.xml');
	steve.animation.addByPrefix('rollin', 'BG tank w lighting instance 1', 24, true);
	steve.animation.play('rollin');
	steve.setGraphicSize(Std.int(steve.width * 1.15));
	steve.updateHitbox();

		var tankResetShit:Bool = false;
		var tankMoving:Bool = false;
		var tankAngle:Float = FlxG.random.int(-90, 45);
		var tankSpeed:Float = FlxG.random.float(5, 7);
		var tankX:Float = 400;
	
		tankAngle += tankSpeed * FlxG.elapsed;
		steve.angle = (tankAngle - 90 + 15);
		steve.x = tankX + 1500 * Math.cos(Math.PI / 180 * (1 * tankAngle + 180));
		steve.y = 1300 + 1100 * Math.sin(Math.PI / 180 * (1 * tankAngle + 180));
		
	add(steve);

	if (ClientPrefs.quality != 'Low') {
		var smokeLeft:FlxSprite = new FlxSprite(-200, -100);
		smokeLeft.frames = Files.sparrowAtlas('tank/smokeLeft');
		// smokeLeft.frames = FlxAtlasFrames.fromSparrow('assets/images/tank/smokeLeft.png', 'assets/images/tank/smokeLeft.xml');
		smokeLeft.animation.addByPrefix('idle', 'SmokeBlurLeft ', 24, true);
		smokeLeft.scrollFactor.set(0.4, 0.4);
		smokeLeft.antialiasing = true;
		smokeLeft.animation.play('idle');
		add(smokeLeft);

		var smokeRight:FlxSprite = new FlxSprite(1100, -100);
		smokeRight.frames = Files.sparrowAtlas('tank/smokeRight');
		// smokeRight.frames = FlxAtlasFrames.fromSparrow('assets/images/tank/smokeRight.png', 'assets/images/tank/smokeRight.xml');
		smokeRight.animation.addByPrefix('idle', 'SmokeRight ', 24, true);
		smokeRight.scrollFactor.set(0.4, 0.4);
		smokeRight.antialiasing = true;
		smokeRight.animation.play('idle');
		add(smokeRight);
	}

	tower = new FlxSprite(100, 120);
	tower.frames = Files.sparrowAtlas('tank/tankWatchtower');
	// tower.frames = FlxAtlasFrames.fromSparrow('assets/images/tank/tankWatchtower.png', 'assets/images/tank/tankWatchtower.xml');
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

	if (ClientPrefs.quality != 'Low') {
		tankBop1 = new FlxSprite(-500, 650);
		tankBop1.frames = Files.sparrowAtlas('tank/tank0');
		// tankBop1.frames = FlxAtlasFrames.fromSparrow('assets/images/tank/tank0.png', 'assets/images/tank/tank0.xml');
		tankBop1.animation.addByPrefix('bop', 'fg tankhead far right', 24);
		tankBop1.scrollFactor.set(1.7, 1.5);
		tankBop1.antialiasing = true;
		add(tankBop1);

		tankBop2 = new FlxSprite(-300, 750);
		tankBop2.frames = Files.sparrowAtlas('tank/tank1');
		// tankBop2.frames = FlxAtlasFrames.fromSparrow('assets/images/tank/tank1.png', 'assets/images/tank/tank1.xml');
		tankBop2.animation.addByPrefix('bop', 'fg tankhead 5', 24);
		tankBop2.scrollFactor.set(2.0, 0.2);
		tankBop2.antialiasing = true;
		add(tankBop2);

		tankBop3 = new FlxSprite(450, 940);
		tankBop3.frames = Files.sparrowAtlas('tank/tank2');
		// tankBop3.frames = FlxAtlasFrames.fromSparrow('assets/images/tank/tank2.png', 'assets/images/tank/tank2.xml');
		tankBop3.animation.addByPrefix('bop', 'foreground man 3', 24);
		tankBop3.scrollFactor.set(1.5, 1.5);
		tankBop3.antialiasing = true;
		add(tankBop3);

		tankBop4 = new FlxSprite(1300, 1200);
		tankBop4.frames = Files.sparrowAtlas('tank/tank3');
		// tankBop4.frames = FlxAtlasFrames.fromSparrow('assets/images/tank/tank3.png', 'assets/images/tank/tank3.xml');
		tankBop4.animation.addByPrefix('bop', 'fg tankhead 4', 24);
		tankBop4.scrollFactor.set(3.5, 2.5);
		tankBop4.antialiasing = true;
		add(tankBop4);

		tankBop5 = new FlxSprite(1300, 900);
		tankBop5.frames = Files.sparrowAtlas('tank/tank4');
		// tankBop5.frames = FlxAtlasFrames.fromSparrow('assets/images/tank/tank4.png', 'assets/images/tank/tank4.xml');
		tankBop5.animation.addByPrefix('bop', 'fg tankman bobbin 3', 24);
		tankBop5.scrollFactor.set(1.5, 1.5);
		tankBop5.antialiasing = true;
		add(tankBop5);

		tankBop6 = new FlxSprite(1620, 700);
		tankBop6.frames = Files.sparrowAtlas('tank/tank5');
		// tankBop6.frames = FlxAtlasFrames.fromSparrow('assets/images/tank/tank5.png', 'assets/images/tank/tank5.xml');
		tankBop6.animation.addByPrefix('bop', 'fg tankhead far right', 24);
		tankBop6.scrollFactor.set(1.5, 1.5);
		tankBop6.antialiasing = true;
		add(tankBop6);
	}
}

function update(elapsed:Float) {
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

function beatHit() {
    tower.animation.play('idle', true);
	if (ClientPrefs.quality != 'Low') {
		tankBop1.animation.play('bop', true);
		tankBop2.animation.play('bop', true);
		tankBop3.animation.play('bop', true);
		tankBop4.animation.play('bop', true);
		tankBop5.animation.play('bop', true);
		tankBop6.animation.play('bop', true);
	}
}