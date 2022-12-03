package;

import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import states.menus.MainMenuState;
import ui.Alphabet;
import handlers.MusicBeatState;

class OptionsMenu extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;

	private var grpControls:FlxTypedGroup<Alphabet>;

    var optionShit:Array<String> = ['Controls', 'Gameplay'];

	override function create()
	{
		/*var menuBG:FlxSprite = new FlxSprite().loadGraphic('assets/images/menuDesat.png');
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		for (i in 0...controlsStrings.length)
		{
			if (controlsStrings[i].indexOf('set') != -1)
			{
				var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, controlsStrings[i].substring(3) + ': ' + controlsStrings[i + 1], true, false);
				controlLabel.isMenuItem = true;
				controlLabel.targetY = i;
				grpControls.add(controlLabel);
			}
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}*/

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (controls.ACCEPT)
		{/*
			switch (curSelected)
            {
                case 0:
                    FlxG.switchState(new ControlsState());
                case 1:
                    FlxG.switchState(new GameplayOptionsState());
            }*/
		}

        if (controls.BACK)
            FlxG.switchState(new MainMenuState());
        if (controls.UP_P)
            changeSelection(-1);
        if (controls.DOWN_P)
            changeSelection(1);
	}

	function changeSelection(change:Int = 0)
	{/*
		FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt, 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = optionShit.length - 1;
		if (curSelected >= optionShit.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in optionShit)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}*/
	}
}