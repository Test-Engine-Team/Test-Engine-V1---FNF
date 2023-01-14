package states.etc.cutscenes;

import states.mainstates.PlayState;
import scriptStuff.HiScript;

class ScriptCutscene extends handlers.MusicBeatSubstate {
    public var script:HiScript;
    var psInstance:PlayState;

    public function new(path:String, finishCallback:Void->Void, ?playstateInst:PlayState) {
        super();
        if (playstateInst != null)
            psInstance = playstateInst;
        finishCutscene = function() {
            close();
            finishCallback();
        }
        #if SCRIPTS_ENABLED
        script = new HiScript(path);
        if (!script.isBlank && script.expr != null) {
            script.interp.scriptObject = psInstance;
            script.setValue("cutsceneSubstate", this);
            script.setValue("add", add);
            script.setValue("insert", insert);
            script.setValue("remove", remove);
            script.setValue("finishCutscene", finishCutscene);
            script.interp.execute(script.expr);
        }
        script.callFunction("create");
        #end
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
        #if (SCRIPTS_ENABLED)
        script.callFunction("update", [elapsed]);
        #else
        finishCutscene();
        #end
    }

    #if SCRIPTS_ENABLED
    override public function stepHit() {
        super.stepHit();
        script.callFunction("stepHit");
    }
    #end

    override public function beatHit() {
        super.beatHit();
        if (psInstance != null) {
            for (char in [psInstance.boyfriend, psInstance.gf, psInstance.dad])
                char.dance();
        }
        #if SCRIPTS_ENABLED script.callFunction("beatHit"); #end
    }

    public dynamic function finishCutscene() {
        close();
    }
}