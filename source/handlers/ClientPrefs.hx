package handlers;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxSave;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

//Im not gonna rewrite the entirity of this,
//BUT WHO THE FUCK COPY PASTED CLIENTPREFS FROM PSYCH? -Srt

class ClientPrefs {
	//For load and save.
	static var settingNames:Array<String> = ["flashingLights", "spinnyspin", "fairFight", "poisonPlus", "fcMode", "maxPoisonHits", "limitMisses", "maxMisses", "freeplayCutscenes", "downscroll", "safeFrames", "botPlay", "practice", "speed", "ghostTapping", "showComboSprite", "antialiasing", "quality", "uiAlpha", "camMoveOnHit", "noteSplashes", "ogTitle", "fullscreen", "autoPause", "scoreMultiplier", "scoreTxt", "missTxt", "comboTxt", "noteHitTxt"];
	// Options
	public static var flashingLights:Bool = true; //this assumes this is true which is bad but i dunno how to make a popup on the start of the game like PE
    public static var ghostTapping:Bool = true;
	public static var framerate:Int = 60;
	public static var downscroll:Bool = false;
	public static var freeplayCutscenes:Bool = false;
	public static var safeFrames:Int = 10;
	public static var botPlay:Bool = false;
	public static var practice:Bool = false;
	public static var shitSystem:Bool = true;
	public static var camMoveOnHit:Bool = true;

	// Keybinds
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
	public static var limitMisses:Bool = false;
	public static var maxMisses:Int = 2;
	public static var speed:Int = 1;
	public static var noteSplashes:Bool = true;
	public static var constantDrain:Int = 0;
	public static var constantHeal:Int = 0;

	// Graphics
	public static var showComboSprite:Bool = true;
	public static var uiAlpha:Float = 1;
	public static var antialiasing:Bool = true;
	public static var ogTitle:Bool = false;
	public static var infoTxt:Bool = true;
	public static var quality:String = 'Medium';

	// Info Text stuff
	public static var scoreTxt:Bool = true;
	public static var missTxt:Bool = true;
	public static var comboTxt:Bool = true;
	public static var noteHitTxt:Bool = true;

	//easter eggs
	public static var tristanPlayer:Bool = false;
	public static var monikaGF:Bool = false;

    //funny
    public static var tankmanFloat:Bool = false;

	//Extra
	public static var fullscreen:Bool = false;
	public static var autoPause:Bool = true;
	public static var scoreMultiplier:Float = 1; //for future multiplier stuff

	// modifiable stuff for modding
	public static var fairFightHealthLossCount:Float = 0.02;
	public static var defaultFont:String = 'vcr';

    public static function saveSettings() {
		for (setting in settingNames) {
			Reflect.setField(FlxG.save.data, setting, Reflect.getProperty(ClientPrefs, setting));
		}
		FlxG.save.data.framerate = framerate;
		#if (flixel > "5.0.0")
		FlxSprite.defaultAntialiasing = antialiasing;
		#end

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
		#if (flixel > "5.0.0")
		FlxSprite.defaultAntialiasing = antialiasing;
		#end
    }
}