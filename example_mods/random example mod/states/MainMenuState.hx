import handlers.CoolUtil;
import flixel.FlxG;

function create() {
	optionShit = ['freeplay'];
}

function createBelowItems() {
	var bg2 = new FlxSprite(0, 0, Files.image("menus/rapbattle"));
	bg2.scale.set(1.7, 1.7);
	bg2.scrollFactor.set(0, 0.18);
	bg2.updateHitbox();
	bg2.screenCenter();
	add(bg2);
}

function update(elapsed) {
	if (FlxG.keys.justPressed.TAB)
		CoolUtil.switchToCustomState('TemplateState');
}
