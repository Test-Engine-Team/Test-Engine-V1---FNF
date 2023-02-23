package handlers;

import flixel.util.FlxColor;

typedef ModDataYee = {
	var titleBar:String;
	var weekList:Array<ModWeekYee>;
	var charList:Array<GameCharData>;
	var charNames:Array<String>;
	var diaFormatList:Array<DialogueFormat>;
	var diaFormatNames:Array<String>;
	var diaPortaitList:Array<DialoguePortait>;
	var diaPortaitNames:Array<String>;
	var selectColor:FlxColor;
}

typedef DialogueFormat = {
	var y:Float;
	var textX:Float;
	var textY:Float;

	var boxSpritePath:String;
	var boxScale:Float;
	var boxAntialiasing:Bool;
	var anims:Array<GameCharAnim>; // NOOOOOOOOOOOOOOO! YOU CANT USE GameCharAnim! THATS ONLY FOR GAME CHARACTERS!
	var font:String;
	var textWidth:Int;
	var textSize:Int;
	var textColor:FlxColor;
	var borderEnabled:Bool;
	var borderColor:FlxColor;
	var dropShadow:Bool;
	var shadowColor:FlxColor;
}

typedef DialoguePortait = {
	var imagePath:String;
	var flipX:Bool;
	var antialiasing:Bool;
	var scale:Float;
	var xOffset:Float;
	var yOffset:Float;
}

typedef MenuCharData = {
	var spritePath:String;
	var idleAnim:String;
	var confirmAnim:Null<String>;
	var scale:Float;
	var xOffset:Float;
	var yOffset:Float;
	var flipX:Bool;
}

typedef GameCharData = {
	var spriteImage:String;
	var iconImage:String;
	var anims:Array<GameCharAnim>;
	var offsets:Array<Float>;
	var scale:Float;
	var scaleAffectsOffset:Bool;
	var flipX:Bool;
	var antialiasing:Bool;
	var singDur:Float;
	var regCharType:String;
	var hpColor:Null<FlxColor>;
}

// It's worrying how close this is to psych.
typedef GameCharAnim = {
	var name:String;
	var prefix:String;
	var looped:Bool;
	var fps:Int;
	var offsets:Array<Float>;
	var indices:Array<Int>;
}

typedef ModWeekYee = {
	var name:String;
	var spriteImage:String;
	var songs:Array<String>;
	var paths:Array<String>;
	var icons:Array<String>;
	var diffs:Array<String>;
	var chars:Array<MenuCharData>;
}
