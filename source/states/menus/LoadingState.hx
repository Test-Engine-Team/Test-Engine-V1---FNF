package states.menus;

/*
plz don't mess with this yet.
iss wip.

as of right now, all it does is just set stuff in a data var.
soon ill make it so the states utilize this class.
*/

import openfl.display.Stage3D;
import flixel.util.FlxColor;
import flixel.FlxG;
import handlers.MusicBeatState;
import openfl.Assets;
#if MODS_ENABLED
import openfl.events.UncaughtErrorEvent;
import polymod.Polymod;
import sys.FileSystem;
import sys.io.File;
#end

using StringTools;

typedef ModDataYee = {
    var titleBar:String;
    var weekList:Array<ModWeekYee>;
    var selectColor:FlxColor;
}

typedef MenuCharData = {
    var spritePath:String;
    var idleAnim:String;
    var confirmAnim:Null<String>;
    var scale:Float;
    var xOffset:Float;
    var yOffset:Float;
    var flipX:Bool;
}

typedef ModWeekYee = {
    var name:String;
    var spriteImage:String;
    var songs:Array<String>;
    var paths:Array<String>;
    var icons:Array<String>;
    var diffs:Array<String>;
    var chars:Array<MenuCharData>;
}

class LoadingState extends MusicBeatState {
    public static var addedCrash:Bool = false;
    public static var modData:ModDataYee = {
        titleBar: "Friday Night Funkin' - Test Engine",
        weekList: [],
        selectColor: 0xFF00B386
    }; //It gets set in create so no need to fill this.

    private final defaultBF:MenuCharData = {
        spritePath: "campaign_menu_UI_characters",
        idleAnim: "BF idle",
        confirmAnim: "BF HEY!",
        scale: 0.9,
        xOffset: 80,
        yOffset: 0,
        flipX: true
    };

    private final defaultGF:MenuCharData = {
        spritePath: "campaign_menu_UI_characters",
        idleAnim: "GF",
        confirmAnim: null,
        scale: 0.5,
        xOffset: 0,
        yOffset: 0,
        flipX: false
    };

