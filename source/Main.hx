package;

import flixel.FlxGame;
import ui.FpsText;
import ui.LogHandler;
import openfl.display.Sprite;
import handlers.Files;

#if sys
import sys.io.File;
import sys.FileSystem;
#end

#if html5
import handlers.ClientPrefs;
#end

class Main extends Sprite
{
	static public var buildNumber:Int;
	static public var log:LogHandler;

	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, states.menus.LoadingState));
		
		addChild(new FpsText(10, 3, 0xFFFFFF));
		addChild(log = new LogHandler());

		FlxG.signals.preStateSwitch.add(function(){
			FlxG.bitmap.dumpCache();
			FlxG.sound.destroy(false);

			#if cpp
			cpp.vm.Gc.enable(true);
			#else
			openfl.system.System.gc();
			#end
		});

		FlxG.signals.postStateSwitch.add(function(){
			#if cpp
			cpp.vm.Gc.enable(false);
			#else
			openfl.system.System.gc();
			#end
		});	

		#if (github_action || debug)
		#if sys
		var pathBack = #if windows
			"../../../../"
		#elseif mac
			"../../../../../../../"
		#else
			""
		#end; // thx yoshi lool
		
		if (Files.fileExists('./${pathBack}', 'buildnum', 'txt'))
		{
			var buildNum:Int = Std.parseInt(File.getContent('./${pathBack}buildnum.txt'));
			buildNum++;
			File.saveContent('./${pathBack}buildnum.txt', Std.string(buildNum));
			trace("Build number: " + buildNum);
		}
		#end
		#end

		#if html5
		ClientPrefs.fullscreen = true;
		ClientPrefs.autoPause = false;

		FlxG.mouse.visible = false;
		#end
	}
}