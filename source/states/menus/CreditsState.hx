package;

import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.util.FlxColor;
import states.mainstates.PlayState;
import states.menus.MainMenuState;
import ui.Alphabet;
import handlers.MusicBeatState;
import handlers.Files;
import ui.HealthIcon;
#if desktop
import handlers.DiscordHandler;
#end

class CreditsState extends MusicBeatState 
{
    static var curSelected:Int = 0;

    var credits:Array<Array<String>> = [
        ['Name',		'icon',		'description',	 'url',	'FFEDD9']
    ];

	var grpText:FlxTypedGroup<Alphabet>;

    override public function create()
	{
        var bg = new FlxSprite().loadGraphic(Files.image('menus/mainmenu/menuDesat'));
        bg.color = getBGColor();
        add(bg);

		grpText = new FlxTypedGroup<Alphabet>();
		add(grpText);

		for (i in 0...credits.length)
		{
			var songText:Alphabet = new Alphabet(FlxG.width / 2, 300, credits[i][0], true, false);
			songText.targetY = i;
			grpText.add(songText);
		}
		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

        if (controls.BACK)
            FlxG.switchState(new MainMenuState());

		if (controls.UP_P)
			changeSelection(-1);
		if (controls.DOWN_P)
			changeSelection(1);

		if (controls.ACCEPT)
		{
            if (credits[curSelected][3] == null || credits[curSelected][3].length <= 0) return;

			switch (credits[curSelected][3])
			{
				case "Megalo":
					//trace('https://www.youtube.com/channel/UCJiGOmngd5RGGHwO1Dctnyg');
					//Lib.getURL (new URLRequest ('https://www.youtube.com/channel/UCJiGOmngd5RGGHwO1Dctnyg'), "_blank"); 
					//openfl.system.System.exit(0); deleted because it was just a troll. - Megalo

				case "mackery":
                    //trace('https://www.youtube.com/@Mackery');
                    //Lib.getURL (new URLRequest ('https://www.youtube.com/@Mackery'), "_blank"); 

				case "[504]Brandon":
					//trace('https://github.com/504brandon');
					//Lib.getURL (new URLRequest ('https://github.com/504brandon'), "_blank"); 
			}
		}
	}

	override function destroy()
	{
		return super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = credits.length - 1;
		if (curSelected >= credits.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpText.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
				item.alpha = 1;
		}
	}

    inline function getBGColor(){
		var bgColor:String = credits[curSelected][4];
		if (!bgColor.startsWith('0x'))
			bgColor = '0xFF' + bgColor;
		return Std.parseInt(bgColor);
    }
}