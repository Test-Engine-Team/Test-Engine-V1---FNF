package ui;

import handlers.Files;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import states.mainstates.PlayState;
import handlers.Conductor;

using StringTools;

class Note extends FlxSprite
{
	public var strumTime:Float = 0;
	public var noteData:Int = 0;
	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;
	public var doesMiss:Bool = true;
	public var jsonData:Array<Dynamic>;

	public var mustPress:Bool = false;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;

	public var noteScore:Float = 1;

	public static var swagWidth:Float = 160 * 0.7;

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false, ?params:scriptStuff.EventStructures.NoteCreateParams)
	{
		super();

		if (params == null) {
			//So I don't have to edit ChartingState.
			params = {
				makeNote: true,
				jsonData: [strumTime, noteData, 0],
				sectionData: {
					sectionNotes: [],
					lengthInSteps: 16,
					typeOfSection: 0,
					mustHitSection: true,
					bpm: Conductor.bpm,
					changeBPM: false,
					altAnim: false
				},
				spritePath: "NOTE_assets",
				holdSpritePath: null,
				antialiasing: true,
				canMiss: true,
				scale: 0.7,
				spriteType: "sparrow",
				animFPS: 24,
				noteAnims: ["purple0", "blue0", "green0", "red0"],
				holdAnims: ["purple hold piece", "blue hold piece", "green hold piece", "red hold piece"],
				tailAnims: ["pruple end hold", "blue hold end", "green hold end", "red hold end"]
			}
		}

		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		jsonData = params.jsonData;
		isSustainNote = sustainNote;
		doesMiss = params.canMiss;


		x += flixel.FlxG.width / 16;
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;
		this.strumTime = strumTime;

		this.noteData = noteData;

		switch (params.spriteType) {
			case "packer":
				frames = (isSustainNote && params.holdSpritePath != null) ? Files.packerAtlas(params.holdSpritePath) : Files.packerAtlas(params.spritePath);
				animation.addByPrefix("note", params.noteAnims[noteData], params.animFPS);
				animation.addByPrefix('hold', params.holdAnims[noteData], params.animFPS);
				animation.addByPrefix("tail", params.tailAnims[noteData], params.animFPS);
			case "grid":
				var spritePath = (isSustainNote) ? params.holdSpritePath : params.spritePath;
				var bitmapData:openfl.display.BitmapData = openfl.Assets.getBitmapData(Files.image(spritePath));
				loadGraphic(bitmapData, true, Std.int(bitmapData.width / 4), (isSustainNote) ? Std.int(bitmapData.height / 2) : Std.int(bitmapData.height / 5));
				animation.add("note", [noteData + 4], params.animFPS);
				animation.add("hold", [noteData], params.animFPS);
				animation.add("tail", [noteData + 4], params.animFPS);
			default:
				frames = (isSustainNote && params.holdSpritePath != null) ? Files.sparrowAtlas(params.holdSpritePath) : Files.sparrowAtlas(params.spritePath);
				animation.addByPrefix("note", params.noteAnims[noteData], params.animFPS);
				animation.addByPrefix('hold', params.holdAnims[noteData], params.animFPS);
				animation.addByPrefix("tail", params.tailAnims[noteData], params.animFPS);
		}

		antialiasing = params.antialiasing;
		scale.set(params.scale, params.scale);
		updateHitbox();
		x += swagWidth * noteData;
		animation.play("note");

		if (isSustainNote && prevNote != null)
		{
			noteScore * 0.2;
			alpha = 0.6;

			x += width / 2;

			animation.play("tail");
			updateHitbox();

			x -= width / 2;

			if (PlayState.curStage.startsWith('school'))
				x += 30;

			if (prevNote.isSustainNote)
			{
				prevNote.animation.play("hold");
				prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				prevNote.updateHitbox();
			}
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (mustPress)
		{
			// The * 0.5 us so that its easier to hit them too late, instead of too early
			if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset
				&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.5))
			{
				canBeHit = true;
			}
			else
				canBeHit = false;

			if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset)
				tooLate = true;
		}
		else
		{
			canBeHit = false;

			if (strumTime <= Conductor.songPosition)
			{
				wasGoodHit = true;
			}
		}

		if (tooLate)
		{
			if (alpha > 0.3)
				alpha = 0.3;
		}
	}
}
