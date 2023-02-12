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
import Controls;

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
            //conflicts: null,
            updateFunc: function(menuOption:MenuOption, elapsed:Float) {
                if ([FlxG.keys.justPressed.ENTER, FlxG.keys.justPressed.LEFT, FlxG.keys.justPressed.RIGHT].contains(true))
                    ClientPrefs.ghostTapping = !ClientPrefs.ghostTapping;
                if (FlxG.keys.justPressed.R)
                    ClientPrefs.ghostTapping = true;
            },
            valueFunc: function() {
                return (ClientPrefs.ghostTapping) ? "Enabled" : "Disabled";
            }
        },
        {
            name: "Scroll Type",
            description: "Which way does the note field go",
            type: BOOL,
            min: 0,
            max: 1,
            //conflicts: null,
            updateFunc: function(menuOption:MenuOption, elapsed:Float) {
                if ([FlxG.keys.justPressed.ENTER, FlxG.keys.justPressed.LEFT, FlxG.keys.justPressed.RIGHT].contains(true))
                    ClientPrefs.downscroll = !ClientPrefs.downscroll;
                if (FlxG.keys.justPressed.R)
                    ClientPrefs.downscroll = false;
            },
            valueFunc: function() {
                return (ClientPrefs.downscroll) ? "Downscroll" : "Upscroll";
            }
        },
        {
            name: "FPS Cap",
            description: "Don't like being stuck on 60? You have the ability to increase it!",
            type: INT,
            min: 60,
            max: 200,
            //conflicts: null,
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
                if (FlxG.keys.justPressed.R)
                    ClientPrefs.framerate = 60;
            },
            valueFunc: function() {
                return Std.string(ClientPrefs.framerate);
            }
        },
        {
            name: "Cutscenes on Freeplay",
            description: "Plays cutscenes when you play a song on freeplay.",
            type: BOOL,
            min: 0,
            max: 1,
            //conflicts: null,
            updateFunc: function(menuOption:MenuOption, elapsed:Float) {
                if ([FlxG.keys.justPressed.ENTER, FlxG.keys.justPressed.LEFT, FlxG.keys.justPressed.RIGHT].contains(true))
                    ClientPrefs.freeplayCutscenes = !ClientPrefs.freeplayCutscenes;
                if (FlxG.keys.justPressed.R)
                    ClientPrefs.freeplayCutscenes = false;
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
            //conflicts: null,
            updateFunc: function(menuOption:MenuOption, elapsed:Float) {
                if (FlxG.keys.justPressed.LEFT) {
                    ClientPrefs.safeFrames -= 1;
                    if (ClientPrefs.safeFrames < menuOption.min) ClientPrefs.safeFrames = Std.int(menuOption.min);
                }
                else if (FlxG.keys.justPressed.RIGHT) {
                    ClientPrefs.safeFrames += 1;
                    if (ClientPrefs.safeFrames > menuOption.max) ClientPrefs.safeFrames = Std.int(menuOption.max);
                }
                if (FlxG.keys.justPressed.R)
                    ClientPrefs.safeFrames = 10;
            },
            valueFunc: function() {
                return Std.string(ClientPrefs.safeFrames);
            }
        },
        {
            name: "BotPlay",
            description: "Make the game play for you! Score will not be saved! (NOT IMPLEMENTED YET!)",
            type: BOOL,
            min: 0,
            max: 1,
            //conflicts: null,
            updateFunc: function(menuOption:MenuOption, elapsed:Float) {
                if ([FlxG.keys.justPressed.ENTER, FlxG.keys.justPressed.LEFT, FlxG.keys.justPressed.RIGHT].contains(true))
                    ClientPrefs.botPlay = !ClientPrefs.botPlay;
                if (FlxG.keys.justPressed.R)
                    ClientPrefs.botPlay = false;
            },
            valueFunc: function() {
                return (ClientPrefs.botPlay) ? "Enabled" : "Disabled";
            }
        },
        {
            name: "Practice",
            description: "You cant die! Score will not be saved!",
            type: BOOL,
            min: 0,
            max: 1,
            //conflicts: ['FC Mode', 'Max Misses', 'BotPlay'],
            updateFunc: function(menuOption:MenuOption, elapsed:Float) {
                if ([FlxG.keys.justPressed.ENTER, FlxG.keys.justPressed.LEFT, FlxG.keys.justPressed.RIGHT].contains(true))
                    ClientPrefs.practice = !ClientPrefs.practice;
                if (FlxG.keys.justPressed.R)
                    ClientPrefs.practice = false;
            },
            valueFunc: function() {
                return (ClientPrefs.practice) ? "Enabled" : "Disabled";
            }
        },
        {
            name: "Shit System",
            description: "if you get a \"Shit\" rating it will count as a miss",
            type: BOOL,
            min: 0,
            max: 1,
            //conflicts: null,
            updateFunc: function(menuOption:MenuOption, elapsed:Float) {
                if ([FlxG.keys.justPressed.ENTER, FlxG.keys.justPressed.LEFT, FlxG.keys.justPressed.RIGHT].contains(true))
                    ClientPrefs.shitSystem = !ClientPrefs.shitSystem;
                if (FlxG.keys.justPressed.R)
                    ClientPrefs.shitSystem = true;
            },
            valueFunc: function() {
                return (ClientPrefs.shitSystem) ? "Enabled" : "Disabled";
            }
        },
        {
            name: "Cam Move on Note Hit",
            description: "Camera moves up a little bit on hitting up for example (from Forever Engine)",
            type: BOOL,
            min: 0,
            max: 1,
            //conflicts: null,
            updateFunc: function(menuOption:MenuOption, elapsed:Float) {
                if ([FlxG.keys.justPressed.ENTER, FlxG.keys.justPressed.LEFT, FlxG.keys.justPressed.RIGHT].contains(true))
                    ClientPrefs.camMoveOnHit = !ClientPrefs.camMoveOnHit;
                if (FlxG.keys.justPressed.R)
                    ClientPrefs.camMoveOnHit = true;
            },
            valueFunc: function() {
                return (ClientPrefs.camMoveOnHit) ? "Enabled" : "Disabled";
            }
        },
        {
            name: "Flashing Lights",
            description: "Leave on if you are not prone to epilepsy",
            type: BOOL,
            min: 0,
            max: 1,
            //conflicts: null,
            updateFunc: function(menuOption:MenuOption, elapsed:Float) {
                if ([FlxG.keys.justPressed.ENTER, FlxG.keys.justPressed.LEFT, FlxG.keys.justPressed.RIGHT].contains(true))
                    ClientPrefs.flashingLights = !ClientPrefs.flashingLights;
            },
            valueFunc: function() {
                return (ClientPrefs.flashingLights) ? "Enabled" : "Disabled";
            }
        },
        #if !html5
        {
            name: "Auto Pause",
            description: "If enabled, the game will pause when you tab out",
            type: BOOL,
            min: 0,
            max: 1,
            //conflicts: null,
            updateFunc: function(menuOption:MenuOption, elapsed:Float) {
                if ([FlxG.keys.justPressed.ENTER, FlxG.keys.justPressed.LEFT, FlxG.keys.justPressed.RIGHT].contains(true)) {
                    ClientPrefs.autoPause = !ClientPrefs.autoPause;
                    FlxG.autoPause = ClientPrefs.autoPause;
                }
                if (FlxG.keys.justPressed.R)
                    ClientPrefs.autoPause = true;
            },
            valueFunc: function() {
                return (ClientPrefs.autoPause) ? "Enabled" : "Disabled";
            }
        },
        #end
        {
            name: "Reset Cache",
            description: "Resets the Cache.",
            type: BUTTON,
            min: 0,
            max: 0,
            //conflicts: null,
            updateFunc: function(menuOption:MenuOption, elapsed:Float) {
                if ([FlxG.keys.justPressed.ENTER].contains(true)) {
                   // if (sure == true) {
                        FlxG.save.erase();
                        FlxG.save.data.seenFlashingLightsWarning = false;
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
        var bg:FlxSprite = new FlxSprite().loadGraphic(Files.image('menus/mainmenu/menuDesat'));
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