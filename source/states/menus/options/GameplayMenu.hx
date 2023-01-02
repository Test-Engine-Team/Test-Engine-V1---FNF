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

class GameplayMenu extends MusicBeatState{
    var maintextgroup:FlxTypedGroup<Alphabet>;
    var curSelected:Int = 0;
    //var sure:Bool = false;
    var options:Array<MenuOption> = [
        {
            name: "Ghost Tapping",
            description: "Pressing a key when there are no notes to hit will not count as a miss.",
            type: BOOL,
            min: 0,
            max: 1,
            updateFunc: function(menuOption:MenuOption, elapsed:Float) {
                if ([FlxG.keys.justPressed.ENTER, FlxG.keys.justPressed.LEFT, FlxG.keys.justPressed.RIGHT].contains(true)) {
                    ClientPrefs.ghostTapping = !ClientPrefs.ghostTapping;
                }
            },
            valueFunc: function() {
                return (ClientPrefs.ghostTapping) ? "Enabled" : "Disabled";
            }
        },
        {
            name: "Downscroll",
            description: "The notefield has been inverted to have the notes fall instead of rise.",
            type: BOOL,
            min: 0,
            max: 1,
            updateFunc: function(menuOption:MenuOption, elapsed:Float) {
                if ([FlxG.keys.justPressed.ENTER, FlxG.keys.justPressed.LEFT, FlxG.keys.justPressed.RIGHT].contains(true)) {
                    ClientPrefs.downscroll = !ClientPrefs.downscroll;
                }
            },
            valueFunc: function() {
                return (ClientPrefs.downscroll) ? "Enabled" : "Disabled";
            }
        },
        {
            name: "FPS Cap",
            description: "Don't like being stuck on 60? You have the ability to increase it!",
            type: INT,
            min: 60,
            max: 200,
            updateFunc: function(menuOption:MenuOption, elapsed:Float) {
                switch ([FlxG.keys.justPressed.LEFT, FlxG.keys.justPressed.RIGHT].indexOf(true)) {
                    case 0:
                        ClientPrefs.framerate -= 10;
                        if (ClientPrefs.framerate < menuOption.min) ClientPrefs.framerate = Std.int(menuOption.min);

                        if(ClientPrefs.framerate > FlxG.drawFramerate) {
                            FlxG.updateFramerate = ClientPrefs.framerate;
                            FlxG.drawFramerate = ClientPrefs.framerate;
                        } else {
                            FlxG.drawFramerate = ClientPrefs.framerate;
                            FlxG.updateFramerate = ClientPrefs.framerate;
                        }
                    case 1:
                        ClientPrefs.framerate += 10;
                        if (ClientPrefs.framerate > menuOption.max) ClientPrefs.framerate = Std.int(menuOption.max);

                        if(ClientPrefs.framerate > FlxG.drawFramerate) {
                            FlxG.updateFramerate = ClientPrefs.framerate;
                            FlxG.drawFramerate = ClientPrefs.framerate;
                        } else {
                            FlxG.drawFramerate = ClientPrefs.framerate;
                            FlxG.updateFramerate = ClientPrefs.framerate;
                        }
                }
            },
            valueFunc: function() {
                return Std.string(ClientPrefs.framerate);
            }
        },
        {
            name: "Show Combo Sprite",
            description: 'Shows the sprite saying "COMBO" when you hit a note.',
            type: BOOL,
            min: 0,
            max: 1,
            updateFunc: function(menuOption:MenuOption, elapsed:Float) {
                if ([FlxG.keys.justPressed.ENTER, FlxG.keys.justPressed.LEFT, FlxG.keys.justPressed.RIGHT].contains(true)) {
                    ClientPrefs.showComboSprite = !ClientPrefs.showComboSprite;
                }
            },
            valueFunc: function() {
                return (ClientPrefs.showComboSprite) ? "Enabled" : "Disabled";
            }
        },
        {
            name: "Cutscenes on Freeplay",
            description: "Plays cutscenes when you play a song on freeplay.",
            type: BOOL,
            min: 0,
            max: 1,
            updateFunc: function(menuOption:MenuOption, elapsed:Float) {
                if ([FlxG.keys.justPressed.ENTER, FlxG.keys.justPressed.LEFT, FlxG.keys.justPressed.RIGHT].contains(true)) {
                    ClientPrefs.freeplayCutscenes = !ClientPrefs.freeplayCutscenes;
                }
            },
            valueFunc: function() {
                return (ClientPrefs.freeplayCutscenes) ? "Enabled" : "Disabled";
            }
        },
        {
            name: "Safe Frames",
            description: "What frames you can hit a note on.",
            type: INT,
            min: 2,
            max: 20,
            updateFunc: function(menuOption:MenuOption, elapsed:Float) {
                if (FlxG.keys.justPressed.LEFT) {
                    ClientPrefs.safeFrames -= 1;
                    if (ClientPrefs.safeFrames < menuOption.min) ClientPrefs.safeFrames = Std.int(menuOption.min);
                }
                else if (FlxG.keys.justPressed.RIGHT) {
                    ClientPrefs.safeFrames += 1;
                    if (ClientPrefs.safeFrames > menuOption.max) ClientPrefs.safeFrames = Std.int(menuOption.max);
                }
            },
            valueFunc: function() {
                return Std.string(ClientPrefs.safeFrames);
            }
        },
        {
            name: "BotPlay",
            description: "Make the game play for you! Score will not be saved!",
            type: BOOL,
            min: 0,
            max: 1,
            updateFunc: function(menuOption:MenuOption, elapsed:Float) {
                if ([FlxG.keys.justPressed.ENTER, FlxG.keys.justPressed.LEFT, FlxG.keys.justPressed.RIGHT].contains(true)) {
                    ClientPrefs.botPlay = !ClientPrefs.botPlay;
                }
            },
            valueFunc: function() {
                return (ClientPrefs.botPlay) ? "Enabled" : "Disabled";
            }
        },
        {
            name: "Reset Cache",
            description: "Resets the Cache.",
            type: BUTTON,
            min: 0,
            max: 0,
            updateFunc: function(menuOption:MenuOption, elapsed:Float) {
                if ([FlxG.keys.justPressed.ENTER].contains(true)) {
                   // if (sure == true) {
                        FlxG.save.erase();
                        FlxG.switchState(new states.menus.LoadingState());
                    //}
                    //else
                    //{
                        //sure = true;
                    //}
                }
            },
            valueFunc: function() {
                //if (!sure)
                    return "Reset Progress?";
                //else
                    //return "Are You Sure?";
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