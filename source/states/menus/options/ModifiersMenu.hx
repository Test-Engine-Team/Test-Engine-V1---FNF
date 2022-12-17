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

class ModifiersMenu extends MusicBeatState{
    var maintextgroup:FlxTypedGroup<Alphabet>;
    var maintext:Alphabet;
    var curSelected:Int = 0;
    var Items:Array<String> = ['Do A Barrel Roll', 'Fair Fight', 'Poison Plus'];
    var poisonPlusMinNum:Int = 0;
    var poisonPlusMaxNum:Int = 20;
    var curSubSelected:Int = 3;
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
        {
            changeSelection(1);
            curSubSelected = 3;
        }

        if (FlxG.keys.justPressed.UP)
        {
            changeSelection(-1);
            curSubSelected = 3;
        }

        var daSelected:String = Items[curSelected];

        if (daSelected == 'Do A Barrel Roll' && ClientPrefs.spinnyspin == false)
            trueorfalsesmthidk.text = 'Do A Barrel Roll = false';
        else if (daSelected == 'Do A Barrel Roll' && ClientPrefs.spinnyspin == true)
            trueorfalsesmthidk.text = 'Do A Barrel Roll = true';
        else if (daSelected == 'Fair Fight' && ClientPrefs.fairFight == false)
            trueorfalsesmthidk.text = 'Fair Fight = false';
        else if (daSelected == 'Fair Fight' && ClientPrefs.fairFight == true)
            trueorfalsesmthidk.text = 'Fair Fight = true';
        else if (daSelected == 'Poison Plus' && ClientPrefs.poisonPlus == false)
            trueorfalsesmthidk.text = 'Poison Plus = false';
        else if (daSelected == 'Poison Plus' && ClientPrefs.poisonPlus == true)
            trueorfalsesmthidk.text = 'Poison Plus = true | Max Poison Hits = $curSubSelected';
        else
            trueorfalsesmthidk.text == 'unknown option or null bool';

        if (FlxG.keys.justPressed.ENTER){
			switch (daSelected)
			{
                case 'Do A Barrel Roll':
                    if (ClientPrefs.spinnyspin == false)
                        ClientPrefs.spinnyspin = true;
                        else
                        ClientPrefs.spinnyspin = false;
                case 'Fair Fight':
                    if (ClientPrefs.fairFight == false)
                        ClientPrefs.fairFight = true;
                        else
                        ClientPrefs.fairFight = false;
                case 'Poison Plus':
                    if (ClientPrefs.poisonPlus == false)
                        ClientPrefs.poisonPlus = true;
                        else
                        ClientPrefs.poisonPlus = false;
			}
        }
        else if (FlxG.keys.justPressed.LEFT){ //down
            switch (daSelected)
            {
                case 'Poison Plus':
                    if (ClientPrefs.poisonPlus == true) {
                        changeSubSelection(-1);
                    }
            }}
        else if (FlxG.keys.justPressed.RIGHT){ //up
            switch(daSelected)
            {
                case 'Poison Plus':
                    if (ClientPrefs.poisonPlus == true) {
                        changeSubSelection(1);
                    }
            }}
    }

    /*
    if (FlxG.keys.justPressed.G)
        {
            if (ClientPrefs.ghostTapping == false) {
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
    function changeSubSelection(change:Int = 0):Void
    {
        curSubSelected += change;

        var daSelected:String = Items[curSelected];

        switch (daSelected)
        {
            case 'Poison Plus':
                if (curSubSelected < poisonPlusMinNum)
                    curSubSelected = 0;
                if (curSubSelected >= poisonPlusMaxNum) {
                    curSubSelected = poisonPlusMaxNum;
                }
        }

        if (daSelected == 'Poison Plus')
            ClientPrefs.maxPoisonHits = curSubSelected;
    }
}