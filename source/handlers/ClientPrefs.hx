package handlers;

import flixel.FlxG;
import flixel.util.FlxSave;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

//Im not gonna rewrite the entirity of this,
//BUT WHO THE FUCK COPY PASTED CLIENTPREFS FROM PSYCH? -Srt

class ClientPrefs {
	//For load and save.
	static var settingNames:Array<String> = ["spinnyspin", "fairFight", "poisonPlus", "maxPoisonHits", "freeplayCutscenes", "downscroll", "safeFrames", "ghostTapping", "showComboSprite", "antialiasing"];

	// Options
    public static var ghostTapping:Bool = true;
	public static var showComboSprite:Bool = true;
	public static var framerate:Int = 60;
	public static var downscroll:Bool = false;
	public static var freeplayCutscenes:Bool = false;
	public static var safeFrames:Int = 10;

	//Optimization
	public static var antialiasing:Bool = true;

	// Modifiers
	public static var spinnyspin:Bool = false;
	public static var fairFight:Bool = false;
	public static var poisonPlus:Bool = false;
	public static var maxPoisonHits:Int = 3;

	//easter eggs
	public static var tristanPlayer:Bool = false;

    //funny
    public static var tankmanFloat:Bool = false;
    
    //Every key has two binds, add your key bind down here and then add your control on options and Controls.hx
	public static var keyBinds:Map<String, Array<FlxKey>> = [
		'note_left'		=> [W, LEFT],
		'note_down'		=> [A, DOWN],
		'note_up'		=> [S, UP],
		'note_right'	=> [D, RIGHT],
		
		'ui_left'		=> [W, LEFT],
		'ui_down'		=> [A, DOWN],
		'ui_up'			=> [S, UP],
		'ui_right'		=> [D, RIGHT],
		
		'accept'		=> [SPACE, ENTER],
		'back'			=> [BACKSPACE, ESCAPE],
		'pause'			=> [ENTER, ESCAPE],
		'reset'			=> [R, NONE],
		
		'volume_mute'	=> [ZERO, NONE],
		'volume_up'		=> [NUMPADPLUS, PLUS],
		'volume_down'	=> [NUMPADMINUS, MINUS],
		
		'debug_1'		=> [SEVEN, NONE],
		'debug_2'		=> [EIGHT, NONE]
	];
	public static var defaultKeys:Map<String, Array<FlxKey>> = null;

	public static function loadDefaultKeys() {
		defaultKeys = keyBinds.copy();
		//trace(defaultKeys);
	}

    public static function saveSettings() {
		for (setting in settingNames) {
			Reflect.setField(FlxG.save.data, setting, Reflect.getProperty(ClientPrefs, setting));
		}

        FlxG.save.flush();

        var save:FlxSave = new FlxSave();
		save.bind('controls_v2', 'ninjamuffin99'); //Placing this in a separate save so that it can be manually deleted without removing your Score and stuff
		save.data.customControls = keyBinds;
		save.flush();
		FlxG.log.add("Settings saved!");
    }

    public static function loadPrefs() {
		for (setting in settingNames) {
			var savedData = Reflect.field(FlxG.save.data, setting);
			if (savedData != null)
				Reflect.setProperty(ClientPrefs, setting, savedData);
		}

		if(FlxG.save.data.framerate != null) {
			framerate = FlxG.save.data.framerate;
			if(framerate > FlxG.drawFramerate) {
				FlxG.updateFramerate = framerate;
				FlxG.drawFramerate = framerate;
			} else {
				FlxG.drawFramerate = framerate;
				FlxG.updateFramerate = framerate;
			}
		}
    }
}