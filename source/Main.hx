package;

import flixel.FlxGame;
import ui.FpsText;
import openfl.display.Sprite;
import states.menus.TitleState;

#if sys
import sys.io.File;
#end

class Main extends Sprite
{
	static public var buildNumber:Int;

	public function new()
	{

		super();
		addChild(new FlxGame(0, 0, #if (desktop) states.menus.LoadingState #else TitleState #end));
		
		#if !mobile
		addChild(new FpsText(10, 3, 0xFFFFFF));
		#end

		#if sys
		var path:String = '../../../../buildnum.txt';
		buildNumber = Std.parseInt(File.getContent(sys.FileSystem.absolutePath(path))) + 1;
		File.saveContent(sys.FileSystem.absolutePath(path), buildNumber + "");
		#end
	}
}
