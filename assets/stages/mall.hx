var upperBoppers:FlxSprite;
var bottomBoppers:FlxSprite;
var santa:FlxSprite;

function create() {
    defaultCamZoom = 0.80;
	
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

	boyfriend.regX += 200;
}

function beatHit() {
    upperBoppers.animation.play('bop', true);
    bottomBoppers.animation.play('bop', true);
    santa.animation.play('idle', true);
}