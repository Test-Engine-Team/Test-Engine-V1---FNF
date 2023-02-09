package states.menus.options;

import states.menus.options.Options.MenuOption;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import handlers.Files;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import handlers.MusicBeatState;
import flixel.FlxG;
import ui.Alphabet;
import handlers.ClientPrefs;

class ModifiersMenu extends MusicBeatState {
    var maintextgroup:FlxTypedGroup<Alphabet>;
    var curSelected:Int = 0;
    var options:Array<MenuOption> = [
        {
            name: "Do A Barrel Roll",
            description: "game camera go spin weeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee",
            type: BOOL,
            min: 0,
            max: 1,
            //conflicts: null,
            updateFunc: function(menuOption:MenuOption, elapsed:Float) {
                if ([FlxG.keys.justPressed.ENTER, FlxG.keys.justPressed.LEFT, FlxG.keys.justPressed.RIGHT].contains(true))
                    ClientPrefs.spinnyspin = !ClientPrefs.spinnyspin;
                if (FlxG.keys.justPressed.R)
                    ClientPrefs.spinnyspin = false; //most of the modifiers will be false
            },
            valueFunc: function() {
                return (ClientPrefs.spinnyspin) ? "Enabled" : "Disabled";
            }
        },
        {
            name: "Fair Fight",
            description: "The opponent can decrease your health when playing as well.\nBasically healthdrain.",
            type: BOOL,
            min: 0,
            max: 1,
            //conflicts: null,
            updateFunc: function(menuOption:MenuOption, elapsed:Float) {
                if ([FlxG.keys.justPressed.ENTER, FlxG.keys.justPressed.LEFT, FlxG.keys.justPressed.RIGHT].contains(true))
                    ClientPrefs.fairFight = !ClientPrefs.fairFight;
                if (FlxG.keys.justPressed.R)
                    ClientPrefs.fairFight = false;
            },
            valueFunc: function() {
                return (ClientPrefs.fairFight) ? "Enabled" : "Disabled";
            }
        },
        {
            name: "Poison",
            description: "Missed a Note? Get ready to lose health over time.\n(Note that the number you set is the Max amont of times you can be poisoned\n0 being infinite)",
            type: INT,
            min: 0,
            max: 20,
            //conflicts: ['FC Mode'],
            updateFunc: function(menuOption:MenuOption, elapsed:Float) {
                switch ([FlxG.keys.justPressed.ENTER, FlxG.keys.justPressed.LEFT, FlxG.keys.justPressed.RIGHT].indexOf(true)) {
                    case 0:
                        ClientPrefs.poisonPlus = !ClientPrefs.poisonPlus;
                        ClientPrefs.maxPoisonHits = 3;
                        ClientPrefs.fcMode = false;
                    case 1:
                        if (ClientPrefs.poisonPlus) ClientPrefs.maxPoisonHits -= 1;
                        if (ClientPrefs.maxPoisonHits < menuOption.min) ClientPrefs.maxPoisonHits = Std.int(menuOption.min);
                    case 2:
                        if (ClientPrefs.poisonPlus) ClientPrefs.maxPoisonHits += 1;
                        if (ClientPrefs.maxPoisonHits > menuOption.max) ClientPrefs.maxPoisonHits = Std.int(menuOption.max);
                }
                if (FlxG.keys.justPressed.R) {
                    ClientPrefs.poisonPlus = false;
                    ClientPrefs.maxPoisonHits = 3;
                }
            },
            valueFunc: function() {
                return (ClientPrefs.poisonPlus) ? Std.string(ClientPrefs.maxPoisonHits) : "Disabled";
            }
        },
        {
            name: "FC Mode",
            description: "Missed a Note? Fuck you your dead!",
            type: BOOL,
            min: 0,
            max: 1,
            //conflicts: ['Poison', 'Max Misses],
            updateFunc: function(menuOption:MenuOption, elapsed:Float) {
                if ([FlxG.keys.justPressed.ENTER, FlxG.keys.justPressed.LEFT, FlxG.keys.justPressed.RIGHT].contains(true)) {
                    ClientPrefs.fcMode = !ClientPrefs.fcMode;
                    ClientPrefs.poisonPlus = false;
                    ClientPrefs.limitMisses = false;
                    ClientPrefs.maxMisses = 2;
                }
                if (FlxG.keys.justPressed.R)
                    ClientPrefs.fcMode = false;
            },
            valueFunc: function() {
                return (ClientPrefs.fcMode) ? "Enabled" : "Disabled";
            }
        },
        {
            name: "Max Misses",
            description: "How many misses before you die!\n(for 1 miss use FC Mode)",
            type: INT,
            min: 2,
            max: 10,
            //conflicts: ['FC Mode'],
            updateFunc: function(menuOption:MenuOption, elapsed:Float) {
                switch ([FlxG.keys.justPressed.ENTER, FlxG.keys.justPressed.LEFT, FlxG.keys.justPressed.RIGHT].indexOf(true)) {
                    case 0:
                        ClientPrefs.limitMisses = !ClientPrefs.limitMisses;
                        ClientPrefs.fcMode = false;
                    case 1:
                        if (ClientPrefs.limitMisses) ClientPrefs.maxMisses -= 1;
                        if (ClientPrefs.maxMisses < menuOption.min) ClientPrefs.maxMisses = Std.int(menuOption.min);
                    case 2:
                        if (ClientPrefs.limitMisses) ClientPrefs.maxMisses += 1;
                        if (ClientPrefs.maxMisses > menuOption.max) ClientPrefs.maxMisses = Std.int(menuOption.max);
                }
                if (FlxG.keys.justPressed.R) {
                    ClientPrefs.limitMisses = false;
                    ClientPrefs.maxMisses = 2;
                }
            },
            valueFunc: function() {
                return (ClientPrefs.limitMisses) ? Std.string(ClientPrefs.maxMisses) : "Disabled";
            }
        },
        {
            name: "Speed",
            description: "Speed up or slow down a song",
            type: INT,
            min: -7,
            max: 100,
            //conflicts: null,
            updateFunc: function(menuOption:MenuOption, elapsed:Float) {
                if (FlxG.keys.justPressed.LEFT) {
                    ClientPrefs.speed -= 1;
                    if (ClientPrefs.speed < menuOption.min) ClientPrefs.speed = Std.int(menuOption.min);
                }
                else if (FlxG.keys.justPressed.RIGHT) {
                    ClientPrefs.speed += 1;
                    if (ClientPrefs.speed > menuOption.max) ClientPrefs.speed = Std.int(menuOption.max);
                }
                if (FlxG.keys.justPressed.R)
                    ClientPrefs.speed = 1;
            },
            valueFunc: function() {
                return Std.string(ClientPrefs.speed);
            }
        },
        {
            name: "Health Drain",
            description: "If health should slowly drain over time (multiplier)",
            type: INT,
            min: 10,
            max: 500,
            //conflicts: ["constantHeal"],
            updateFunc: function(menuOption:MenuOption, elapsed:Float) {
                if (FlxG.keys.justPressed.ENTER) {
                    ClientPrefs.constantHeal = 0;
                    if (ClientPrefs.constantDrain != 0)
                        ClientPrefs.constantDrain = 0;
                    else
                        ClientPrefs.constantDrain = 10;
                }
                else if (FlxG.keys.justPressed.LEFT && ClientPrefs.constantDrain != 0) {
                    ClientPrefs.constantDrain -= 10;
                    if (ClientPrefs.constantDrain < menuOption.min) ClientPrefs.constantDrain = Std.int(menuOption.min);
                }
                else if (FlxG.keys.justPressed.RIGHT && ClientPrefs.constantDrain != 0) {
                    ClientPrefs.constantDrain += 10;
                    if (ClientPrefs.constantDrain > menuOption.max) ClientPrefs.constantDrain = Std.int(menuOption.max);
                }
                if (FlxG.keys.justPressed.R)
                    ClientPrefs.constantDrain = 0;
            },
            valueFunc: function() {
                if (ClientPrefs.constantDrain != 0)
                    return Std.string(ClientPrefs.constantDrain) + "x";
                else
                    return "Disabled";
            }
        },
        {
            name: "Health Increase",
            description: "If health should slowly increase over time (multiplier)",
            type: INT,
            min: 10,
            max: 500,
            //conflicts: ["constantDrain"],
            updateFunc: function(menuOption:MenuOption, elapsed:Float) {
                if (FlxG.keys.justPressed.ENTER) {
                    ClientPrefs.constantDrain = 0;
                    if (ClientPrefs.constantHeal != 0)
                        ClientPrefs.constantHeal = 0;
                    else
                        ClientPrefs.constantHeal = 10;
                }
                else if (FlxG.keys.justPressed.LEFT && ClientPrefs.constantDrain != 0) {
                    ClientPrefs.constantHeal -= 10;
                    if (ClientPrefs.constantHeal < menuOption.min) ClientPrefs.constantHeal = Std.int(menuOption.min);
                }
                else if (FlxG.keys.justPressed.RIGHT && ClientPrefs.constantDrain != 0) {
                    ClientPrefs.constantHeal += 10;
                    if (ClientPrefs.constantHeal > menuOption.max) ClientPrefs.constantHeal = Std.int(menuOption.max);
                }
                if (FlxG.keys.justPressed.R)
                    ClientPrefs.constantHeal = 0;
            },
            valueFunc: function() {
                if (ClientPrefs.constantHeal != 0)
                    return Std.string(ClientPrefs.constantHeal) + "x";
                else
                    return "Disabled";
            }
        }
    ];
    var Items:Array<String> = ['Do A Barrel Roll', 'Fair Fight', 'Poison Plus'];
    var poisonPlusMinNum:Int = 0;
    var poisonPlusMaxNum:Int = 20;
    var curSubSelected:Int = 3;
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