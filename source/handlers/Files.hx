package handlers;

import openfl.Assets;
import lime.tools.AssetType;
import states.menus.TitleState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxG;
#if sys
import sys.FileSystem;
import polymod.Polymod;
#end
import handlers.ClientPrefs;

class Files {
	static var file:String;

	inline public static function image(image:String, folder:String = 'images') {
		return file = 'assets/$folder/$image.png';
	}

	inline public static function sound(sound:String, folder:String = 'sounds') {
		return file = 'assets/$folder/$sound.ogg';
	}

	inline public static function music(music:String, folder:String = 'music') {
		return file = 'assets/$folder/$music.ogg';
	}

	inline public static function song(song:String, folder:String = 'songs') {
		return file = 'assets/$folder/$song.ogg';
	}

	inline public static function font(font:String, ?extention:String = 'ttf') {
		if (font == '')
			font = ClientPrefs.defaultFont;

		#if html5
		extention = 'woff';
		#end
		return file = 'assets/fonts/$font.$extention';
	}

	inline public static function video(videoName:String) {
		return file = 'assets/videos/$videoName.mp4';
	}

	inline public static function songJson(songName:String, difficulty:String = 'Normal') {
		// kinda temp
		if (difficulty.toLowerCase() == 'normal')
			difficulty = "";

		var song:String = songName.toLowerCase();
		var diff:String;
		if (difficulty != "")
			diff = '-' + difficulty.toLowerCase();
		else
			diff = "";
		return file = 'assets/data/$song/$song$diff';
	}

	inline public static function sparrowAtlas(path:String, folder:String = 'images') {
		return FlxAtlasFrames.fromSparrow('assets/$folder/$path.png', 'assets/$folder/$path.xml');
	}

	inline public static function packerAtlas(path:String, folder:String = 'images') {
		return FlxAtlasFrames.fromSpriteSheetPacker('assets/$folder/$path.png', 'assets/$folder/$path.txt');
	}

	// public static function packerAtlas

	/*
		public static function fileExists(name:String, type:AssetType) {
			if(OpenFlAssets.exists(getPath(name, type)))
				return true;
			else 
				return false;
		}
		dumb stuff idk how to do properly */
	inline public static function txt(path:String) {
		return file = 'assets/$path.txt';
	}

	inline public static function randomSound(min:Int, max:Int, fileName:String) {
		return file = 'assets/sounds/$fileName' + FlxG.random.int(min, max) + '.ogg';
	}

	inline public static function songInst(songName:String) {
		var songFolder = songName.toLowerCase();
		return file = 'assets/songs/$songFolder/Inst.ogg';
	}

	inline public static function songVoices(songName:String) {
		var songFolder = songName.toLowerCase();
		return file = 'assets/songs/$songFolder/Voices.ogg';
	}

	inline public static function fileExists(path:String, name:String, extention:String) {
		return Assets.exists('assets/$path/$name.$extention');
	}

	#if sys
	public static function readFolder(folder:String) {
		var files:Array<String> = [];
		var directoriesToRead:Array<String> = [];
		if (FileSystem.exists(FileSystem.absolutePath('assets/$folder'))
			&& FileSystem.isDirectory(FileSystem.absolutePath('assets/$folder')))
			directoriesToRead.push(FileSystem.absolutePath('assets/$folder'));
		@:privateAccess for (modDir in Polymod.prevParams.dirs) {
			if (FileSystem.exists(FileSystem.absolutePath('$modDir/$folder'))
				&& FileSystem.isDirectory(FileSystem.absolutePath('$modDir/$folder')))
				directoriesToRead.push(FileSystem.absolutePath('$modDir/$folder'));
		}
		for (daDirectory in directoriesToRead) {
			for (file in FileSystem.readDirectory(daDirectory))
				files.push(file);
		}

		return files;
	}
	#end
}
