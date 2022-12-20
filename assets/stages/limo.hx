import flixel.system.FlxSound;
import flixel.group.FlxTypedGroup;
import handlers.BackgroundDancer;

var addGF = false;

var fastCarCanDrive:Bool = true;

var limo:FlxSprite;
var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
var fastCar:FlxSprite;

function create() {
    defaultCamZoom = 0.90;

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

    grpLimoDancers = new FlxTypedGroup();
    add(grpLimoDancers);

    for (i in 0...5)
    {
        var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
        dancer.scrollFactor.set(0.4, 0.4);
        grpLimoDancers.add(dancer);
    }

    var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic('assets/images/limo/limoOverlay.png');
    overlayShit.alpha = 0.5;

    var limoTex = Files.sparrowAtlas('limo/limoDrive');
    // var limoTex = FlxAtlasFrames.fromSparrow('assets/images/limo/limoDrive.png', 'assets/images/limo/limoDrive.xml');

    add(gf);

    limo = new FlxSprite(-120, 550);
    limo.frames = limoTex;
    limo.animation.addByPrefix('drive', "Limo stage", 24);
    limo.animation.play('drive');
    limo.antialiasing = true;
    add(limo);

    fastCar = new FlxSprite(-300, 160).loadGraphic('assets/images/limo/fastCarLol.png');
    // add(limo);

	boyfriend.regX += 260;
	boyfriend.regY -= 220;
}

function beatHit() {
    grpLimoDancers.forEach(function(dancer:BackgroundDancer) {
        dancer.dance();
    });

    if (FlxG.random.bool(10) && fastCarCanDrive)
        fastCarDrive();
}

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