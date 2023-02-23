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

class InfoTextCustomizationMenu extends MusicBeatState {
	var maintextgroup:FlxTypedGroup<Alphabet>;
	var curSelected:Int = 0;
	var options:Array<MenuOption> = [
		{
			name: "Show Info Text",
			description: "if enabled, there will be info text that will give you information about how good you are doing",
			type: BOOL,
			min: 0,
			max: 1,
			// conflicts: null,
			updateFunc: function(menuOption:MenuOption, elapsed:Float) {
				if ([FlxG.keys.justPressed.ENTER, FlxG.keys.justPressed.LEFT, FlxG.keys.justPressed.RIGHT].contains(true))
					ClientPrefs.infoTxt = !ClientPrefs.infoTxt;
				if (FlxG.keys.justPressed.R)
					ClientPrefs.infoTxt = true;
			},
			valueFunc: function() {
				return (ClientPrefs.infoTxt) ? "Enabled" : "Disabled";
			}
		},
		{
			name: "Score Text",
			description: "Shows the song score",
			type: BOOL,
			min: 0,
			max: 1,
			// conflicts: null,
			updateFunc: function(menuOption:MenuOption, elapsed:Float) {
				if ([FlxG.keys.justPressed.ENTER, FlxG.keys.justPressed.LEFT, FlxG.keys.justPressed.RIGHT].contains(true)
					&& ClientPrefs.infoTxtX < 5) {
					ClientPrefs.scoreTxt = !ClientPrefs.scoreTxt;
				}
			},
			valueFunc: function() {
				return (ClientPrefs.scoreTxt) ? "Enabled" : "Disabled";
			}
		},
		{
			name: "Miss Text",
			description: "Shows the amount of misses you have",
			type: BOOL,
			min: 0,
			max: 1,
			// conflicts: null,
			updateFunc: function(menuOption:MenuOption, elapsed:Float) {
				if ([FlxG.keys.justPressed.ENTER, FlxG.keys.justPressed.LEFT, FlxG.keys.justPressed.RIGHT].contains(true)
					&& ClientPrefs.infoTxtX < 5) {
					ClientPrefs.missTxt = !ClientPrefs.missTxt;
				}
			},
			valueFunc: function() {
				return (ClientPrefs.missTxt) ? "Enabled" : "Disabled";
			}
		},
		{
			name: "Combo Text",
			description: "Shows the amount of combo hits you did",
			type: BOOL,
			min: 0,
			max: 1,
			// conflicts: null,
			updateFunc: function(menuOption:MenuOption, elapsed:Float) {
				if ([FlxG.keys.justPressed.ENTER, FlxG.keys.justPressed.LEFT, FlxG.keys.justPressed.RIGHT].contains(true)
					&& ClientPrefs.infoTxtX < 5) {
					ClientPrefs.comboTxt = !ClientPrefs.comboTxt;
				}
			},
			valueFunc: function() {
				return (ClientPrefs.comboTxt) ? "Enabled" : "Disabled";
			}
		},
		/*
		{
			name: "Accuracy Text",
			description: "Shows the accuracy of your hits",
			type: BOOL,
			min: 0,
			max: 1,
			// conflicts: null,
			updateFunc: function(menuOption:MenuOption, elapsed:Float) {
				if ([FlxG.keys.justPressed.ENTER, FlxG.keys.justPressed.LEFT, FlxG.keys.justPressed.RIGHT].contains(true)
					&& ClientPrefs.infoTxtX < 5) {
					ClientPrefs.accuracyTxt = !ClientPrefs.accuracyTxt;
				}
			},
			valueFunc: function() {
				return (ClientPrefs.accuracyTxt) ? "Enabled" : "Disabled";
			}
		},
		*/
		{
			name: "Notes Hit Text",
			description: "Shows the amount of notes you hit",
			type: BOOL,
			min: 0,
			max: 1,
			// conflicts: null,
			updateFunc: function(menuOption:MenuOption, elapsed:Float) {
				if ([FlxG.keys.justPressed.ENTER, FlxG.keys.justPressed.LEFT, FlxG.keys.justPressed.RIGHT].contains(true)
					&& ClientPrefs.infoTxtX < 5) {
					ClientPrefs.noteHitTxt = !ClientPrefs.noteHitTxt;
				}
			},
			valueFunc: function() {
				return (ClientPrefs.noteHitTxt) ? "Enabled" : "Disabled";
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

	override public function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE)
			FlxG.switchState(new GraphicsMenu());

		if (FlxG.keys.justPressed.BACKSPACE)
			FlxG.switchState(new GraphicsMenu());

		if (controls.UP_P || controls.DOWN_P) {
			changeSelection((controls.UP_P) ? -1 : 1);
		}
		options[curSelected].updateFunc(options[curSelected], elapsed);
		valueTxt.text = "< " + options[curSelected].valueFunc() + " >";

		#if debug
		descTxt.text = options[curSelected].description;
		for (item in maintextgroup.members) {
			descTxt.text += "Y: " + item.y + " | TargetY: " + item.targetY + '\n';
		}
		#end
	}

	function changeSelection(change:Int = 0):Void {
		curSelected += change;

		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in maintextgroup.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = (item.targetY == 0) ? 1 : 0.6;
		}

		descTxt.text = options[curSelected].description;

		if (change != 0)
			FlxG.sound.play(Files.sound('scrollMenu'), 0.4);
	}
}
