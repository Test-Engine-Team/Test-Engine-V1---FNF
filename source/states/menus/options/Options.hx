package states.menus.options;

import handlers.Files;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import handlers.MusicBeatState;
import flixel.FlxG;
import ui.Alphabet;

class Options extends MusicBeatState {
    var maintextgroup:FlxTypedGroup<Alphabet>;
    var maintext:Alphabet;
    var curSelected:Int = 0;
    var Items:Array<String> = ['Gameplay', 'Modifiers'];

    override function create() {
        trace('unfinnished lol');
        var bg:FlxSprite = new FlxSprite().loadGraphic(Files.image('menuDesat'));
        bg.color = 0x302D2D;
		add(bg);
        
        maintextgroup = new FlxTypedGroup<Alphabet>();
		add(maintextgroup);

    for (i in 0...Items.length)
        {
        maintext = new Alphabet(10, (70 * i) + 41.2, Items[i], true);
        maintext.scale.set(0.8, 0.8);
        maintext.isMenuItem = true;
        maintextgroup.add(maintext);
        }

        changeSelection();
}

    override public function update(elapsed:Float){
        if (FlxG.keys.justPressed.ESCAPE)
        FlxG.switchState(new MainMenuState());

        if (FlxG.keys.justPressed.DOWN)
            changeSelection(1);

        if (FlxG.keys.justPressed.UP)
            changeSelection(-1);

        if (FlxG.keys.justPressed.ENTER){
            var daSelected:String = Items[curSelected];

			switch (daSelected)
			{
				case 'Gameplay':
                    FlxG.switchState(new GameplayMenu());
                case 'Modifiers':
                    FlxG.switchState(new ModifiersMenu());
			}
        }
    }

    function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

        FlxG.sound.play(Files.sound('scrollMenu'), 0.4);

		if (curSelected < 0)
			curSelected = Items.length - 1;
		if (curSelected >= Items.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in maintextgroup.members)
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
		}
	}
}