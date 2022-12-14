package;

import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;
import states.menus.TitleState;
#if officialBuild
import handlers.GameJolt;
#end

class Main extends Sprite
{
	#if officialBuild
	public static var gjToastManager:GJToastManager;
	#end
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, TitleState));
		
		#if GAMEEJOLT_SUPPORT
		gjToastManager = new GJToastManager();
		addChild(gjToastManager);
		#end

		#if !mobile
		addChild(new FPS(10, 3, 0xFFFFFF));
		#end

		//text.push('TEST ENGINE BETA - BUILD ${handlers.macros.BuildCounterMacro.getBuildNumber()}');
		//addChild(new handlers.macros.BuildCounterMacro.getBuildNumber())
	}
}
