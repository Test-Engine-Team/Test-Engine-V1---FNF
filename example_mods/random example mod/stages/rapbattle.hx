var addGF = false;

function create() {
	defaultCamZoom = 0.7;

	var bg = new FlxSprite(200, 0, Paths.image("menus/rapbattle"));
	bg.scale.set(2, 2);
	add(bg);

	dad.regX -= 300;
	camOffsets.dadCamX = 250;
	camOffsets.bfCamX = -300;
}