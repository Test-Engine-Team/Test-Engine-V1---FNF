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

	//Keybinds
	public static var leftKeybinds:Array<FlxKey> = [FlxKey.A, FlxKey.LEFT];
	public static var downKeybinds:Array<FlxKey> = [FlxKey.S, FlxKey.DOWN];
	public static var upKeybinds:Array<FlxKey> = [FlxKey.W, FlxKey.UP];
	public static var rightKeybinds:Array<FlxKey> = [FlxKey.D, FlxKey.RIGHT];
	public static var resetKeybind:FlxKey = FlxKey.R;
	public static final controls:Controls = new Controls("player0", Solo);

	// Modifiers
	public static var spinnyspin:Bool = false;
	public static var fairFight:Bool = false;
	public static var poisonPlus:Bool = false;
	public static var maxPoisonHits:Int = 3;
	public static var fcMode:Bool = false;

	//easter eggs
	public static var tristanPlayer:Bool = false;

    //funny
    public static var tankmanFloat:Bool = false;

    public static function saveSettings() {
		for (setting in settingNames) {
			Reflect.setField(FlxG.save.data, setting, Reflect.getProperty(ClientPrefs, setting));
		}
		FlxG.save.data.framerate = framerate;

        FlxG.save.flush();

        var controlSave:FlxSave = new FlxSave();
		controlSave.bind('controls', 'Test-Engine-Save'); //Placing this in a separate save so that it can be manually deleted without removing your Score and stuff
		controlSave.data.leftBinds = leftKeybinds;
		controlSave.data.downBinds = downKeybinds;
		controlSave.data.upBinds = upKeybinds;
		controlSave.data.rightBinds = rightKeybinds;
		controlSave.data.resetBind = resetKeybind;
		controlSave.flush();
		controlSave.destroy();
    }

    public static function loadPrefs() {
		FlxG.save.bind('funkin', 'Test-Engine-Save');
		for (setting in settingNames) {
			var savedData = Reflect.field(FlxG.save.data, setting);
			if (savedData != null)
				Reflect.setProperty(ClientPrefs, setting, savedData);
		}

		var controlSave:FlxSave = new FlxSave();
		controlSave.bind('controls', 'Test-Engine-Save');
		if (controlSave.data.leftBinds != null) leftKeybinds = controlSave.data.leftBinds;
		if (controlSave.data.downBinds != null) downKeybinds = controlSave.data.downBinds;
		if (controlSave.data.upBinds != null) upKeybinds = controlSave.data.upBinds;
		if (controlSave.data.rightBinds != null) rightKeybinds = controlSave.data.rightBinds;
		if (controlSave.data.resetBind != null) resetKeybind = controlSave.data.resetBind;
		controlSave.destroy();

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