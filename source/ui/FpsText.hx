package ui;

import external.fabric.engine.Utilities;
import external.memory.Memory;
import openfl.text.TextField;
import openfl.text.TextFormat;
#if gl_stats
import openfl.display._internal.stats.Context3DStats;
import openfl.display._internal.stats.DrawCallContext;
#end
#if flash
import openfl.Lib;
#end
#if MODS_ENABLED
import flixel.FlxG;
import states.menus.LoadingState;
#end

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class FpsText extends TextField
{
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var currentFPS(default, null):Int;

	@:noCompletion private var cacheCount:Int;
	@:noCompletion private var currentTime:Float;
	@:noCompletion private var times:Array<Float>;

	#if MODS_ENABLED
	var timeHeld:Float = 0;
	#end

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;

		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;
		autoSize = LEFT;
		defaultTextFormat = new TextFormat("_sans", 12, color);
		text = "FPS: ";

		cacheCount = 0;
		currentTime = 0;
		times = [];

		#if flash
		addEventListener(Event.ENTER_FRAME, function(e)
		{
			var time = Lib.getTimer();
			__enterFrame(time - currentTime);
		});
		#end
	}

	var textLength:Int = 0;
	// Event Handlers
	@:noCompletion
	private #if !flash override #end function __enterFrame(deltaTime:Float):Void
	{
		currentTime += deltaTime;
		times.push(currentTime);

		while (times[0] < currentTime - 1000)
		{
			times.shift();
		}

		var currentCount = times.length;
		currentFPS = Math.round((currentCount + cacheCount) / 2);

		if (currentCount != cacheCount /*&& visible*/)
		{
			#if debug
			text = '${currentFPS}FPS\n${Utilities.format_bytes(Memory.getCurrentUsage())} / ${Utilities.format_bytes(Memory.getPeakUsage())}\nBUILD: ${Main.buildNumber}';
			#else
			text = '${currentFPS}FPS\n${Utilities.format_bytes(Memory.getCurrentUsage())} / ${Utilities.format_bytes(Memory.getPeakUsage())}';
			#end

			#if (gl_stats && !disable_cffi && (!html5 || !canvas))
			text += "\ntotalDC: " + Context3DStats.totalDrawCalls();
			text += "\nstageDC: " + Context3DStats.contextDrawCalls(DrawCallContext.STAGE);
			text += "\nstage3DDC: " + Context3DStats.contextDrawCalls(DrawCallContext.STAGE3D);
			#end
			textLength = text.length;
		}

		#if MODS_ENABLED
		if (LoadingState.addedCrash) {
			text = text.substr(0, textLength) + "\n[F4] - Reparse Mod Data";
			timeHeld = (FlxG.keys.pressed.F4 && !Std.isOfType(FlxG.state, LoadingState)) ? timeHeld + deltaTime / 1000 : 0;
			if (timeHeld > 0)
				text += ' (' + (1 - timeHeld) + ')';
			if (timeHeld >= 1) {
				LoadingState.targetState = Type.getClass(FlxG.state);
				FlxG.switchState(new LoadingState());
			}
		}
		#end

		cacheCount = currentCount;
	}
}