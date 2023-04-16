package;

import flixel.FlxGame;
import ui.FpsText;
import ui.LogHandler;
import openfl.display.Sprite;
import handlers.Files;
import handlers.ClientPrefs;
import openfl.Lib;
#if sys
import sys.io.File;
import sys.FileSystem;
#end
#if html5
import handlers.ClientPrefs;
#end

class Main extends Sprite {
	static public var buildNumber:Int;
	static public var log:LogHandler;

	var game = {
		width: 1280, // WINDOW width
		height: 720, // WINDOW height
		initialState: states.menus.LoadingState, // initial game state
		zoom: -1.0, // game state bounds
		framerate: 60, // default framerate
		skipSplash: true, // if the default flixel splash screen should be skipped
		startFullscreen: false // if the game should start at fullscreen mode
	};

	public function new() {
		super();

		final stageWidth:Int = Lib.current.stage.stageWidth;
		final stageHeight:Int = Lib.current.stage.stageHeight;

		if (game.zoom == -1.0)
		{
			final ratioX:Float = stageWidth / game.width;
			final ratioY:Float = stageHeight / game.height;
			game.zoom = Math.min(ratioX, ratioY);
			game.width = Math.ceil(stageWidth / game.zoom);
			game.height = Math.ceil(stageHeight / game.zoom);
		}

		addChild(new FlxGame(game.width, game.height, game.initialState, #if (flixel < "5.0.0") game.zoom, #end game.framerate, game.framerate, 
			game.skipSplash, game.startFullscreen));

		addChild(new FpsText(10, 3, 0xFFFFFF));
		addChild(log = new LogHandler());

		// thanks Leather :D
		FlxG.signals.preStateSwitch.add(function() {
			FlxG.bitmap.mapCacheAsDestroyable();
			FlxG.bitmap.clearCache();

			FlxG.sound.list.forEachAlive(function(sound:flixel.system.FlxSound):Void {
				FlxG.sound.list.remove(sound, true);
				@:privateAccess
				FlxG.sound.destroySound(sound);
				sound.stop();
				sound.destroy();
			});
			FlxG.sound.list.clear();

			// if somehow the above code doesn't f*ing work lol
			FlxG.sound.destroy(false);

			// these two blocks of code basically do the same shit, except one is MUCH less lines lmao
			#if MODS_ENABLED
			polymod.Polymod.clearCache();
			#else
			// manually clear stuff from openfl and lime and all that
			var cache:openfl.utils.AssetCache = cast openfl.utils.Assets.cache;
			var lime_cache:lime.utils.AssetCache = cast lime.utils.Assets.cache;

			// this totally isn't copied from polymod/backends/OpenFLBackend.hx trust me
			for (key in cache.bitmapData.keys())
				cache.bitmapData.remove(key);
			for (key in cache.font.keys())
				cache.font.remove(key);
			@:privateAccess
			for (key in cache.sound.keys()) {
				cache.sound.get(key).close();
				cache.sound.remove(key);
			}

			// this totally isn't copied from polymod/backends/LimeBackend.hx trust me
			for (key in lime_cache.image.keys())
				lime_cache.image.remove(key);
			for (key in lime_cache.font.keys())
				lime_cache.font.remove(key);
			for (key in lime_cache.audio.keys()) {
				lime_cache.audio.get(key).dispose();
				lime_cache.audio.remove(key);
			};
			#end

			#if cpp
			cpp.vm.Gc.enable(true);
			#end

			openfl.system.System.gc();
		});

		#if (github_action || debug)
		#if sys
		var pathBack =
			#if windows
			"../../../../"
			#elseif mac
			"../../../../../../../"
			#else
			""
			#end; // thx yoshi lool

		if (Files.fileExists('./${pathBack}', 'buildnum', 'txt')) {
			var buildNum:Int = Std.parseInt(File.getContent('./${pathBack}buildnum.txt'));
			buildNum++;
			File.saveContent('./${pathBack}buildnum.txt', Std.string(buildNum));
			trace("Build number: " + buildNum);
		}
		#end
		#end

		// we need an actual option for this, instead of just this
		// FlxG.fullscreen = ClientPrefs.fullscreen;

		#if html5
		ClientPrefs.fullscreen = true;
		ClientPrefs.autoPause = FlxG.mouse.visible = false;
		#end
	}
}
