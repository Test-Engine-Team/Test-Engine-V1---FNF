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

class GameplayMenu extends MusicBeatState{
    var maintextgroup:FlxTypedGroup<Alphabet>;
    var maintext:Alphabet;
    var curSelected:Int = 0;
    var Items:Array<String> = ['Ghost Tapping', 'Down Scroll'];
    var trueorfalsesmthidk:FlxText;

    override function create() {
        var bg:FlxSprite = new FlxSprite().loadGraphic(Files.image('menuDesat'));
        bg.color = 0x302D2D;
		add(bg);

        trueorfalsesmthidk = new FlxText(5, FlxG.height - 33.2, 0, "unknown option or null bool", 12);
		trueorfalsesmthidk.scrollFactor.set();
		trueorfalsesmthidk.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(trueorfalsesmthidk);
        
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
        FlxG.switchState(new Options());

        if (FlxG.keys.justPressed.DOWN)
            changeSelection(1);

        if (FlxG.keys.justPressed.UP)
            changeSelection(-1);

        var daSelected:String = Items[curSelected];

        if (daSelected == 'Ghost Tapping' && !ClientPrefs.ghostTapping)
            trueorfalsesmthidk.text = 'Ghost Tapping = false';
        else if (daSelected == 'Ghost Tapping' && ClientPrefs.ghostTapping)
            trueorfalsesmthidk.text = 'Ghost Tapping = true';
        else if (daSelected == 'Down Scroll')
            trueorfalsesmthidk.text = 'Down Scroll'
        else
            trueorfalsesmthidk.text == 'unknown option or null bool';

        if (FlxG.keys.justPressed.ENTER){
			switch (daSelected)
			{
				case 'Ghost Tapping':
                if (!ClientPrefs.ghostTapping)
                    ClientPrefs.ghostTapping = true;
                    else
                    ClientPrefs.ghostTapping = false;
			}
        }
    }

    /*
    if (FlxG.keys.justPressed.G)
        {
            if (!ClientPrefs.ghostTapping) {
                ClientPrefs.ghostTapping = true;
                trace("on");
            }
            else
            {
                ClientPrefs.ghostTapping = false;
                trace("off");
            }*/

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