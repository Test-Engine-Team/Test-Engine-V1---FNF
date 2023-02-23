package;

import haxe.Json;
import lime.utils.Assets;

using StringTools;

typedef SwagSong = {
	var song:String;
	var notes:Array<Section>;
	var bpm:Float;
	var needsVoices:Bool;
	var speed:Float;

	var player1:String;
	var player2:String;
	var gfVersion:Null<String>;
	var stage:Null<String>;
}

class Song {
	public var song:String;
	public var notes:Array<Section>;
	public var bpm:Float;
	public var needsVoices:Bool = true;
	public var speed:Float = 1;

	public var player1:String = 'bf';
	public var player2:String = 'dad';
	public var gfVersion:Null<String> = 'gf';
	public var stage:Null<String> = 'stage';

	public static function loadFromJson(jsonInput:String, ?folder:String):SwagSong {
		var rawJson = Assets.getText('assets/data/' + folder.toLowerCase() + '/' + jsonInput.toLowerCase() + '.json').trim();

		while (!rawJson.endsWith("}"))
			rawJson = rawJson.substr(0, rawJson.length - 1);

		if (rawJson == null)
			throw "Failed to load from JSON in " + jsonInput;

		return parseJSONshit(rawJson);
	}

	inline public static function parseJSONshit(rawJson:String):SwagSong
		return cast Json.parse(rawJson).song;
}