    override public function create() {
        modData = {
            titleBar: "Friday Night Funkin' - Test Engine",
            weekList: [
                {
                    name: "Tutorial",
                    spriteImage: "tutorial",
                    songs: ["Tutorial"],
                    paths: ["tutorial"],
                    icons: ["gf"],
                    diffs: ["Easy", "Normal", "Hard"],
                    chars: [{
                        spritePath: "campaign_menu_UI_characters",
                        idleAnim: "Dad",
                        confirmAnim: null,
                        scale: 0.5,
                        xOffset: 20,
                        yOffset: 100,
                        flipX: false
                    }, defaultGF, defaultBF]
                },
                {
                    name: "DADDY DEAREST",
                    spriteImage: "week1",
                    songs: ["Bopeebo", "Fresh", "Dadbattle"],
                    paths: ["bopeebo", "fresh", "dadbattle"],
                    icons: ["dad", "dad", "dad"],
                    diffs: ["Easy", "Normal", "Hard"],
                    chars: [{
                        spritePath: "campaign_menu_UI_characters",
                        idleAnim: "Dad",
                        confirmAnim: null,
                        scale: 0.5,
                        xOffset: 20,
                        yOffset: 100,
                        flipX: false
                    }, defaultGF, defaultBF]
                },
                {
                    name: "Spooky Month",
                    spriteImage: "week2",
                    songs: ["Spookeez", "South", "Monster"],
                    paths: ["spookeez", "south", "monster"],
                    icons: ["spooky", "spooky", "monster"],
                    diffs: ["Easy", "Normal", "Hard"],
                    chars: [{
                        spritePath: "campaign_menu_UI_characters",
                        idleAnim: "spooky",
                        confirmAnim: null,
                        scale: 0.6,
                        xOffset: 0,
                        yOffset: 130,
                        flipX: false
                    }, defaultGF, defaultBF]
                },
                {
                    name: "PICO",
                    spriteImage: "week3",
                    songs: ["Pico", "Philly", "Blammed"],
                    paths: ["pico", "philly", "blammed"],
                    icons: ["pico", "pico", "pico"],
                    diffs: ["Easy", "Normal", "Hard"],
                    chars: [{
                        spritePath: "campaign_menu_UI_characters",
                        idleAnim: "Pico",
                        confirmAnim: null,
                        scale: 0.7,
                        xOffset: 0,
                        yOffset: 130,
                        flipX: true
                    }, defaultGF, defaultBF]
                },
                {
                    name: "MOMMY MUST MURDER",
                    spriteImage: "week4",
                    songs: ["Satin-Panties", "High", "MILF"],
                    paths: ["satin-panties", "high", "milf"],
                    icons: ["mom", "mom", "mom"],
                    diffs: ["Easy", "Normal", "Hard"],
                    chars: [{
                        spritePath: "campaign_menu_UI_characters",
                        idleAnim: "Mom",
                        confirmAnim: null,
                        scale: 0.5,
                        xOffset: 70,
                        yOffset: 100,
                        flipX: false
                    }, defaultGF, defaultBF]
                },
                {
                    name: "RED SNOW",
                    spriteImage: "week5",
                    songs: ["Cocoa", "Eggnog", "Winter-Horrorland"],
                    paths: ["cocoa", "eggnog", "winter-horrorland"],
                    icons: ["parents-christmas", "parents-christmas", "monster"],
                    diffs: ["Easy", "Normal", "Hard"],
                    chars: [{
                        spritePath: "campaign_menu_UI_characters",
                        idleAnim: "Parent",
                        confirmAnim: null,
                        scale: 0.5,
                        xOffset: -100,
                        yOffset: 100,
                        flipX: false
                    }, defaultGF, defaultBF]
                },
                {
                    name: "HATING SIMULATOR FT. MOAWLING",
                    spriteImage: "week6",
                    songs: ["Senpai", "Roses", "Thorns"],
                    paths: ["senpai", "roses", "thorns"],
                    icons: ["senpai", "senpai", "spirit"],
                    diffs: ["Easy", "Normal", "Hard"],
                    chars: [{
                        spritePath: "campaign_menu_UI_characters",
                        idleAnim: "SENPAI idle",
                        confirmAnim: null,
                        scale: 1,
                        xOffset: 0,
                        yOffset: 150,
                        flipX: false
                    }, defaultGF, defaultBF]
                },
                {
                    name: "TANKMAN",
                    spriteImage: "week7",
                    songs: ["Ugh", "Guns", "Stress"],
                    paths: ["ugh", "guns", "stress"],
                    icons: ["tankman", "tankman", "tankman"],
                    diffs: ["Easy", "Normal", "Hard"],
                    chars: [{
                        spritePath: "campaign_menu_UI_characters",
                        idleAnim: "Tankman",
                        confirmAnim: null,
                        scale: 1,
                        xOffset: 50,
                        yOffset: 150,
                        flipX: false
                    }, defaultGF, defaultBF]
                }
            ],
            selectColor: 0xFF00B386
        };

        #if MODS_ENABLED
        var modsToLoad = ["+BASE+"];

        if (!FileSystem.exists("./mods")) {
            FileSystem.createDirectory("./mods");
            File.saveContent("./mods/currentMod.txt", "");
        } else if (!FileSystem.exists("./mods/currentMod.txt"))
            File.saveContent("./mods/currentMod.txt", "");

        var currentMod:String = File.getContent("./mods/currentMod.txt").trim();
        if (currentMod != null && currentMod != "") modsToLoad.push(currentMod);

        Polymod.init({modRoot: "mods/", dirs: modsToLoad});
        if (Assets.exists("assets/modData.xml")) {
            var xml:Xml = Xml.parse(Assets.getText("assets/modData.xml")).firstElement();

            if (xml.get("titleBarName") != null) modData.titleBar = xml.get("titleBarName");
            var xmlWeeks = xml.elementsNamed("week");
            if (xmlWeeks != null && xmlWeeks.hasNext()) {
                modData.weekList = [];
                for (week in xmlWeeks) {
                    modData.weekList.push(addModWeek(week));
                }
            }

            var color:String = xml.get("color");
            if (color != null)
                modData.selectColor = (color.startsWith("#") || color.startsWith("0x")) ? FlxColor.fromString(color) : FlxColor.fromString("#" + color);
        }
        #end
        #if desktop
        if (!addedCrash) {
            openfl.Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, errorPopup);
            addedCrash = true;
        }
        #end
        states.menus.TitleState.seenIntro = false;
        FlxG.switchState(new states.menus.TitleState());
    }

    #if desktop
    function addModWeek(week:Xml) {
        var modWeek:ModWeekYee = {
            name: "UNKNOWN WEEK NAME",
            spriteImage: "week1",
            songs: ["Test"],
            paths: ["test"],
            icons: ["face"],
            diffs: ["Easy", "Normal", "Hard"],
            chars: [{
                spritePath: "campaign_menu_UI_characters",
                idleAnim: "Dad",
                confirmAnim: null,
                scale: 0.5,
                xOffset: 20,
                yOffset: 100,
                flipX: false
            }, defaultGF, defaultBF]
        };
        if (week.get("name") != null) modWeek.name = week.get("name");
        if (week.get("image") != null) modWeek.spriteImage = week.get("image");
        if (week.get("songs") != null) modWeek.songs = [for (song in week.get("songs").split(",")) song.trim()];
        if (week.get("songPaths") != null) modWeek.paths = [for (path in week.get("songPaths").split(",")) path.trim()];
        if (week.get("icons") != null) modWeek.icons = [for (icon in week.get("icons").split(",")) icon.trim()];
        if (week.get("diffs") != null) modWeek.diffs = [for (diff in week.get("diffs").split(",")) diff.trim()];
        var xmlChars = week.elementsNamed("char");
        if (xmlChars != null && xmlChars.hasNext()) {
            modWeek.chars = [];
            for (char in xmlChars) {
                modWeek.chars.push(addModChar(char));
            }
        }
        return modWeek;
    }

    function addModChar(charXml:Xml) {
        var charData:MenuCharData = {
            spritePath: "campaign_menu_UI_characters",
            idleAnim: "Dad",
            confirmAnim: null,
            scale: 0.5,
            xOffset: 20,
            yOffset: 100,
            flipX: false
        };
        if (charXml.get("default") != null) {
            switch (charXml.get("default").toLowerCase()) {
                case "bf" | "boyfriend": return defaultBF;
                case "gf" | "girlfriend": return defaultGF;
                case "dad": return charData;
            }
        }

        if (charXml.get("path") != null) charData.spritePath = charXml.get("path");
        if (charXml.get("idle") != null) charData.idleAnim = charXml.get("idle");
        if (charXml.get("confirm") != null) charData.confirmAnim = charXml.get("confirm");
        if (charXml.get("scale") != null) charData.scale = Std.parseFloat(charXml.get("scale"));
        if (charXml.get("xOffset") != null) charData.xOffset = Std.parseFloat(charXml.get("xOffset"));
        if (charXml.get("yOffset") != null) charData.yOffset = Std.parseFloat(charXml.get("yOffset"));
        if (charXml.get("flipX") != null) charData.flipX = (charXml.get("flipX") == "true");

        return charData;
    }

    function errorPopup(error:UncaughtErrorEvent) {
        var errorMessage:String = switch ([Std.isOfType(error.error, openfl.errors.Error), Std.isOfType(error.error, openfl.events.ErrorEvent), true].indexOf(true)) {
			case 0: "Uncaught Error: " + cast(error.error, openfl.errors.Error).message;
			case 1: "Uncaught Error: " + cast(error.error, openfl.events.ErrorEvent).text;
			default: "Uncaught Error: " + error.error;
		}
        var message:String = "Looks like the game crashed.\n" + errorMessage + "\n\n";

		for (stackItem in haxe.CallStack.exceptionStack(true)) {
			switch (stackItem) {
                case CFunction: message += "Called from C Function";
                case Module(module): message += 'Called from $module (Module)';
                case FilePos(parent, file, line, col): message += 'Called from $file on line $line';
                case LocalFunction(func): message += 'Called from $func (Local Function)';
                case Method(clas, method): message += 'Called from $clas - $method()';
			}
			message += "\n";
		}
        message += "\nTest Engine could always be better.\n\nPlease report this crash at\nhttps://github.com/504brandon/Test-Engine-V1---FNF";

        lime.app.Application.current.window.alert(message, errorMessage);
        Sys.exit(1);
    }
    #end
}