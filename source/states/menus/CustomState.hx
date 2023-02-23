package states.menus;

import scriptStuff.HiScript;
import handlers.MusicBeatState;

class CustomState extends MusicBeatState {
	#if SCRIPTS_ENABLED
	var script:HiScript;

	override public function create() {
		super.create();

		script = new HiScript('states/${handlers.CoolUtil.state}');
		if (!script.isBlank && script.expr != null) {
			script.interp.scriptObject = this;
			script.setValue("yooo", true);
			script.interp.execute(script.expr);
		}
		script.callFunction("create");

		script.callFunction("createPost");
	}
	#end

	override public function update(elapsed:Float) {
		super.update(elapsed);

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
