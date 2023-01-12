function create() {
	addScript("data/pixelUI");

    defaultCamZoom = 1;
    var bg:FlxSprite = new FlxSprite(400, 200);
    bg.frames = Files.sparrowAtlas('weeb/animatedEvilSchool');
    //bg.frames = FlxAtlasFrames.fromSparrow('assets/images/weeb/animatedEvilSchool.png', 'assets/images/weeb/animatedEvilSchool.xml');
    bg.animation.addByPrefix('idle', 'background 2', 24);
    bg.animation.play('idle');
    bg.scrollFactor.set(0.8, 0.9);
    bg.antialiasing = false;
    bg.scale.set(6, 6);
    add(bg);

	boyfriend.regX += 200;
	boyfriend.regY += 220;
	gf.regX += 180;
	gf.regY += 300;

	var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
	add(evilTrail);

    camOffsets.bfCamX = -100;
    camOffsets.bfCamY = -100;
}