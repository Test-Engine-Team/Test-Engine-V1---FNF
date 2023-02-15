package;

import flixel.FlxGame;
import ui.FpsText;
import ui.LogHandler;
import openfl.display.Sprite;
import handlers.Files;
import haxe.io.Input;
import haxe.io.BytesBuffer;

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
	static public var version:String = " 0.2.8.1.0";

	#if sys
	public static function readLine(buff:Input, l:Int):String {
		var line:Int = 0;
		var fuck = 0;
		while(fuck < l + 1) {
			var buf = new BytesBuffer();
			var last:Int = 0;
			var s = "";

			trace(line);
			while ((last = buff.readByte()) != 10) {
				buf.addByte(last);
			}
			s = buf.getBytes().toString();
			if (s.charCodeAt(s.length - 1) == 13)
				s = s.substr(0, -1);
			if (line >= l) {
				return s;
			} else {
				line++;
			}
		}
		return "";
	}
	#end

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

		#if html5
		ClientPrefs.fullscreen = true;
		ClientPrefs.autoPause = false;

		FlxG.mouse.visible = false;
		#end
	}
}