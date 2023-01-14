package states.menus.options;

import flixel.util.FlxColor;
import flixel.text.FlxText;
import handlers.Files;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import handlers.MusicBeatState;
import flixel.FlxG;
import ui.Alphabet;
import handlers.ClientPrefs;
import states.menus.options.Options;

class OptimizationMenu extends MusicBeatState {
    var maintextgroup:FlxTypedGroup<Alphabet>;
    var curSelected:Int = 0;
    var options:Array<MenuOption> = [
        {
            name: "Antialiasing",
            description: "Smoothens the pixels of sprites and text objects at the cost of some resources.",
            type: BOOL,
            min: 0,
            max: 1,
            //conflicts: null,
            updateFunc: function(menuOption:MenuOption, elapsed:Float) {
                if ([FlxG.keys.justPressed.ENTER, FlxG.keys.justPressed.LEFT, FlxG.keys.justPressed.RIGHT].contains(true)) {
                    ClientPrefs.antialiasing = !ClientPrefs.antialiasing;
                }
            },
            valueFunc: function() {
                return (ClientPrefs.antialiasing) ? "Enabled" : "Disabled";
            }
        }
    ];
    var valueTxt:FlxText;
    var descTxt:FlxText;

    override function create() {
        var bg:FlxSprite = new FlxSprite().loadGraphic(Files.image('menuDesat'));
        bg.color = 0x302D2D;
		add(bg);

        valueTxt = new FlxText(820, 360, 460, "< Enabled > ", 36);
        valueTxt.y -= valueTxt.height / 2;
		valueTxt.scrollFactor.set();
		valueTxt.setFormat("VCR OSD Mono", 36, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(valueTxt);

        descTxt = new FlxText(820, valueTxt.y + valueTxt.height + 20, 460, "69420 hehe haha now laugh", 16);
		descTxt.scrollFactor.set();
		descTxt.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(descTxt);
        
        maintextgroup = new FlxTypedGroup<Alphabet>();
		add(maintextgroup);

        for (i in 0...options.length) {
            var maintext:Alphabet = new Alphabet(10, (70 * i) + 41.2, options[i].name, true, false, 0.8);
            maintext.isMenuItem = true;
            maintext.targetY = i;
            maintextgroup.add(maintext);
        }

        changeSelection();
    }

    override public function update(elapsed:Float){
        super.update(elapsed);

        if (FlxG.keys.justPressed.ESCAPE)
            FlxG.switchState(new Options());

        if (controls.UP_P || controls.DOWN_P) {
            changeSelection((controls.UP_P) ? -1 : 1);
        }
        options[curSelected].updateFunc(options[curSelected], elapsed);
        valueTxt.text = "< " + options[curSelected].valueFunc() + " >";

        #if debug
        descTxt.text =  options[curSelected].description;
        for (item in maintextgroup.members) {
            descTxt.text += "Y: " + item.y + " | TargetY: " + item.targetY + '\n';
        }
        #end
    }

    function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in maintextgroup.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = (item.targetY == 0) ? 1 : 0.6;
		}

        descTxt.text = options[curSelected].description;

        if (change != 0)
            FlxG.sound.play(Files.sound('scrollMenu'), 0.4);
	}
}