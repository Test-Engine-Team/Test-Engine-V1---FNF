package states.menus;

import flixel.FlxG;
import flixel.text.FlxText;
import scriptStuff.HiScript;
import handlers.MusicBeatState;

class HScriptTestState extends MusicBeatState {
    #if SCRIPTS_ENABLED
    var script:HiScript;
    public var outsideTxt:FlxText;

    override public function create() {
        super.create();

        script = new HiScript("assets/testScript");
        if (!script.isBlank && script.expr != null) {
            script.interp.scriptObject = this;
            script.setValue("yooo", true);
            script.interp.execute(script.expr);
        }
        script.callFunction("create");

        outsideTxt = new FlxText(10, 10, 0, "This is a variable inside the class to test accessing outside vars.", 16);
        add(outsideTxt);

        script.callFunction("createPost");
    }
    #end

    override public function update(elapsed:Float) {
        super.update(elapsed);

        if (FlxG.keys.justPressed.BACKSPACE)
            FlxG.switchState(new states.menus.MainMenuState());

        #if SCRIPTS_ENABLED script.callFunction("update", [elapsed]); #end
    }

    #if SCRIPTS_ENABLED
    override public function stepHit() {
        super.stepHit();
        script.callFunction("stepHit");
    }

    override public function beatHit() {
        super.beatHit();
        script.callFunction("beatHit");
    }
    #end
}