import flixel.system.FlxSound;
import flixel.group.FlxTypedGroup;

var phillyCityLights:FlxTypedGroup<FlxSprite>;
var phillyTrain:FlxSprite;
var trainSound:FlxSound;

var curLight:Int = 0;

var trainMoving:Bool = false;
var trainFrameTiming:Float = 0;

var trainCars:Int = 8;
var trainFinishing:Bool = false;
var trainCooldown:Int = 0;

var startedMoving:Bool = false;

function create() {
    var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Files.image('philly/sky'));
    bg.scrollFactor.set(0.1, 0.1);
    add(bg);

    var city:FlxSprite = new FlxSprite(-10).loadGraphic(Files.image('philly/city'));
    city.scrollFactor.set(0.3, 0.3);
    city.setGraphicSize(Std.int(city.width * 0.85));
    city.updateHitbox();
    add(city);

    phillyCityLights = new FlxTypedGroup(0);
    add(phillyCityLights);

    for (i in 0...5)
    {
        var light:FlxSprite = new FlxSprite(city.x).loadGraphic((Files.image('philly/win' + i)));
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
}

function update(elapsed:Float) {
    if (trainMoving) {
		trainFrameTiming += elapsed;

		if (trainFrameTiming >= 1 / 24) {
			updateTrainPos();
			trainFrameTiming = 0;
		}
	}
}

function beatHit() {
    if (!trainMoving)
        trainCooldown += 1;

    if (curBeat % 4 == 0) {
        for (light in phillyCityLights.members)
            light.visible = false;

        curLight = FlxG.random.int(0, phillyCityLights.length - 1);

        phillyCityLights.members[curLight].visible = true;
        // phillyCityLights.members[curLight].alpha = 1;
    }

    if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8) {
        trainCooldown = FlxG.random.int(-4, 0);
        trainStart();
    }
}

function updateTrainPos():Void {
    if (trainSound.time >= 4700) {
        if (!startedMoving)
            event('play anim', 'gf', 'hairBlow');
        startedMoving = true;
    }

    if (startedMoving) {
        phillyTrain.x -= 400;

        if (phillyTrain.x < -2000 && !trainFinishing) {
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
    event('play anim', 'gf', 'hairFall');
    phillyTrain.x = FlxG.width + 200;
    trainMoving = false;
    // trainSound.stop();
    // trainSound.time = 0;
    trainCars = 8;
    trainFinishing = false;
    startedMoving = false;
}