package ui;

import haxe.Log;
import haxe.PosInfos;
import openfl.ui.Keyboard;
import openfl.events.KeyboardEvent;
import openfl.text.TextFormat;
import openfl.text.TextField;
import openfl.display.Sprite;

class LogHandler extends Sprite {
    var regularTrace:(v:Dynamic, ?infos:Null<PosInfos>) -> Void;
    public var logLimit:Int = 50;
    var logText:TextField;
    var traces:Int = 0;

    public function new() {
        super();
        x = 0; y = 0;

        logText = new TextField();
        logText.x = 10;
        logText.y = 10;
        logText.autoSize = LEFT;
        logText.selectable = false;
        logText.textColor = 0xFFFFFFFF;
        logText.defaultTextFormat = new TextFormat("VCR OSD Mono", 14, 0xFFFFFFFF);
        addChild(logText);

        visible = false;

        regularTrace = Log.trace;
        Log.trace = traceInLog;

        flixel.FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, function(e:KeyboardEvent) {
            if (e.keyCode == Keyboard.F2 || e.keyCode == Keyboard.BACKSLASH)
                visible = !visible;
            if (e.keyCode == Keyboard.F3 && visible) {
                traces = 0;
                logText.text = "";
            }
        });
    }

    function traceInLog(v:Dynamic, ?infos:PosInfos) {
        regularTrace(v, infos);
        logText.text += Log.formatOutput(v, infos) + "\n";
        traces++;
        if (traces <= logLimit) return;
        var splitLog:Array<String> = logText.text.split("\n");
        var tracesToRemove:Int = splitLog.length - logLimit;
        splitLog.splice(0, tracesToRemove);
        logText.text = splitLog.join("\n");
        traces -= tracesToRemove;
    }

    public function hscriptTrace(string:String) {
        #if js
		if (js.Syntax.typeof(untyped console) != "undefined" && (untyped console).log != null)
			(untyped console).log(string);
		#elseif lua
		untyped __define_feature__("use._hx_print", _hx_print(string));
		#elseif sys
		Sys.println(string);
		#end
        logText.text += string + "\n";
        traces++;
        if (traces <= logLimit) return;
        var splitLog:Array<String> = logText.text.split("\n");
        var tracesToRemove:Int = splitLog.length - logLimit;
        splitLog.splice(0, tracesToRemove);
        logText.text = splitLog.join("\n");
        traces -= tracesToRemove;
    }

    public override function __enterFrame(deltaTime:Int) {
        super.__enterFrame(deltaTime);

        graphics.clear();
        graphics.beginFill(0x000000, 0.4);
        var daWidth:Float = Math.max(logText.textWidth + 40, lime.app.Application.current.window.width / 3);
        graphics.drawRect(0, 0, daWidth, lime.app.Application.current.window.height);
        graphics.endFill();
    }
}