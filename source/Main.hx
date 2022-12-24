package;

import flixel.FlxGame;
import ui.FpsText;
import ui.LogHandler;
import openfl.display.Sprite;

#if sys
import sys.io.File;
import sys.FileSystem;
#end

class Main extends Sprite
{
	static public var buildNumber:Int;
	static public var log:LogHandler;

	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, states.menus.LoadingState));
		
		#if !mobile
		addChild(new FpsText(10, 3, 0xFFFFFF));
		addChild(log = new LogHandler());
		#end

		#if sys
		var path:String = 'assets/data/buildnum.txt';
		if (!FileSystem.exists(FileSystem.absolutePath(path))) {buildNumber = -1; return;}
		buildNumber = Std.parseInt(File.getContent(FileSystem.absolutePath(path))) + 1;
		File.saveContent(FileSystem.absolutePath(path), buildNumber + "");
		#end
	}
}