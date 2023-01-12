import handlers.CoolUtil;

var danced:Bool = false;
var bgGirls:FlxSprite;

function create() {
	addScript("data/pixelUI");

	defaultCamZoom = 1;

	var bgSky = new FlxSprite().loadGraphic('assets/images/weeb/weebSky.png');
	bgSky.scrollFactor.set(0.1, 0.1);
	bgSky.antialiasing = false;
	add(bgSky);

	var repositionShit = -200;

	var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic('assets/images/weeb/weebSchool.png');
	bgSchool.scrollFactor.set(0.6, 0.90);
	bgSchool.antialiasing = false;
	add(bgSchool);

	var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic('assets/images/weeb/weebStreet.png');
	bgStreet.scrollFactor.set(0.95, 0.95);
	bgStreet.antialiasing = false;
	add(bgStreet);

	var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic('assets/images/weeb/weebTreesBack.png');
	fgTrees.scrollFactor.set(0.9, 0.9);
	fgTrees.antialiasing = false;
	add(fgTrees);

	var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
	bgTrees.frames = Files.packerAtlas('weeb/weebTrees');
	bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
	bgTrees.animation.play('treeLoop');
	bgTrees.scrollFactor.set(0.85, 0.85);
	bgTrees.antialiasing = false;
	add(bgTrees);

	var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
	treeLeaves.frames = Files.sparrowAtlas('weeb/petals');
	treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
	treeLeaves.animation.play('leaves');
	treeLeaves.scrollFactor.set(0.85, 0.85);
	treeLeaves.antialiasing = false;
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
	bgGirls.antialiasing = false;
	add(bgGirls);

	boyfriend.regX += 200;
	boyfriend.regY += 220;
	gf.regX += 180;
	gf.regY += 300;

	camOffsets.bfCamX = -100;
	camOffsets.bfCamY = -100;
}

function beatHit() {
	danced = !danced;
	bgGirls.animation.play(danced ? "danceLeft" : "danceRight");
}