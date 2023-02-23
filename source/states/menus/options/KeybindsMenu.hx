package states.menus.options;

import flixel.input.keyboard.FlxKey;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import handlers.Files;
import handlers.ClientPrefs;
import handlers.MusicBeatState;

class KeybindsMenu extends MusicBeatState {
	var curKeybind:Int = 0;
	var enterPromptTxt:FlxText;
	var keybindNames:Array<String> = [
		"first left",
		"first down",
		"first up",
		"first right",
		"second left",
		"second down",
		"second up",
		"second right",
		"reset"
	];
	var currentKeybinds:Array<FlxKey> = [];
	var sprites:Array<FlxSprite> = [];
	var keybindTxts:Array<FlxText> = [];

	override public function create() {
		super.create();

		currentKeybinds = [
			ClientPrefs.leftKeybinds[0],
			ClientPrefs.downKeybinds[0],
			ClientPrefs.upKeybinds[0],
			ClientPrefs.rightKeybinds[0],
			ClientPrefs.leftKeybinds[1],
			ClientPrefs.downKeybinds[1],
			ClientPrefs.upKeybinds[1],
			ClientPrefs.rightKeybinds[1],
			ClientPrefs.resetKeybind
		];

		var bg:FlxSprite = new FlxSprite().loadGraphic(Files.image('menus/mainmenu/menuDesat'));
		bg.color = 0x302D2D;
		add(bg);

		enterPromptTxt = new FlxText(0, 20, 1280, "Enter first left keybind.\n[ESC] - Leave Menu | [BACKSPACE] - Last Keybind", 24);
		enterPromptTxt.setFormat(Files.font("vcr"), 24, 0xFFFFFFFF, "center", FlxTextBorderStyle.OUTLINE, 0xFF000000);
		add(enterPromptTxt);

		for (i in 0...4) {
			var directions:Array<String> = ["LEFT", "DOWN", "UP", "RIGHT"];
			var arrow = new FlxSprite(FlxG.width / 2 - 220 + 110 * i, 150);
			// Complicated color set because fuck if statements.
			arrow.color = Math.floor(0xFFFFFFFF - 0x00505050 * Math.min(1, i));
			arrow.frames = Files.sparrowAtlas("NOTE_assets");
			arrow.animation.addByPrefix("arrow", "arrow" + directions[i]);
			arrow.animation.play("arrow");
			arrow.scale.set(0.7, 0.7);
			arrow.updateHitbox();
			add(arrow);
			sprites.push(arrow);

			var keybinds:String = currentKeybinds[i].toString() + "\n" + currentKeybinds[i + 4].toString();
			var txt:FlxText = new FlxText(FlxG.width / 2 - 220 + 110 * i, 260, 110, keybinds, 16);
			txt.setFormat(Files.font("vcr"), 16, 0xFFFFFFFF, "center", FlxTextBorderStyle.OUTLINE, 0xFF000000);
			add(txt);
			keybindTxts.push(txt);
		}

		var resetSprite = new FlxSprite(640 - 601 / 2, FlxG.height * 0.9 - 45, Files.image("menus/resetKeybindImage"));
		resetSprite.antialiasing = true;
		add(resetSprite);
		sprites.push(resetSprite);
		var resetTxt = new FlxText(resetSprite.x, resetSprite.y + 25, 601, currentKeybinds[8].toString(), 20);
		resetTxt.setFormat(Files.font("vcr"), 16, 0xFFFFFFFF, "center", FlxTextBorderStyle.OUTLINE, 0xFF000000);
		add(resetTxt);
		keybindTxts.push(resetTxt);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.keys.justPressed.BACKSPACE) {
			FlxG.sound.play(Files.sound("cancelMenu"));
			if (curKeybind == 9) {
				restartKeybinds();
				return;
			}
			curKeybind -= 1;
			if (curKeybind < 0) {
				FlxG.switchState(new states.menus.options.Options());
				return;
			}
			sprites[4].color = 0xFFFFFFFF - 0xFF505050 * (1 - Math.floor(curKeybind / 8));
			for (i in 0...4)
				sprites[i].color = (curKeybind % 4 == i && curKeybind != 8) ? 0xFFFFFFFF : 0xFFC0C0C0;
			enterPromptTxt.text = "Enter " + keybindNames[curKeybind] + " keybind.\n[ESC] - Leave Menu | [BACKSPACE] - Last Keybind";
			return;
		}

		if (FlxG.keys.justPressed.R)
			restartKeybinds();

		if (FlxG.keys.justPressed.ESCAPE) {
			FlxG.sound.play(Files.sound("cancelMenu"));
			FlxG.switchState(new states.menus.options.Options());
			return;
		}

		if (FlxG.keys.justPressed.ENTER && curKeybind == 9) {
			FlxG.sound.play(Files.sound("confirmMenu"));
			ClientPrefs.leftKeybinds = [currentKeybinds[0], currentKeybinds[4]];
			ClientPrefs.downKeybinds = [currentKeybinds[1], currentKeybinds[5]];
			ClientPrefs.upKeybinds = [currentKeybinds[2], currentKeybinds[6]];
			ClientPrefs.rightKeybinds = [currentKeybinds[3], currentKeybinds[7]];
			ClientPrefs.resetKeybind = currentKeybinds[8];
			FlxG.switchState(new states.menus.options.Options());
			return;
		}

		if (!FlxG.keys.justPressed.ANY)
			return;
		FlxG.sound.play(Files.sound("scrollMenu"));
		var newKey:FlxKey = FlxG.keys.firstJustPressed();
		currentKeybinds[curKeybind] = newKey;
		for (i in 0...4)
			keybindTxts[i].text = currentKeybinds[i].toString() + "\n" + currentKeybinds[i + 4].toString();
		keybindTxts[4].text = currentKeybinds[8].toString();
		curKeybind++;
		if (curKeybind == 9) {
			enterPromptTxt.text = "Are you happy with these keybinds?\n[ENTER] - Yes. Save These. [BACKSPACE] - No. Restart.";
			for (sprite in sprites)
				sprite.color = 0xFFFFFFFF;
			return;
		}
		sprites[4].color = 0xFFFFFFFF - 0xFF505050 * (1 - Math.floor(curKeybind / 8));
		for (i in 0...4)
			sprites[i].color = (curKeybind % 4 == i && curKeybind != 8) ? 0xFFFFFFFF : 0xFFC0C0C0;
		enterPromptTxt.text = "Enter " + keybindNames[curKeybind] + " keybind.\n[ESC] - Leave Menu | [BACKSPACE] - Last Keybind";
	}

	function restartKeybinds() {
		currentKeybinds = [
			ClientPrefs.leftKeybinds[0],
			ClientPrefs.downKeybinds[0],
			ClientPrefs.upKeybinds[0],
			ClientPrefs.rightKeybinds[0],
			ClientPrefs.leftKeybinds[1],
			ClientPrefs.downKeybinds[1],
			ClientPrefs.upKeybinds[1],
			ClientPrefs.rightKeybinds[1],
			ClientPrefs.resetKeybind
		];
		curKeybind = 0;
		for (i in 0...5) {
			sprites[i].color = Math.floor(0xFFFFFFFF - 0x00505050 * Math.min(1, i));
			keybindTxts[i].text = (i == 4) ? currentKeybinds[8].toString() : currentKeybinds[i].toString() + "\n" + currentKeybinds[i + 4].toString();
		}
		enterPromptTxt.text = "Enter first left keybind.\n[ESC] - Leave Menu | [BACKSPACE] - Last Keybind";
	}
}
