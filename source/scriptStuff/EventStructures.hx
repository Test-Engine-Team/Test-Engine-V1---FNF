package scriptStuff;

import ui.Note;
import handlers.Character;

typedef NoteCreateParams = {
	var makeNote:Bool;
	var jsonData:Array<Dynamic>;
	var sectionData:Section;
	var spritePath:String;
	var holdSpritePath:Null<String>;
	var spriteType:String;
	var antialiasing:Bool;
	var canMiss:Bool;
	var botCanHit:Bool;
	var scale:Float;
	var animFPS:Int;
	var noteAnims:Array<String>;
	var holdAnims:Array<String>;
	var tailAnims:Array<String>;

	/**
	 * Just a helper var for hscript.
	 */
	var noteType:String;
}

typedef StrumCreateParams = {
	var id:Int;
	var player:Int;
	var scale:Float;
	var spritePath:String;
	var spriteType:String;
	var antialiasing:Bool;
	var tweenWhenCreated:Bool;
	var animFPS:Int;
	var glowAnims:Array<String>;
	var ghostAnims:Array<String>;
	var staticAnims:Array<String>;
}

typedef NoteHitParams = {
	var note:Note;
	var jsonData:Array<Dynamic>;
	var charForAnim:Character;
	var animToPlay:String;
	var enableZoom:Bool;
	var noteSplashes:Bool;
	var camMoveOnHit:Bool;
	var deleteNote:Bool;
	var strumGlow:Bool;
	var rateNote:Bool;
}
