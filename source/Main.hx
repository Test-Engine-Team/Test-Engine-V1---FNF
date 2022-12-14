package;

import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;
import states.menus.TitleState;
#if GAMEJOLT_SUPPORT
import GameJolt;
public static var gjToastManager:GJToastManager;
#end

class Main extends Sprite
{
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
	}
}
