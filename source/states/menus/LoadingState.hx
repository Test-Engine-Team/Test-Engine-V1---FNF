package states.menus;

/*
plz don't mess with this.
imma mess with it anyway -504brandon 2022
*/
import handlers.CoolUtil;
import lime.graphics.Image;
import handlers.Files;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import handlers.MusicBeatState;
import openfl.Assets;
import states.menus.TitleState;
#if MODS_ENABLED
import openfl.events.UncaughtErrorEvent;
import polymod.Polymod;
import sys.FileSystem;
import sys.io.File;
import lime.app.Application;
#end
#if SCRIPTS_ENABLED
import scriptStuff.HiScript;
#end

using StringTools;

typedef ModDataYee = {
    var titleBar:String;
    var weekList:Array<ModWeekYee>;
    var charList:Array<GameCharData>;
    var charNames:Array<String>;
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

typedef GameCharData = {
    var spriteImage:String;
    var iconImage:String;
    var anims:Array<GameCharAnim>;
    var offsets:Array<Float>;
    var scale:Float;
    var scaleAffectsOffset:Bool;
    var flipX:Bool;
    var antialiasing:Bool;
    var singDur:Float;
    var regCharType:String;
    var hpColor:Null<FlxColor>;
}

//It's worrying how close this is to psych.
typedef GameCharAnim = {
    var name:String;
    var prefix:String;
    var looped:Bool;
    var fps:Int;
    var offsets:Array<Float>;
    var indices:Array<Int>;
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
        charList: [],
        charNames: [],
        selectColor: 0xFF00B386
    }; //It gets set in create so no need to fill this.
    #if MODS_ENABLED
    public static var targetState:Class<flixel.FlxState> = TitleState;
    #end

    private static var defaultModData:ModDataYee = {
        titleBar: "Friday Night Funkin' - Test Engine",
        weekList: [],
        charList: [],
        charNames: [],
        selectColor: 0xFF00B386
    };

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
        super.create();

        var menuBG:FlxSprite = new FlxSprite(0, 0, openfl.Assets.getBitmapData(Files.image("menus/loadingScreen")));
        add(menuBG);

        var modLoadingTxt:FlxText = new FlxText(1270, 715, 0, "Parsing Base Mod Data", 30);
        modLoadingTxt.setFormat("VCR OSD Mono", 30, 0xFF120024, "right", FlxTextBorderStyle.OUTLINE, 0xFF5900FF);
        modLoadingTxt.borderSize = 2;
        modLoadingTxt.x -= modLoadingTxt.width;
        modLoadingTxt.y -= modLoadingTxt.height;
        add(modLoadingTxt);

        if (!addedCrash) { //Parse default mod data.
            var daModData:ModDataYee = {
                titleBar: "Friday Night Funkin' - Test Engine",
                weekList: [],
                charList: [],
                charNames: [],
                selectColor: 0xFF00B386
            };

            var defaultXml:Xml = Xml.parse(Assets.getText("assets/embedData/defaultModData.xml")).firstElement();

            if (defaultXml.get("titleBarName") != null) daModData.titleBar = defaultXml.get("titleBarName");
            var xmlWeeks = defaultXml.elementsNamed("week");
            if (xmlWeeks != null && xmlWeeks.hasNext()) {
                daModData.weekList = [];
                for (week in xmlWeeks) {
                    daModData.weekList.push(addModWeek(week));
                }
            }

            var color:String = defaultXml.get("color");
            if (color != null)
                daModData.selectColor = (color.startsWith("#") || color.startsWith("0x")) ? FlxColor.fromString(color) : FlxColor.fromString("#" + color);

            for (xmlPath in ["embedData/allDefaultBF", "embedData/allDefaultGF", "embedData/defaultChars"]) {
                var daCharList = parseCharList(Xml.parse(Assets.getText('assets/$xmlPath.xml')));
                for (charName in daCharList.keys()) {
                    daModData.charNames.push(charName);
                    daModData.charList.push(daCharList[charName]);
                }
            }

            defaultModData = daModData;
            //Load Data
            handlers.ClientPrefs.loadPrefs();
            handlers.Highscore.load();

            #if sys
            if (Assets.exists('assets/images/monkie.png'))
                trace('good you have monkie');
            else{
                trace('Y O U W I L L R E G R E T T H A T');
                handlers.CoolUtil.error('DID YOU DELETE MONKIE', '...');
                Sys.exit(0);
            }
            #end

            #if SCRIPTS_ENABLED
            HiScript.parser = new hscript.Parser();
            HiScript.parser.allowJSON = true;
            HiScript.parser.allowMetadata = true;
            HiScript.parser.allowTypes = true;
            HiScript.parser.preprocesorValues = [
                "buildVer" => Application.current.meta.get('version'),
                "desktop" => #if (desktop) true #else false #end,
                "windows" => #if (windows) true #else false #end,
                "mac" => #if (mac) true #else false #end,
                "linux" => #if (linux) true #else false #end,
                "debugBuild" => #if (debug) true #else false #end
            ];
            #end
        }

        modData = Reflect.copy(defaultModData);

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
            modLoadingTxt.text = 'Parsing Mod Data For "' + currentMod + '"';
            modLoadingTxt.x = 1270 - modLoadingTxt.width;
            modLoadingTxt.y = 715 - modLoadingTxt.height;

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
                modData.selectColor = CoolUtil.stringColor(color);

            var charPathList = (xml.get("charXmlPaths") != null) ? [for (path in xml.get("charXmlPaths").split("|")) path.trim()] : [];
            if (charPathList.length > 0) {
                for (xmlPath in charPathList) {
                    var daCharList = parseCharList(Xml.parse(Assets.getText('assets/$xmlPath.xml')));
                    for (charName in daCharList.keys()) {
                        if (modData.charNames.contains(charName)) {
                            modData.charList[modData.charNames.indexOf(charName)] = daCharList[charName];
                            continue;
                        }
                        modData.charNames.push(charName);
                        modData.charList.push(daCharList[charName]);
                    }
                }
            }
        }
        #end
        #if desktop
        trace(currentMod);
        Application.current.window.title = modData.titleBar;
        Application.current.window.setIcon(Image.fromBitmapData(Assets.getBitmapData(Files.image('icon'))));
        if (!addedCrash)
            openfl.Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, errorPopup);
        #end
        addedCrash = true;

        modLoadingTxt.text = 'Finished parsing. Have fun!';
        modLoadingTxt.x = 1270 - modLoadingTxt.width;
        modLoadingTxt.y = 715 - modLoadingTxt.height;

        new flixel.util.FlxTimer().start(0.5, function(tmr:flixel.util.FlxTimer) {
            #if MODS_ENABLED
            if (targetState == TitleState) {
                TitleState.seenIntro = false;
                FlxG.switchState(new TitleState());
            } else
                FlxG.switchState(Type.createInstance(targetState, []));

            targetState = TitleState;
            #else
            TitleState.seenIntro = false;
            FlxG.switchState(new TitleState());
            #end
        });
    }

    function parseCharList(xml:Xml) {
        var charList:Map<String, GameCharData> = [];
        for (char in xml.elementsNamed("char")) {
            var charName = (char.get("name") != null) ? char.get("name") : "bf";
            var modChar:GameCharData = {
                spriteImage: "BOYFRIEND",
                iconImage: "bf",
                anims: [{
                    name: "idle",
                    prefix: "BF idle dance",
                    looped: false,
                    fps: 24,
                    offsets: [-5, 0],
                    indices: []
                }],
                offsets: [0, 350, 0, 0],
                scale: 1,
                scaleAffectsOffset: false,
                flipX: true,
                antialiasing: true,
                singDur: 4,
                regCharType: "bf",
                hpColor: null
            };
            if (char.get("spriteImage") != null) modChar.spriteImage = char.get("spriteImage");
            if (char.get("iconImage") != null) modChar.iconImage = char.get("iconImage");
            if (char.get("regCharType") != null) modChar.regCharType = char.get("regCharType");

            var offsetArray:Array<String> = [];
            if (char.get("offsets") != null) offsetArray = char.get("offsets").split(",");
            if (offsetArray.length > 1) {
                for (i in 0...2)
                    modChar.offsets[i] = Std.parseFloat(offsetArray[i].trim());
            }
            offsetArray = [];
            if (char.get("camOffsets") != null) offsetArray = char.get("camOffsets").split(",");
            if (offsetArray.length > 1) {
                for (i in 0...2)
                    modChar.offsets[i + 2] = Std.parseFloat(offsetArray[i].trim());
            }

            if (char.get("scale") != null) modChar.scale = Std.parseFloat(char.get("scale"));
            if (char.get("singDur") != null) modChar.singDur = Std.parseFloat(char.get("singDur"));

            if (char.get("scaleAffectsOffset") != null) modChar.scaleAffectsOffset = (char.get("scaleAffectsOffset") == "true");
            if (char.get("flipX") != null) modChar.flipX = (char.get("flipX") == "true");
            if (char.get("antialiasing") != null) modChar.antialiasing = (char.get("antialiasing") == "true");

            var xmlAnims = char.elementsNamed("animData");
            if (xmlAnims != null && xmlAnims.hasNext()) {
                modChar.anims = [];
                for (anim in xmlAnims) {
                    modChar.anims.push(addCharAnim(anim));
                }
            }

            var color:String = char.get("hpColor");
            if (color != null)
                modChar.hpColor = CoolUtil.stringColor(color);

            charList.set(charName, modChar);
        }
        return charList;
    }

    function addCharAnim(anim:Xml) {
        var charAnim:GameCharAnim = {
            name: "idle",
            prefix: "BF idle dance",
            looped: false,
            fps: 24,
            offsets: [-5, 0],
            indices: []
        };

        if (anim.get("name") != null) charAnim.name = anim.get("name");
        if (anim.get("prefix") != null) charAnim.prefix = anim.get("prefix");
        if (anim.get("looped") != null) charAnim.looped = (anim.get("looped") == "true");
        if (anim.get("fps") != null) charAnim.fps = Std.parseInt(anim.get("fps"));

        var offsetArray:Array<String> = [];
        if (anim.get("offsets") != null) offsetArray = anim.get("offsets").split(",");
        if (offsetArray.length > 1) {
            for (i in 0...offsetArray.length)
                charAnim.offsets[i] = Std.parseFloat(offsetArray[i].trim());
        }
        
        var indiceArray:Array<String> = [];
        if (anim.get("indices") != null) indiceArray = anim.get("indices").split(",");
        if (indiceArray.length > 0) {
            for (i in 0...indiceArray.length)
                charAnim.indices.push(Std.parseInt(indiceArray[i].trim()));
        }

        return charAnim;
    }

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
                modWeek.chars.push(addWeekChar(char));
            }
        }
        return modWeek;
    }

    function addWeekChar(charXml:Xml) {
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

    #if desktop
    function errorPopup(error:UncaughtErrorEvent) {
        FlxG.fullscreen = false;
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

        Application.current.window.alert(message, errorMessage);
        Sys.exit(1);
    }
    #end
}