import states.menus.MainMenuState;

var outsideTxt:FlxText;

// example script

function create() {
	outsideTxt = new FlxText(0, 0, 0, "This Text Hscript", 16);
	outsideTxt.screenCenter();
	add(outsideTxt);

	var bg = new FlxSprite(0, 0, Files.image("menus/rapbattle"));
	bg.scale.set(1.3, 1.3);
	bg.updateHitbox();
	add(bg);

	FlxG.sound.playMusic(Files.music("RAPbattle"));
}

function update() {
	var beatFloat = (FlxG.sound.music.time / Conductor.crochet) % 1;
	var daScale = 1 + beatFloat * 0.5;
	outsideTxt.scale.set(daScale, daScale);
	outsideTxt.updateHitbox();

	if (controls.BACK)
		FlxG.switchState(new MainMenuState());
}