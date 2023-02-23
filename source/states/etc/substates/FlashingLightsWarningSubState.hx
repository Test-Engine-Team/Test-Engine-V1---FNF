package states.etc.substates;

import flixel.addons.ui.FlxUIColorSwatchSelecter;
import handlers.MusicBeatState;
import flixel.text.FlxText;
import flixel.FlxG;
import handlers.MusicBeatSubstate;
import handlers.ClientPrefs;
import flixel.FlxSprite;
import states.menus.TitleState;

class FlashingLightsWarningSubState extends MusicBeatSubstate {
	var warnText:FlxText;

	public static var seenMenu:Bool = false;

	var selected:Bool = false;

	public function new() {
		super();

		// make a black background
		var bg:FlxSprite = new FlxSprite(0, 0);
		bg.makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
		add(bg);

		// put warning text at the middle of the screen
		warnText = new FlxText(0, FlxG.height / 2, FlxG.width, "WARNING: FLASHING LIGHTS\nPress ENTER to ignore\nPress ESC to disable flashing lights!");
		warnText.setFormat(null, 16, 0xFFFFFFFF, "center");
		add(warnText);
	}

	override function update(elapsed:Float) {
		// if the user presses enter it will ignore the warning and go back to title state
		if (FlxG.keys.justPressed.ENTER) {
			FlxG.save.data.seenFlashingLightsWarning = true;
			TitleState.reloadNeeded = true;
			close();
		}
		// if the user presses escape it will disable the flashing lights
		if (FlxG.keys.justPressed.ESCAPE) {
			FlxG.save.data.seenFlashingLightsWarning = true;
			TitleState.reloadNeeded = true;
			ClientPrefs.flashingLights = false;
			close();
		}

		super.update(elapsed);
	}
}
