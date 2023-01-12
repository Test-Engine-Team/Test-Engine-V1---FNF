function create() {
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

	boyfriend.regX += 320;
	dad.regY -= 80;
}