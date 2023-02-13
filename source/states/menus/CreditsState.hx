package;

import flixel.text.FlxText;
import Controls.Control;
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

import flixel.FlxState;

class CreditsState extends FlxState 
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
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, credits[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpText.add(songText);
		}
		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

        if (FlxG.keys.justPressed.ESCAPE)
            FlxG.switchState(new MainMenuState());

		if (upP)
			changeSelection(-1);
		if (downP)
			changeSelection(1);

		if (accepted)
		{
			var daSelected:String = credits[curSelected];

			switch (daSelected)
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
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
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