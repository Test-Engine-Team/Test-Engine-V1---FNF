package states.menus.options;

import handlers.ClientPrefs;
import handlers.Files;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import handlers.MusicBeatState;
import flixel.FlxG;
import ui.Alphabet;

//hehe i copy pasted this from my engine lol -Srt
typedef MenuOption = {
    var name:String;
    var description:String;
    var type:OptionType;
    var min:Float;
    var max:Float;

    var updateFunc:MenuOption->Float->Void;
    var valueFunc:Void->String;
}

enum OptionType {
    BOOL;
    INT;
    FLOAT;
    STRING;
    BUTTON;
}

class Options extends MusicBeatState {
    var maintextgroup:FlxTypedGroup<Alphabet>;
    var bg:FlxSprite;
    var curSelected:Int = 0;
    var Items:Array<String> = ['Keybinds', 'Gameplay', 'Modifiers', 'Optimization'];
    var timeSinceSelect:Float = -10;

    override function create() {
        bg = new FlxSprite().loadGraphic(Files.image('menuDesat'));
        bg.color = 0x302D2D;
		add(bg);
        
        maintextgroup = new FlxTypedGroup<Alphabet>();
		add(maintextgroup);

    for (i in 0...Items.length)
        {
        var maintext:Alphabet = new Alphabet(10, (70 * i) + 41.2, Items[i], true, false);
        maintext.isMenuItem = true;
        maintext.targetY = i;
        maintextgroup.add(maintext);
        }

        changeSelection();
}

    override public function update(elapsed:Float){

        if (timeSinceSelect == -10) {
            switch ([controls.ACCEPT, controls.UP_P, controls.DOWN_P, controls.BACK].indexOf(true)) {
                case 0:
                    timeSinceSelect = 0;
                    FlxG.sound.play(Files.sound('confirmMenu'), 1);
                case 1:
                    changeSelection(-1);
                case 2:
                    changeSelection(1);
                case 3:
                    ClientPrefs.saveSettings();
                    FlxG.switchState(new MainMenuState());
            }
        } else {
            timeSinceSelect += elapsed;
            bg.alpha = 1 - (Math.min(timeSinceSelect, 1));
            if (timeSinceSelect > 1.1) {
                switch (Items[curSelected]) {
                    case 'Keybinds':
                        FlxG.switchState(new states.menus.options.KeybindsMenu());
                    case 'Gameplay':
                        FlxG.switchState(new GameplayMenu());
                    case 'Modifiers':
                        FlxG.switchState(new ModifiersMenu());
                    case 'Optimization':
                        FlxG.switchState(new states.menus.options.OptimizationMenu());
                }
            }
        }

        super.update(elapsed);
        for (item in maintextgroup.members) {
            var daWidth = item.members[item.length - 1].x + (item.members[item.length - 1].width * item.scale.x) - item.x;
            item.x = 640 - daWidth / 2 + (960 * flixel.tweens.FlxEase.circOut(1 - bg.alpha));
        }
    }

    function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = Items.length - 1;
		if (curSelected >= Items.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in maintextgroup.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = (item.targetY == 0) ? 1 : 0.6;
		}

        if (change != 0)
            FlxG.sound.play(Files.sound('scrollMenu'), 0.4);
	}
}