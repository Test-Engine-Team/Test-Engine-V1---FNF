import flixel.math.FlxMath;

function createPost() {
	iconP1.y -= iconP1.y % 6;
	iconP2.y -= iconP2.y % 6;
}

function noteCreate(params) {
	params.spritePath = "weeb/pixelUI/arrows-pixels";
	params.holdSpritePath = "weeb/pixelUI/arrowEnds";
	params.spriteType = "grid";
	params.antialiasing = false;
	params.animFPS = 12;
	params.scale = 6;
}

//Sustains were all the way at the left of the arrow for some reason.
function noteCreatePost(note, sustainNotes) {
	//Sustain is offset by a pixel for 3 lanes.
	var weirdSustain:Bool = (!note.mustPress && note.noteData == 1) || (note.mustPress && note.noteData % 3 == 0);
	for (sus in sustainNotes) {
		sus.x += sus.width / 1.5;
		sus.x = sus.x - (sus.x % 6) + 6 * weirdSustain;
	}
}

function strumCreate(params) {
	params.spritePath = "weeb/pixelUI/arrows-pixels";
	params.spriteType = "grid";
	params.tweenWhenCreated = false;
	params.antialiasing = false;
	params.animFPS = 12;
	params.scale = 6;
}

var regOffX:Float;
var regOffY:Float;
function strumCreatePost(arrow) {
	arrow.x -= arrow.x % 6;
	arrow.y -= arrow.y % 6;
	regOffX = arrow.offset.x;
	regOffY = arrow.offset.y;
}

function updatePost() {
	for (i in 0...4)
		playerStrums.members[i].offset.set(regOffX - (regOffX % 6), regOffY - (regOffY % 6));

	for (icon in [iconP1, iconP2]) {
		icon.setGraphicSize(162 - (12 * Math.abs(curBeat % 2)));
		icon.updateHitbox();
		icon.x -= icon.x % 6;
		icon.offset.x -= icon.offset.x % 6;
		icon.offset.y -= icon.offset.y % 6;
	}
	//The custom bop messes up x a bit so doing this.
	iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - 26);
	iconP2.x -= iconP2.x % 6;

    for (note in notes.members) {
        note.x -= note.x % 6;
        note.y -= note.y % 6;
    }
}