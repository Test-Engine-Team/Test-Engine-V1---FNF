package scriptStuff;

import hscript.Expr.Error;
import openfl.Assets;
import hscript.*;

using StringTools;

//This is used for well, softcoded scripting.
//The reason it looks so similar to Yoshman's HScript class is because I used it as an example for hscript.
//BUT YOSHMAN I SWEAR ON MY LIFE I DID NOT COPY PASTE YOUR HSCRIPT CLASS I SWEAR
class HiScript {
    public static var parser:Parser;
    public static var staticVars:Map<String, Dynamic> = new Map();
    public var interp:Interp;
    public var expr:Expr;
    public var isBlank:Bool;
    var blankVars:Map<String, Null<Dynamic>>;

    var defaultVars:Map<String, Dynamic> = [
        "FlxG" => flixel.FlxG,
        "FlxSprite" => flixel.FlxSprite,

        "Paths" => handlers.Files,
        "Files" => handlers.Files,
        "Conductor" => handlers.Conductor,

        "Assets" => Assets
    ];

    public function new(scriptPath:String) {
        if (!scriptPath.startsWith("assets")) scriptPath = "assets/" + scriptPath;
        var boolArray:Array<Bool> = [for (ext in ["hx", "hscript", "hxs"]) Assets.exists('$scriptPath.$ext')];
        isBlank = (!boolArray.contains(true));
        if (boolArray.contains(true)) {
            interp = new Interp();
            interp.staticVariables = staticVars;
            interp.allowStaticVariables = true;
            interp.allowPublicVariables = true;
            try {
                var exts:Array<String> = ["hx", "hscript", "hxs"];
                var path = scriptPath + "." + exts[boolArray.indexOf(true)];
                expr = parser.parseString(Assets.getText(path));
            } catch (e) {
                /*codename uses two error catches so i might be learning that.
                for parse errors i wanna make it a pop up.
                lime.app.Application.current.window.alert('Looks like the game couldn\'t parse your hscript file.\n$scriptPath\n$errorMessage', 'Failed to Parse $scriptPath');*/
                isBlank = true;
            }
        }
        if (isBlank) {
            blankVars = new Map();
        } else {
            for (va in defaultVars.keys())
                setValue(va, defaultVars[va]);
        }
    }

    public function callFunction(name:String, ?params:Array<Dynamic>) {
        var functionVar = (isBlank) ? blankVars.get(name) : interp.variables.get(name);
        var hasParams = (params != null && params.length > 0);
        if (functionVar == null || !Reflect.isFunction(functionVar)) return null;
        return hasParams ? Reflect.callMethod(null, functionVar, params) : functionVar();
    }

    public function getValue(name:String)
        return (isBlank) ? blankVars.get(name) : interp.variables.get(name);

    public function setValue(name:String, value:Dynamic)
        if (isBlank) blankVars.set(name, value) else interp.variables.set(name, value);
}